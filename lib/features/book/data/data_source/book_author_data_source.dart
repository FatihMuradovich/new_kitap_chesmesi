import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_author_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_authors_page_result.dart';

class BookAuthorDataSource {
  final DioClient dioSetting;

  BookAuthorDataSource({required this.dioSetting});

  Future<BookAuthorsPageResult> getAuthors({
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
      '/author',
      queryParameters: queryParameters,
    );

    if (response.statusCode == 200) {
      final data = response.data['data'] as List;
      final authors = data
          .map((item) => BookAuthorModel.fromMap(item as Map<String, dynamic>))
          .toList();

      return BookAuthorsPageResult(
        authors: authors,
        hasMore: authors.length >= limit,
      );
    }

    throw Exception('Failed to load authors');
  }
}
