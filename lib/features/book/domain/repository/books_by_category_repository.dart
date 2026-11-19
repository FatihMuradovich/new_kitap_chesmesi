import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

abstract class BooksByCategoryRepository {
  Future<List<BookModel>> fetchBookByCategory(int subcategoryId);
  
}


