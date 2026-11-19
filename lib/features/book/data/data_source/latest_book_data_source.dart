import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class LatestBookDataSource {
  final DioClient dioSetting;

  LatestBookDataSource({required this.dioSetting});

  
  Future<List<BookModel>> fetchRecentBooks() async {
    try {

      final response =
          await dioSetting.dio.get('/book', queryParameters: {'limit': 10});
      if (response.statusCode == 200) {
        List<BookModel> books = (response.data['data'] as List)
            .map((book) => BookModel.fromMap(book))
            .toList();
        return books;
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
 
      throw Exception('Error fetching books: $e');
    }
  }
}
