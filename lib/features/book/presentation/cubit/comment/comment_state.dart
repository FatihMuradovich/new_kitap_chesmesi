import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/comment_model.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentCreateLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<CommentModel> comments;

  const CommentLoaded({required this.comments});

  @override
  List<Object?> get props => [comments];
}

class CommentCreated extends CommentState {
  final CommentModel comment;

  const CommentCreated({required this.comment});

  @override
  List<Object?> get props => [comment];
}

class CommentError extends CommentState {
  final String message;

  const CommentError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CommentCreateError extends CommentState {
  final String message;

  const CommentCreateError({required this.message});

  @override
  List<Object?> get props => [message];
}
