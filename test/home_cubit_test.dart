import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/home/domain/model/banner_model.dart';
import 'package:new_kitap_chesmesi/features/home/domain/repository/home_repository.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/home/home_cubit.dart';

BookModel _book(int id) => BookModel(
      id: id,
      name: 'Kitap $id',
      price: '10',
      status: 'Available',
      createdAt: null,
      stock: 1,
      images: const [],
    );

/// [failing] true ise tüm çağrılar [error] fırlatır; değilse yalnızca
/// [failRecent] true olduğunda yeni kitaplar başarısız olur.
class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository(
      {this.failing = false, this.failRecent = false, Object? error})
      : error = error ?? Exception('fail');

  bool failing;
  final bool failRecent;
  final Object error;

  Future<List<T>> _run<T>(List<T> value) async {
    if (failing) throw error;
    return value;
  }

  @override
  Future<List<BannerModel>> getBanners() => _run(<BannerModel>[]);
  @override
  Future<List<BookModel>> getRecentBooks() =>
      failRecent ? Future.error(error) : _run([_book(1)]);
  @override
  Future<List<BookModel>> getDiscountedBooks() => _run(<BookModel>[]);
  @override
  Future<List<BookModel>> fetchBooksByLang(int languageId) => _run([_book(2)]);
  @override
  Future<List<BookModel>> getBookByCategoryId(int categoryId) =>
      _run(<BookModel>[]);
  @override
  Future<List<BookModel>> getUserRecommendedBooks() => _run(<BookModel>[]);
}

DioException _offline() => DioException(
      requestOptions: RequestOptions(path: 'book'),
      type: DioExceptionType.connectionError,
    );

void main() {
  test('Tüm istekler başarısızsa boş sayfa değil hata durumu gösterilir',
      () async {
    final cubit = HomeCubit(
        homeRepository: _FakeHomeRepository(failing: true, error: _offline()));

    await cubit.loadHomeData();

    expect(cubit.state, isA<HomeError>());
  });

  test('Bir bölüm başarısızsa diğerleri yine gösterilir', () async {
    final cubit =
        HomeCubit(homeRepository: _FakeHomeRepository(failRecent: true));

    await cubit.loadHomeData();

    final state = cubit.state as HomeLoaded;
    expect(state.newBooks, isEmpty);
    expect(state.booksByLang, hasLength(1));
  });

  test('Sessiz yenileme başarısızsa mevcut veri korunur', () async {
    final repo = _FakeHomeRepository();
    final cubit = HomeCubit(homeRepository: repo);
    await cubit.loadHomeData();
    expect(cubit.state, isA<HomeLoaded>());

    repo.failing = true;
    await cubit.loadHomeData(silentRefresh: true);

    expect(cubit.state, isA<HomeLoaded>());
    expect((cubit.state as HomeLoaded).booksByLang, hasLength(1));
  });
}
