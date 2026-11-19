import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class SearchDataSource {
  final DioClient dioSetting;

  SearchDataSource({required this.dioSetting});

  Future<List<BookModel>> searchBooks(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dioSetting.dio.get(
        "/book",
        queryParameters: {
          "search": query,
          "page": page,
          "limit": limit,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Check if the response is successful
        if (responseData['success'] == true) {
          final List data = responseData['data'] as List;
          return data.map((e) => BookModel.fromMap(e)).toList();
        } else {
          throw Exception("API returned unsuccessful response");
        }
      } else {
        throw Exception("Failed to load books");
      }
    } catch (e) {
      throw Exception("Error while searching books: $e");
    }
  }
}
