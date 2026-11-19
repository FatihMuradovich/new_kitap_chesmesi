import 'package:new_kitap_chesmesi/features/book/domain/model/comment_model.dart';

abstract class CommentRepository {
  Future<CommentModel> createComment(CommentCreateModel comment);
  Future<List<CommentModel>> getCommentsByBookId(int bookId);
}