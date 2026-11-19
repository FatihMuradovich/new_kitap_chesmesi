import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_detail_repository.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/getBookById/get_book_by_id_state.dart';

class GetBookByIdCubit extends Cubit<GetBookByIdState> {
  final BookDetailRepository bookDetailRepository;

  GetBookByIdCubit({required this.bookDetailRepository})
      : super(BookDetailInitial());

  Future<void> fetchBookById(int id) async {
    emit(BookDetailLoading());
    try {
      final book = await bookDetailRepository.getBookById(id);
      emit(BookDetailLoaded(book: book));
    } catch (e) {
      emit(BookDetailError(e.toString()));
    }
  }
}
