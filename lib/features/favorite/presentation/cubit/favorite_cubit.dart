import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/favorite/domain/repository/favorite_repository.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository favoriteRepository;
  List<BookModel> _favoriteBooks = [];

  FavoriteCubit({required this.favoriteRepository})
      : super(FavoriteInitial());

  Future<void> getFavoriteBooks() async {
    emit(FavoriteLoading());
    try {
      final favoriteBooks = await favoriteRepository.getFavoriteBooks();
      // Filter only available books
      final availableFavorites = favoriteBooks.where((book) => book.status.toLowerCase() == 'available').toList();
      _favoriteBooks = availableFavorites;
      emit(FavoriteLoaded(favorites: availableFavorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  bool isBookFavorite(int bookId) {
    return _favoriteBooks.any((book) => book.id == bookId);
  }

  /// Oturum kapanınca çağrılır. Kitap kartlarındaki kalpler `isBookFavorite`
  /// ile [_favoriteBooks]'tan okunduğu için state ile birlikte liste de silinir.
  void reset() {
    _favoriteBooks = [];
    emit(FavoriteInitial());
  }

  Future<void> addFavorite(int bookId) async {
    final currentState = state;
    if (currentState is! FavoriteLoaded) {
      // Eğer liste yüklü değilse, normal flow ile devam et
      try {
        final success = await favoriteRepository.addFavorite(bookId);
        if (success) {
          emit(FavoriteAdded(bookId));
          await getFavoriteBooks();
        } else {
          emit(FavoriteActionError('Failed to add favorite'));
        }
      } catch (e) {
        emit(FavoriteActionError(e.toString()));
      }
      return;
    }

    try {
      // Optimistic update - loading durumunu göster
      emit(currentState.copyWith(updatingBookId: bookId));

      // API çağrısı
      final success = await favoriteRepository.addFavorite(bookId);
      
      if (success) {
        // Favorileri yeniden yükle ama loading gösterme
        final favoriteBooks = await favoriteRepository.getFavoriteBooks();
        // Filter only available books
        final availableFavorites = favoriteBooks.where((book) => book.status.toLowerCase() == 'available').toList();
        _favoriteBooks = availableFavorites;
        emit(FavoriteLoaded(favorites: availableFavorites));
      } else {
        // Hata durumunda eski state'e dön
        emit(currentState);
        emit(FavoriteActionError('Failed to add favorite'));
      }
    } catch (e) {
      // Hata durumunda eski state'e dön
      emit(currentState);
      emit(FavoriteActionError(e.toString()));
    }
  }

  Future<void> removeFavorite(int bookId) async {
    final currentState = state;
    if (currentState is! FavoriteLoaded) {
      // Eğer liste yüklü değilse, normal flow ile devam et
      try {
        final success = await favoriteRepository.removeFavorite(bookId);
        if (success) {
          emit(FavoriteRemoved(bookId));
          await getFavoriteBooks();
        } else {
          emit(FavoriteActionError('Failed to remove favorite'));
        }
      } catch (e) {
        emit(FavoriteActionError(e.toString()));
      }
      return;
    }

    try {
      // Optimistic update - kitabı listeden hemen kaldır
      final updatedFavorites = currentState.favorites
          .where((book) => book.id != bookId)
          .toList();
      
      // UI'ı hemen güncelle ve loading durumunu göster
      emit(currentState.copyWith(
        favorites: updatedFavorites,
        updatingBookId: bookId,
      ));

      // Arka planda API çağrısı
      final success = await favoriteRepository.removeFavorite(bookId);
      
      if (success) {
        // Başarılı olursa loading'i temizle
        _favoriteBooks = updatedFavorites;
        emit(FavoriteLoaded(favorites: updatedFavorites));
      } else {
        // Hata durumunda eski state'e geri dön
        emit(currentState);
        emit(FavoriteActionError('Failed to remove favorite'));
      }
    } catch (e) {
      // Hata durumunda eski state'e geri dön
      emit(currentState);
      emit(FavoriteActionError(e.toString()));
    }
  }

  Future<void> toggleFavorite(int bookId) async {
    final isFavorite = isBookFavorite(bookId);
    if (isFavorite) {
      await removeFavorite(bookId);
    } else {
      await addFavorite(bookId);
    }
  }
}
