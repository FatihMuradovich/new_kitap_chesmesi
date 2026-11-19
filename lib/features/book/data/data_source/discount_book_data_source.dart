import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class DiscountBookDataSource {
  final DioClient dioSetting;

  DiscountBookDataSource({required this.dioSetting});

  Future<List<BookModel>> fetchDiscountedBooks({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dioSetting.dio.get('/book', queryParameters: {
        'discount': true,
        'page': page,
        'limit': limit,
      });
      if (response.statusCode == 200) {
        List<BookModel> books = (response.data['data'] as List)
            .map((book) => BookModel.fromMap(book))
            .toList();
        return books;
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Failed to load discounted books');
    }
  }
}
