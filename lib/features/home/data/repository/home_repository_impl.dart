import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/home/data/data_source/home_data_source.dart';
import 'package:new_kitap_chesmesi/features/home/domain/model/banner_model.dart';
import 'package:new_kitap_chesmesi/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeDataSource homeDataSource;
  HomeRepositoryImpl({
    required this.homeDataSource,
  });

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      return await homeDataSource.getBannerImages();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  @override
  Future<List<BookModel>> getRecentBooks() {
    return homeDataSource.fetchRecentBooks();
  }

  @override
  Future<List<BookModel>> getDiscountedBooks() {
    return homeDataSource.fetchDiscountedBooks();
  }

   @override
  Future<List<BookModel>> fetchBooksByLang(int languageId) async {
    return await homeDataSource.getBooksByLang(languageId);
  }

  @override
  Future<List<BookModel>> getBookByCategoryId(int categoryId) async {
    return await homeDataSource.getBookByCategoryId(categoryId);
  }

  @override
  Future<List<BookModel>> getUserRecommendedBooks() {
    return homeDataSource.getUserRecommendedBooks();
  }
}