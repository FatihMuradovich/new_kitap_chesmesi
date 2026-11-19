import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_by_author_repository.dart';
part 'book_by_author_id_state.dart';

class BookByAuthorIdCubit extends Cubit<BookByAuthorIdState> {
  final BookByAuthorRepository bookByAuthorRepository;

  BookByAuthorIdCubit({required this.bookByAuthorRepository})
      : super(BookByAuthorIdInitial());

  Future<void> fetchBookByAuthorId(int authorId) async {
    emit(BookByAuthorIdLoading());
    try {
      final books =
          await bookByAuthorRepository.fetchBookByAuthorId(authorId);
      emit(BookByAuthorIdLoaded(
        books: books,
      ));
    } catch (e) {
      emit(BookByAuthorIdError(message: e.toString()));
    }
  }
}
