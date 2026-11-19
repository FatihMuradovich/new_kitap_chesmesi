import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/comment_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/comment_repository.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/comment/comment_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/comment/comment_state.dart';

class _FakeCommentRepository implements CommentRepository {
  int listCalls = 0;

  @override
  Future<CommentModel> createComment(CommentCreateModel comment) async =>
      CommentModel(
        id: 1,
        comment: comment.comment,
        rating: '${comment.rating}',
        createdAt: '',
        user: CommentUser(id: 1, name: 'A', surname: 'B', phoneNumber: ''),
      );

  @override
  Future<List<CommentModel>> getCommentsByBookId(int bookId) async {
    listCalls++;
    return [];
  }
}

void main() {
  test(
      'createComment CommentCreated ile biter; listeyi yenilemek çağıranın işidir',
      () async {
    final repo = _FakeCommentRepository();
    final cubit = CommentCubit(commentRepository: repo);
    final states = <CommentState>[];
    final sub = cubit.stream.listen(states.add);

    await cubit.createComment(comment: 'Güzel', rating: 5, bookId: 7);
    await Future<void>.delayed(Duration.zero);

    // Yorum sayfası CommentCreated'ı görünce kapanır ve kendi cubit'ini
    // kapatır; ardından gelen bir emit "emit after close" hatası verirdi.
    expect(states.last, isA<CommentCreated>());
    expect(repo.listCalls, 0);

    await sub.cancel();
    await cubit.close();
  });
}
