import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class BooksDataSource {
  final DioClient dioSetting;
  BooksDataSource({required this.dioSetting});

  Future<List<BookModel>> getCategories() async {
    try {
      final response = await dioSetting.dio.get('books/');
      if (response.statusCode == 200) {
        List<BookModel> books =
            (response.data as List)
                .map((book) => BookModel.fromJson(book))
                .toList();
        // print('Category $categories');
        return books;
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching books: $e');
    }
  }
}
