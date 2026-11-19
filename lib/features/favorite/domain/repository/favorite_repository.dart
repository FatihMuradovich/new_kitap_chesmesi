import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

abstract class FavoriteRepository {
  Future<List<BookModel>> getFavoriteBooks();
  Future<bool> addFavorite(int bookId);
  Future<bool> removeFavorite(int bookId);
}