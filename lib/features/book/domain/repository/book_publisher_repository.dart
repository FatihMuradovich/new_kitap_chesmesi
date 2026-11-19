import 'package:new_kitap_chesmesi/features/book/domain/model/book_publishers_page_result.dart';

abstract class BookPublisherRepository {
  Future<BookPublishersPageResult> getPublishers({
    int page = 1,
    int limit = 20,
    String? search,
  });
}
