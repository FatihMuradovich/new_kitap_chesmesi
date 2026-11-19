import 'package:new_kitap_chesmesi/features/book/data/data_source/latest_book_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/latest_book_repository.dart';



class LatestBookRepositoryImpl implements LatestBookRepository {
  final LatestBookDataSource latestBookDataSource;

  LatestBookRepositoryImpl({required this.latestBookDataSource});

  @override
  Future<List<BookModel>> getRecentBooks() {
    return latestBookDataSource.fetchRecentBooks();
  }
}
