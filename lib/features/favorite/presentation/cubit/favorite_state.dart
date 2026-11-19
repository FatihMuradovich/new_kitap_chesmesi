import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<BookModel> favorites;
  final int? updatingBookId; // İşlem yapılmakta olan kitabın ID'si

  const FavoriteLoaded({
    required this.favorites,
    this.updatingBookId,
  });

  @override
  List<Object> get props => [favorites, updatingBookId ?? 0];

  FavoriteLoaded copyWith({
    List<BookModel>? favorites,
    int? updatingBookId,
    bool clearUpdatingBookId = false,
  }) {
    return FavoriteLoaded(
      favorites: favorites ?? this.favorites,
      updatingBookId: clearUpdatingBookId ? null : (updatingBookId ?? this.updatingBookId),
    );
  }
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoriteActionLoading extends FavoriteState {}

class FavoriteAdded extends FavoriteState {
  final int bookId;

  const FavoriteAdded(this.bookId);

  @override
  List<Object> get props => [bookId];
}

class FavoriteRemoved extends FavoriteState {
  final int bookId;

  const FavoriteRemoved(this.bookId);

  @override
  List<Object> get props => [bookId];
}

class FavoriteActionError extends FavoriteState {
  final String message;

  const FavoriteActionError(this.message);

  @override
  List<Object> get props => [message];
}
