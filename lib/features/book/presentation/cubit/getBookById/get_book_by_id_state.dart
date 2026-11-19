import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

abstract class GetBookByIdState {}

class BookDetailInitial extends GetBookByIdState {}

class BookDetailLoading extends GetBookByIdState {}

class BookDetailLoaded extends GetBookByIdState {
  final BookModel book;

  BookDetailLoaded({required this.book});
}

class BookDetailError extends GetBookByIdState {
  final String message;

  BookDetailError(this.message);
}
