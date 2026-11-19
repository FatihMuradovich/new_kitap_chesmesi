import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

abstract class DiscountedBookRepository {
  Future<List<BookModel>> getDiscountedBooks({int page = 1, int limit = 10});
}
