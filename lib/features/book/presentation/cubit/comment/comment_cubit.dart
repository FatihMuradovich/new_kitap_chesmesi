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
      
      final createdComment = await commentRepository.createComment(commentCreateModel);
      emit(CommentCreated(comment: createdComment));
      
      // Yorumları yeniden yükle - hata olursa sadece log et, başarı mesajını etkileme
      try {
        await getCommentsByBookId(bookId);
      } catch (e) {
        debugPrint('Comment listesi yüklenirken hata: $e');
        // CommentCreated state'i zaten emit edildi, bu hata kullanıcıyı etkilemez
      }
    } catch (e) {
      debugPrint('Comment oluşturma hatası: $e');
      emit(CommentCreateError(message: e.toString()));
    }
  }

  void resetState() {
    emit(CommentInitial());
  }
}
