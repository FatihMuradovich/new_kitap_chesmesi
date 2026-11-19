import 'package:new_kitap_chesmesi/features/book/data/data_source/book_publisher_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_publishers_page_result.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_publisher_repository.dart';

class BookPublisherRepositoryImpl implements BookPublisherRepository {
  final BookPublisherDataSource dataSource;

  BookPublisherRepositoryImpl({required this.dataSource});

  @override
  Future<BookPublishersPageResult> getPublishers({
    int page = 1,
    int limit = 20,
    String? search,
  }) {
    return dataSource.getPublishers(
      page: page,
      limit: limit,
      search: search,
    );
  }
}
