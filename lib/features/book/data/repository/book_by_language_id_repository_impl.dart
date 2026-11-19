// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:new_kitap_chesmesi/features/book/data/data_source/book_by_language_id_data_soruce.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_by_language_id_repository.dart';

class BookByLanguageIdRepositoryImpl implements BookByLanguageIdRepository {
  BookByLanguageIdDataSoruce bookByLanguageIdDataSoruce;
  BookByLanguageIdRepositoryImpl({
    required this.bookByLanguageIdDataSoruce,
  });

  @override
  Future<List<BookModel>> fetchBooksByLang(int languageId) async {
    return await bookByLanguageIdDataSoruce.getBooksByLang(languageId);
  }
}
