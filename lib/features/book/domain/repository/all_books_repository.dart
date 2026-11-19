import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

abstract class AllBooksRepository {
  Future<List<BookModel>> getAllBooks({
    int page = 1,
    int limit = 10,
    String? priceOrder,
    bool? mostPurchased,
    double? minPrice,
    double? maxPrice,
    List<int>? languageIds,
    List<int>? authorIds,
    List<int>? publisherIds,
  });
}

