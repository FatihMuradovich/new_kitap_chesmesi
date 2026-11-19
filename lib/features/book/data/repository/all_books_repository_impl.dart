import 'package:new_kitap_chesmesi/features/book/data/data_source/all_books_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/all_books_repository.dart';

class AllBooksRepositoryImpl implements AllBooksRepository {
  final AllBooksDataSource dataSource;

  AllBooksRepositoryImpl({required this.dataSource});

  @override
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
  }) async {
    try {
      return await dataSource.getAllBooks(
        page: page,
        limit: limit,
        priceOrder: priceOrder,
        mostPurchased: mostPurchased,
        minPrice: minPrice,
        maxPrice: maxPrice,
        languageIds: languageIds,
        authorIds: authorIds,
        publisherIds: publisherIds,
      );
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}

