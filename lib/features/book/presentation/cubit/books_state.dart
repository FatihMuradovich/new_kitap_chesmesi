part of 'books_cubit.dart';


abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object> get props => [];
}

class BooksInitial extends BookState {}

class BooksLoading extends BookState {}

class BooksLoaded extends BookState {
  final List<BookModel> books;

  const BooksLoaded({required this.books});

  @override
  List<Object> get props => [books];
}

class BookError extends BookState {
  final String message;

  const BookError({required this.message});

  @override
  List<Object> get props => [message];
}
