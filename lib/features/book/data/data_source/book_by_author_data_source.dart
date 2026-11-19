import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class BookByAuthorDataSource {
  final DioClient dioSetting;

  BookByAuthorDataSource({required this.dioSetting});

  Future<List<BookModel>> fetchBookByAuthorId(
     int authorId) async {
    try {
      final response = await dioSetting.dio.get('/book', queryParameters: {
        // API yalnızca çoğul `authorIds` ile filtreliyor; tekil `authorId`
        // parametresi yok sayılıp tüm kitaplar dönüyor.
        'authorIds': authorId,
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
