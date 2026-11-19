import 'package:flutter/foundation.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class BookDetailDataSource {
  final DioClient dioSetting;

  BookDetailDataSource({
    required this.dioSetting,
  });

  Future<BookModel> getBookById(int id) async {
    try {
      final response = await dioSetting.dio.get('/book/$id');
      if (response.statusCode == 200) {
        return BookModel.fromMap(response.data['data']);
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error fetching books: $e');
    }
  }
}
