part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<BannerModel> banners;
  final List<BookModel> userBooks;
  final List<BookModel> newBooks;
  final List<BookModel> discountBooks;
  final List<BookModel> booksByLang;
  final List<BookModel> bookByCategoryId;
  final List<BookModel> bookByCategoryIdLiterature;

  // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
  // /// "Getirtebiliriz" — `status=Finished` + `specialOrderable=true`.
  // /// Diğer listelerin aksine `available` filtresinden GEÇMEZ.
  // final List<BookModel> specialOrderableBooks;
  HomeLoaded({
    required this.banners,
    required this.userBooks,
    required this.newBooks,
    required this.discountBooks,
    required this.booksByLang,
    required this.bookByCategoryId,
    required this.bookByCategoryIdLiterature,
    // this.specialOrderableBooks = const [],
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
