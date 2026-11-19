import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class BooksByCategoryDataSource {
  final DioClient dioSetting;
  BooksByCategoryDataSource({required this.dioSetting});

  static const int _pageLimit = 100;

  Future<List<BookModel>> getBooksBySubcategory(int subcategoryId) async {
    try {
      final matchedBooks = <BookModel>[];
      int page = 1;

      while (true) {
        final response = await dioSetting.dio.get(
          '/book',
          queryParameters: {
            'page': page,
            'limit': _pageLimit,
          },
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to load books');
        }

        final data = response.data['data'] as List;
        if (data.isEmpty) break;

        final books = data
            .map((book) => BookModel.fromMap(book as Map<String, dynamic>))
            .where((book) => book.belongsToSubcategory(subcategoryId))
            .toList();
        matchedBooks.addAll(books);

        if (data.length < _pageLimit) break;
        page++;
      }

      return matchedBooks;
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }
}
