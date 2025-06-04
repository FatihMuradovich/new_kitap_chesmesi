
import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';



abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class BooksInitial extends SearchState {}

class BooksLoaded extends SearchState {
  final List<BookModel> books;

  const BooksLoaded(this.books);

  @override
  List<Object> get props => [books];
}

class BooksError extends SearchState {
  final String message;

  const BooksError(this.message);

  @override
  List<Object> get props => [message];
}
