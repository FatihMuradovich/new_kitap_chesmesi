import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/favorite/data/data_source/favorite_data_source.dart';
import 'package:new_kitap_chesmesi/features/favorite/domain/repository/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteDataSoruce favoriteDataSource;

  FavoriteRepositoryImpl({required this.favoriteDataSource});

  @override
  Future<List<BookModel>> getFavoriteBooks() {
    return favoriteDataSource.getFavoriteBooks();
  }

  @override
  Future<bool> addFavorite(int bookId) {
    return favoriteDataSource.addFavorite(bookId);
  }

  @override
  Future<bool> removeFavorite(int bookId) {
    return favoriteDataSource.removeFavorite(bookId);
  }
}
