import 'package:new_kitap_chesmesi/features/book/data/data_source/books_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import '../../domain/repository/books_repository.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksDataSource dataSource;

  BooksRepositoryImpl({required this.dataSource});

  @override
  Future<List<BookModel>> fetchBooks() async {
    try {
      return await dataSource.getCategories();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}