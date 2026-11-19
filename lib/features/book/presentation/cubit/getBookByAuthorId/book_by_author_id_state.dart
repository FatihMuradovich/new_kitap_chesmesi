part of 'book_by_author_id_cubit.dart';


abstract class BookByAuthorIdState extends Equatable {
  const BookByAuthorIdState();

  @override
  List<Object> get props => [];
}

class BookByAuthorIdInitial extends BookByAuthorIdState {}

class BookByAuthorIdLoading extends BookByAuthorIdState {}

class BookByAuthorIdLoaded extends BookByAuthorIdState {
  final List<BookModel> books;


  const BookByAuthorIdLoaded({required this.books});

  @override
  List<Object> get props => [books];
}

class BookByAuthorIdError extends BookByAuthorIdState {
  final String message;

  const BookByAuthorIdError({required this.message});

  @override
  List<Object> get props => [message];
}
