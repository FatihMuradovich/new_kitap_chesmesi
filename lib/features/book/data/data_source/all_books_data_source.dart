import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class AllBooksDataSource {
  final DioClient dioSetting;

  AllBooksDataSource({required this.dioSetting});

  Future<List<BookModel>> getAllBooks({
    int page = 1,
    int limit = 10,
    String? priceOrder,
    bool? mostPurchased,
    double? minPrice,
    double? maxPrice,
    List<int>? languageIds,
    List<int>? authorIds,
    List<int>? publisherIds,
    // ÖZEL SİPARİŞ — geçici olarak kapatıldı (§2 `status`/`specialOrderable`).
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (priceOrder != null) {
        queryParameters['priceOrder'] = priceOrder;
      }
      if (mostPurchased == true) {
        queryParameters['mostPurchased'] = true;
      }
      if (minPrice != null) {
        queryParameters['minPrice'] = minPrice;
      }
      if (maxPrice != null) {
        queryParameters['maxPrice'] = maxPrice;
      }
      if (languageIds != null && languageIds.isNotEmpty) {
        queryParameters['languageIds'] = languageIds.join(',');
      }
      if (authorIds != null && authorIds.isNotEmpty) {
        queryParameters['authorIds'] = authorIds.join(',');
      }
      if (publisherIds != null && publisherIds.isNotEmpty) {
        queryParameters['publisherIds'] = publisherIds.join(',');
      }

      final response = await dioSetting.dio.get(
        '/book',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        List<BookModel> books = (response.data['data'] as List)
            .map((book) => BookModel.fromMap(book))
            .toList();
        return books;
      } else {
        throw Exception('Failed to load all books');
      }
    } catch (e) {
      throw Exception('Error fetching all books: $e');
    }
  }
}
