import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/latest_book_repository.dart';
part 'latest_book_state.dart';

class LatestBookCubit extends Cubit<LatestBookState> {
  final LatestBookRepository bookRepository;
  LatestBookCubit(
    {required this.bookRepository}
  ) : super(LatestBookInitial());

  Future<void> fetchRecentBooks() async {
    emit(LatestBookLoading());
    try {
      final books = await bookRepository.getRecentBooks();
      emit(LatestBookLoaded(books));
    } catch (e) {
      emit(LatestBookError(e.toString()));
    }
  }
}


