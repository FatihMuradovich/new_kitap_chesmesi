import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart'; // For JSON encoding/decoding

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<BookModel> favorites;

  const FavoriteLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object> get props => [message];
}
class FavoriteRepository {
  final FlutterSecureStorage _secureStorage;
  static const String _favoritesKey = 'user_favorites';

  FavoriteRepository({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<List<BookModel>> loadFavorites() async {
    try {
      final String? favoritesJson = await _secureStorage.read(key: _favoritesKey);
      if (favoritesJson != null && favoritesJson.isNotEmpty) {
        final List<dynamic> decodedList = json.decode(favoritesJson);
        return List<BookModel>.from(decodedList);
      }
      return [];
    } catch (e) {
      print('Error loading favorites: $e');
      return [];
    }
  }

  Future<void> saveFavorites(List<BookModel> favorites) async {
    try {
      final String favoritesJson = json.encode(favorites);
      await _secureStorage.write(key: _favoritesKey, value: favoritesJson);
    } catch (e) {
      print('Error saving favorites: $e');
      rethrow; 
    }
  }
}


class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _favoriteRepository;

  FavoriteCubit({required FavoriteRepository favoriteRepository})
      : _favoriteRepository = favoriteRepository,
        super(FavoriteInitial());

  Future<void> loadFavorites() async {
    emit(FavoriteLoading());
    try {
      final List<BookModel> favorites = await _favoriteRepository.loadFavorites();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError('Failed to load favorites: $e'));
    }
  }

  Future<void> addFavorite(BookModel item) async {
    if (state is FavoriteLoaded) {
      final currentFavorites = (state as FavoriteLoaded).favorites;
      if (!currentFavorites.contains(item)) {
        final updatedFavorites = List<BookModel>.from(currentFavorites)..add(item);
        emit(FavoriteLoaded(updatedFavorites)); // Optimistic update
        try {
          await _favoriteRepository.saveFavorites(updatedFavorites);
        } catch (e) {
          // Revert if save fails
          emit(FavoriteLoaded(currentFavorites));
          emit(FavoriteError('Failed to save favorite: $e'));
        }
      }
    }
  }

  Future<void> removeFavorite(BookModel item) async {
    if (state is FavoriteLoaded) {
      final currentFavorites = (state as FavoriteLoaded).favorites;
      if (currentFavorites.contains(item)) {
        final updatedFavorites = List<BookModel>.from(currentFavorites)..remove(item);
        emit(FavoriteLoaded(updatedFavorites)); // Optimistic update
        try {
          await _favoriteRepository.saveFavorites(updatedFavorites);
        } catch (e) {
          emit(FavoriteLoaded(currentFavorites));
          emit(FavoriteError('Failed to save favorite: $e'));
        }
      }
    }
  }

  Future<void> toggleFavorite(BookModel item) async {
    if (state is FavoriteLoaded) {
      final currentFavorites = (state as FavoriteLoaded).favorites;
      if (currentFavorites.contains(item)) {
        await removeFavorite(item);
      } else {
        await addFavorite(item);
      }
    }
  }
}