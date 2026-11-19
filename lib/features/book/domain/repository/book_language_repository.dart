import 'package:new_kitap_chesmesi/features/book/domain/model/book_language_model.dart';

abstract class BookLanguageRepository {
  Future<List<BookLanguageModel>> getLanguages();
}
