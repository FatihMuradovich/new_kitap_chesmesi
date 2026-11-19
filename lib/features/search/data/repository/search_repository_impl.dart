import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/search/data/data_source/search_data_source.dart';
import 'package:new_kitap_chesmesi/features/search/domain/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDataSource searchDataSource;

  SearchRepositoryImpl({required this.searchDataSource});

  @override
  Future<List<BookModel>> searchBooks(
    String query, {
    int page = 1,
    int limit = 20,
  }) {
    return searchDataSource.searchBooks(query, page: page, limit: limit);
  }
}
