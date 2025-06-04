import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/books_repository.dart';
part 'books_state.dart';

class BooksCubit extends Cubit<BookState> {
  final BooksRepository repository;

  BooksCubit({required this.repository}) : super(BooksInitial());

  Future<void> fetchBooks() async {
    emit(BooksLoading());
    try {
      final books = await repository.fetchBooks();
      emit(BooksLoaded(books: books));
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }
}