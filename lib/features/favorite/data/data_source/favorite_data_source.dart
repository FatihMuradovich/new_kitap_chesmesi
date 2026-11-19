import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class FavoriteDataSoruce {
  final DioClient dioSetting;

  FavoriteDataSoruce({required this.dioSetting});

  Future<List<BookModel>> getFavoriteBooks() async {
    try {
      final token = await dioSetting.getToken();

      final response = await dioSetting.dio.get(
        '/user/favorite',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        try {
          List<BookModel> favoriteBooks = (response.data['data'] as List)
              .map((book) => BookModel.fromMap(book))
              .toList();
          return favoriteBooks;
        } catch (e, trace) {
          debugPrint(e.toString());
          debugPrint(trace.toString());
        }
        List<BookModel> favoriteBooks = (response.data['data'] as List)
            .map((book) => BookModel.fromMap(book))
            .toList();
        return favoriteBooks;
      } else {
        // print('API Error: ${response.statusCode}');
        // print('Response data: ${response.data}');
        throw Exception('Failed to load books');
      }
    } catch (e) {
      // print('error: $e');
      throw Exception('Failed to load books: $e');
    }
  }

  Future<bool> addFavorite(int bookId) async {
    try {
      final response = await dioSetting.dio.post(
        '/user/favorite',
        data: {'bookId': bookId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to add favorite: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Add favorite error: $e');
      throw Exception('Failed to add favorite: $e');
    }
  }

  Future<bool> removeFavorite(int bookId) async {
    try {
      final response = await dioSetting.dio.delete(
        '/user/favorite/$bookId',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to remove favorite: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Remove favorite error: $e');
      throw Exception('Failed to remove favorite: $e');
    }
  }
}
