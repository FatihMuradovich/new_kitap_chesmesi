part of 'discounted_book_cubit.dart';

abstract class DiscountedBookState extends Equatable {
  const DiscountedBookState();

  @override
  List<Object> get props => [];
}

class DiscountedBookInitial extends DiscountedBookState {}

class DiscountedBookLoading extends DiscountedBookState {}

class DiscountedBookLoaded extends DiscountedBookState {
  final List<BookModel> books;

  const DiscountedBookLoaded({required this.books});

  @override
  List<Object> get props => [books];
}

class DiscountedBookError extends DiscountedBookState {
  final String message;

  const DiscountedBookError({required this.message});

  @override
  List<Object> get props => [message];
}
