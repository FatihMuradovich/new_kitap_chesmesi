import 'package:new_kitap_chesmesi/features/book/data/data_source/comment_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/comment_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentDataSource commentDataSource;

  CommentRepositoryImpl({required this.commentDataSource});

  @override
  Future<CommentModel> createComment(CommentCreateModel comment) async {
    return await commentDataSource.createComment(comment);
  }

  @override
  Future<List<CommentModel>> getCommentsByBookId(int bookId) async {
    return await commentDataSource.getCommentsByBookId(bookId);
  }
}
