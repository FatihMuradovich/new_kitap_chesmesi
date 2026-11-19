import 'package:new_kitap_chesmesi/features/book/data/data_source/books_by_category_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import '../../domain/repository/books_by_category_repository.dart';

class BooksByCategoryRepositoryImpl implements BooksByCategoryRepository {
  final BooksByCategoryDataSource booksByCategoryDataSource;

  BooksByCategoryRepositoryImpl({required this.booksByCategoryDataSource});

  @override
  Future<List<BookModel>> fetchBookByCategory(
       int subcategoryId) async {
    try {
      return await booksByCategoryDataSource.getBooksBySubcategory(
          subcategoryId);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
