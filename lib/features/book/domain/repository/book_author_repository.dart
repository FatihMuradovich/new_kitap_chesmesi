import 'package:new_kitap_chesmesi/features/book/domain/model/book_authors_page_result.dart';

abstract class BookAuthorRepository {
  Future<BookAuthorsPageResult> getAuthors({
    int page = 1,
    int limit = 20,
    String? search,
  });
}
