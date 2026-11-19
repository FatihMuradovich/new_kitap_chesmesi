import 'package:new_kitap_chesmesi/features/book/data/data_source/book_language_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_language_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_language_repository.dart';

class BookLanguageRepositoryImpl implements BookLanguageRepository {
  final BookLanguageDataSource dataSource;

  BookLanguageRepositoryImpl({required this.dataSource});

  @override
  Future<List<BookLanguageModel>> getLanguages() {
    return dataSource.getLanguages();
  }
}
