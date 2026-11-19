import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

abstract class BookByAuthorRepository {
    Future<List<BookModel>> fetchBookByAuthorId(int authorId);
}