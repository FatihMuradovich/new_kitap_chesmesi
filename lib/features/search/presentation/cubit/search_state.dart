import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<BookModel> books;
  final bool hasMore;
  final String query;

  SearchLoaded(
    this.books, {
    this.hasMore = false,
    this.query = '',
  });
}

class SearchLoadingMore extends SearchState {
  final List<BookModel> currentBooks;
  SearchLoadingMore(this.currentBooks);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
