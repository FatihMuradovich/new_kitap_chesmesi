import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/common/utils/load_result.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/home/domain/model/banner_model.dart';
import 'package:new_kitap_chesmesi/features/home/domain/repository/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;

  HomeCubit({required this.homeRepository}) : super(HomeInitial());

  Future<void> loadHomeData({bool silentRefresh = false}) async {
    // Eğer silent refresh ise ve zaten data yüklenmişse, loading gösterme
    if (!silentRefresh || state is! HomeLoaded) {
      emit(HomeLoading());
    }

    final fBanners = safeLoadList(() => homeRepository.getBanners());
    final fUserBooks =
        safeLoadList(() => homeRepository.getUserRecommendedBooks());
    final fNewBooks = safeLoadList(() => homeRepository.getRecentBooks());
    final fDiscountBooks =
        safeLoadList(() => homeRepository.getDiscountedBooks());
    final fBooksByLang =
        safeLoadList(() => homeRepository.fetchBooksByLang(4));
    final fBookByCategoryId =
        safeLoadList(() => homeRepository.getBookByCategoryId(6));
    final fBookByCategoryIdLiterature =
        safeLoadList(() => homeRepository.getBookByCategoryId(1));

    final banners = (await fBanners).valueOrEmpty;
    final userBooks = (await fUserBooks).valueOrEmpty;
    final newBooks = (await fNewBooks).valueOrEmpty;
    final discountBooks = (await fDiscountBooks).valueOrEmpty;
    final booksByLang = (await fBooksByLang).valueOrEmpty;
    final bookByCategoryId = (await fBookByCategoryId).valueOrEmpty;
    final bookByCategoryIdLiterature =
        (await fBookByCategoryIdLiterature).valueOrEmpty;

    // Filter books by status - only show "Available" books
    final filteredNewBooks = newBooks
        .where((book) => book.status.toLowerCase() == 'available')
        .toList();
    final filteredUserBooks = userBooks
        .where((book) => book.status.toLowerCase() == 'available')
        .toList();

    // Filter discount books - must have valid discount and be available
    final filteredDiscountBooks = discountBooks.where((book) {
      final isAvailable = book.status.toLowerCase() == 'available';
      final hasDiscount = book.discount != null && book.discount!.isNotEmpty;
      final hasDiscountType =
          book.discountType != null && book.discountType!.isNotEmpty;
      final hasValidDiscountValue = book.discountValue > 0;
      return isAvailable &&
          hasDiscount &&
          hasDiscountType &&
          hasValidDiscountValue;
    }).toList();

    final filteredBooksByLang = booksByLang
        .where((book) => book.status.toLowerCase() == 'available')
        .toList();
    final filteredBookByCategoryId = bookByCategoryId
        .where((book) => book.status.toLowerCase() == 'available')
        .toList();
    final filteredBookByCategoryIdLiterature = bookByCategoryIdLiterature
        .where((book) => book.status.toLowerCase() == 'available')
        .toList();

    emit(HomeLoaded(
      banners: banners,
      userBooks: filteredUserBooks,
      newBooks: filteredNewBooks,
      discountBooks: filteredDiscountBooks,
      booksByLang: filteredBooksByLang,
      bookByCategoryId: filteredBookByCategoryId,
      bookByCategoryIdLiterature: filteredBookByCategoryIdLiterature,
    ));
  }
}
