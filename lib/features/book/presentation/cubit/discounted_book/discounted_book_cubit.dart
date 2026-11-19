import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/discounted_book_repository.dart';
part 'discounted_book_state.dart';

class DiscountedBookCubit extends Cubit<DiscountedBookState> {
  final DiscountedBookRepository discountedBookRepository;

  DiscountedBookCubit({required this.discountedBookRepository }) : super(DiscountedBookInitial());

  Future<void> fetchDiscountedBooks(
   ) async {
    emit(DiscountedBookLoading());
    try {
      final books =
          await discountedBookRepository.getDiscountedBooks();
      
      // Filter discount books - must have valid discount and be available
      final validDiscountBooks = books.where((book) {
        final isAvailable = book.status.toLowerCase() == 'available';
        final hasDiscount = book.discount != null && book.discount!.isNotEmpty;
        final hasDiscountType = book.discountType != null && book.discountType!.isNotEmpty;
        final hasValidDiscountValue = book.discountValue > 0;
        return isAvailable && hasDiscount && hasDiscountType && hasValidDiscountValue;
      }).toList();
      
      emit(DiscountedBookLoaded(
        books: validDiscountBooks,
      ));
    } catch (e) {
      emit(DiscountedBookError(message: e.toString()));
    }
  }
}
