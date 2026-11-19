// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/home/domain/model/banner_model.dart';

abstract class HomeRepository {
  Future<List<BannerModel>> getBanners();
  Future<List<BookModel>> getRecentBooks();
  Future<List<BookModel>> getDiscountedBooks();
  Future<List<BookModel>> fetchBooksByLang(int languageId);
  Future<List<BookModel>> getBookByCategoryId(int categoryId);
  Future<List<BookModel>> getUserRecommendedBooks();
  // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
  // Future<List<BookModel>> getSpecialOrderableBooks();
}
