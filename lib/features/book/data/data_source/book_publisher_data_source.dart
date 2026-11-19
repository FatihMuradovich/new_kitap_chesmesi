import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_publisher_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_publishers_page_result.dart';

class BookPublisherDataSource {
  final DioClient dioSetting;

  BookPublisherDataSource({required this.dioSetting});

  Future<BookPublishersPageResult> getPublishers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    final trimmedSearch = search?.trim();
    if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
      queryParameters['search'] = trimmedSearch;
    }

    final response = await dioSetting.dio.get(
      '/publisher',
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] as List;
      final publishers = data
          .map((item) =>
              BookPublisherModel.fromMap(item as Map<String, dynamic>))
          .toList();

      return BookPublishersPageResult(
        publishers: publishers,
        hasMore: publishers.length >= limit,
      );
    }

    throw Exception('Failed to load publishers');
  }
}
