
import 'package:new_kitap_chesmesi/features/book/data/data_source/book_by_author_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_by_author_repository.dart';

class BookByAuthorRepositoryImpl implements BookByAuthorRepository {
  final BookByAuthorDataSource bookByAuthorDataSource;

  BookByAuthorRepositoryImpl({required this.bookByAuthorDataSource});

  @override
  Future<List<BookModel>> fetchBookByAuthorId(
   int authorId) async {
    try {
      return await bookByAuthorDataSource.fetchBookByAuthorId(
           authorId);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
