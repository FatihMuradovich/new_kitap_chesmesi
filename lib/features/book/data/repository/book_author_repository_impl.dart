import 'package:new_kitap_chesmesi/features/book/data/data_source/book_author_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_authors_page_result.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_author_repository.dart';

class BookAuthorRepositoryImpl implements BookAuthorRepository {
  final BookAuthorDataSource dataSource;

  BookAuthorRepositoryImpl({required this.dataSource});

  @override
  Future<BookAuthorsPageResult> getAuthors({
    int page = 1,
    int limit = 20,
    String? search,
  }) {
    return dataSource.getAuthors(
      page: page,
      limit: limit,
      search: search,
    );
  }
}
