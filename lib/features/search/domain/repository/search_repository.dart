import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

abstract class SearchRepository {
  Future<List<BookModel>> searchBooks(
    String query, {
    int page,
    int limit,
  });
}
