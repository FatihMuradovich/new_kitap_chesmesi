
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

abstract class BooksRepository {
  Future<List<BookModel>> fetchBooks();
}
