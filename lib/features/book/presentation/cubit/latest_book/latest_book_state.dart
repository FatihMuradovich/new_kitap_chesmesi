part of 'latest_book_cubit.dart';

abstract class LatestBookState {}

class LatestBookInitial extends LatestBookState {}

class LatestBookLoading extends LatestBookState {}

class LatestBookLoaded extends LatestBookState {
  final List<BookModel> books;

  LatestBookLoaded(this.books);
}

class LatestBookError extends LatestBookState {
  final String message;

  LatestBookError(this.message);
}
