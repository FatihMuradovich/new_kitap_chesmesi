import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

abstract class BookByLanguageIdRepository {
   Future<List<BookModel>> fetchBooksByLang(int languageId);
}