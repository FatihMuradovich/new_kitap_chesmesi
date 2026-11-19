import 'package:new_kitap_chesmesi/features/book/data/data_source/discount_book_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/discounted_book_repository.dart';

class DiscountedBookRepositoryImpl implements DiscountedBookRepository {
  final DiscountBookDataSource discountBookDataSource;

  DiscountedBookRepositoryImpl({required this.discountBookDataSource});

  @override
  Future<List<BookModel>> getDiscountedBooks({int page = 1, int limit = 10}) {
    return discountBookDataSource.fetchDiscountedBooks(page: page, limit: limit);
  }
}
