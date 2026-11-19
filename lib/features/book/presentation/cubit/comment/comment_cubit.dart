import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/comment_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/comment_repository.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/comment/comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository commentRepository;

  CommentCubit({
    required this.commentRepository,
  }) : super(CommentInitial());

  Future<void> getCommentsByBookId(int bookId) async {
    try {
      emit(CommentLoading());
      final comments = await commentRepository.getCommentsByBookId(bookId);
      emit(CommentLoaded(comments: comments));
    } catch (e) {
      emit(CommentError(message: e.toString()));
    }
  }

  Future<void> createComment({
    required String comment,
    required double rating,
    required int bookId,
  }) async {
    try {
      emit(CommentCreateLoading());
      final commentCreateModel = CommentCreateModel(
        comment: comment,
        rating: rating,
        bookId: bookId,
      );

      final createdComment =
          await commentRepository.createComment(commentCreateModel);
      // Listeyi yenilemek çağıran sayfanın işi (pop(true) sonrası). Burada
      // yenilemek, sayfa kapanıp cubit kapatıldıktan sonra emit'e yol açar.
      emit(CommentCreated(comment: createdComment));
    } catch (e) {
      debugPrint('Comment oluşturma hatası: $e');
      emit(CommentCreateError(message: e.toString()));
    }
  }

  void resetState() {
    emit(CommentInitial());
  }
}
