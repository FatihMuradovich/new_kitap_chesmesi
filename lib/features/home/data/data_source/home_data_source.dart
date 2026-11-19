// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/home/domain/model/banner_model.dart';

class HomeDataSource {
  final DioClient dioSetting;
  HomeDataSource({
    required this.dioSetting,
  });

  Future<List<BannerModel>> getBannerImages() async {
    try {
      final response = await dioSetting.dio.get('/banner');
      if (response.statusCode == 200) {
        List<BannerModel> bannerImages = (response.data['data'] as List)
            .map((banner) => BannerModel.fromMap(banner))
            .toList();
        // print('Category $categories');
        return bannerImages;
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error fetching books: $e');
    }
  }

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

  Future<List<BookModel>> getBooksByLang(int languageId) async {
    try {
      final response = await dioSetting.dio.get(
        "/book",
        // API yalnızca çoğul `languageIds` ile filtreliyor; tekil `languageId`
        // parametresi yok sayılıp tüm kitaplar dönüyor.
        queryParameters: {"languageIds": languageId},
      );

      if (response.statusCode == 200) {
        final List data = response.data["data"];
        return data.map((json) => BookModel.fromMap(json)).toList();
      } else {
        throw Exception("Kitapları getirme başarısız");
      }
    } catch (e) {
      throw Exception("API hatası: $e");
    }
  }

  Future<List<BookModel>> getBookByCategoryId(int categoryId) async {
    try {
      final response = await dioSetting.dio.get(
        "/book",
        // API yalnızca çoğul `categoryIds` ile filtreliyor; tekil `categoryId`
        // parametresi yok sayılıp tüm kitaplar dönüyor.
        queryParameters: {"categoryIds": categoryId},
      );

      if (response.statusCode == 200) {
        final List data = response.data["data"];
        return data.map((json) => BookModel.fromMap(json)).toList();
      } else {
        throw Exception("Kitapları getirme başarısız");
      }
    } catch (e) {
      throw Exception("API hatası: $e");
    }
  }

  /// Kullanıcıya özel önerilen kitaplar
  Future<List<BookModel>> getUserRecommendedBooks() async {
    try {
      final response = await dioSetting.dio.get('/user/books');
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.map((json) => BookModel.fromMap(json)).toList();
        }
        return [];
      }
      // 200 dışındaki durumlarda da boş liste dön (home ekranı çökmesin)
      return [];
    } catch (e) {
      // Backend şu an 500 dökse bile ana sayfanın tamamen çökmesini istemiyoruz.
      // Bu durumda sadece önerilen kitaplar bölümünü gizlemek için boş liste döndürüyoruz.
      return [];
    }
  }
}
