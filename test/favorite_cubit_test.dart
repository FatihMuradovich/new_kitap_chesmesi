import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/favorite/domain/repository/favorite_repository.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_cubit.dart';

BookModel _book(int id) => BookModel(
      id: id,
      name: 'Kitap $id',
      price: '10',
      status: 'Available',
      createdAt: null,
      stock: 1,
      images: const [],
    );

/// Sunucudaki favori listesini taklit eder.
class _FakeFavoriteRepository implements FavoriteRepository {
  _FakeFavoriteRepository(Set<int> ids, {this.offline = false})
      : serverIds = {...ids};

  final Set<int> serverIds;
  bool offline;
  final List<String> calls = [];

  @override
  Future<List<BookModel>> getFavoriteBooks() async {
    calls.add('list');
    if (offline) throw Exception('offline');
    return serverIds.map(_book).toList();
  }

  @override
  Future<bool> addFavorite(int bookId) async {
    calls.add('add $bookId');
    return serverIds.add(bookId);
  }

  @override
  Future<bool> removeFavorite(int bookId) async {
    calls.add('remove $bookId');
    return serverIds.remove(bookId);
  }
}

void main() {
  test(
      'Liste henüz yüklenmemişken favori kitabın kalbine basmak onu çıkarır '
      '(tekrar eklemeye çalışmaz)', () async {
    final repo = _FakeFavoriteRepository({42});
    final cubit = FavoriteCubit(favoriteRepository: repo);

    await cubit.toggleFavorite(42);

    expect(repo.calls, isNot(contains('add 42')));
    expect(repo.calls, contains('remove 42'));
    expect(repo.serverIds, isEmpty);
    expect(cubit.isBookFavorite(42), isFalse);
    await cubit.close();
  });

  test('Liste yüklenemezse (internet yok) kalbe basmak hiçbir işlem yapmaz',
      () async {
    final repo = _FakeFavoriteRepository({42}, offline: true);
    final cubit = FavoriteCubit(favoriteRepository: repo);

    await cubit.toggleFavorite(42);

    expect(repo.calls.where((c) => c != 'list'), isEmpty);
    expect(repo.serverIds, {42});
    await cubit.close();
  });

  test('Liste yüklüyken favori olmayan kitap eklenir', () async {
    final repo = _FakeFavoriteRepository({42});
    final cubit = FavoriteCubit(favoriteRepository: repo);
    await cubit.getFavoriteBooks();

    await cubit.toggleFavorite(7);

    expect(repo.serverIds, {42, 7});
    expect(cubit.isBookFavorite(7), isTrue);
    await cubit.close();
  });
}
