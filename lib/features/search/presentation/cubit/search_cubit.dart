import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/search/domain/repository/search_repository.dart';
import 'package:new_kitap_chesmesi/features/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;

  SearchCubit({required this.searchRepository}) : super(SearchInitial());

  static const int _pageSize = 20;

  String _currentQuery = '';
  int _currentPage = 1;
  bool _isLoadingMore = false;

  /// Aramada yalnızca stoktaki kitaplar gösterilir.
  ///
  /// ÖZEL SİPARİŞ — geçici olarak kapatıldı. Açılınca koşula
  /// `|| book.isSpecialOrderable` eklenmeli.
  List<BookModel> _visibleBooks(List<BookModel> books) => books
      .where((book) => book.status.toLowerCase() == 'available')
      .toList();

  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    _currentQuery = query;
    _currentPage = 1;
    emit(SearchLoading());

    try {
      // Backend'den ilk sayfayı getir
      final books = await searchRepository.searchBooks(
        query,
        page: _currentPage,
        limit: _pageSize,
      );

      final availableBooks = _visibleBooks(books);

      emit(SearchLoaded(
        availableBooks,
        // hasMore kontrolü available filtresinden önceki ham sayı üzerinden
        hasMore: books.length >= _pageSize,
        query: query,
      ));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> loadMoreBooks() async {
    final currentState = state;
    if (currentState is! SearchLoaded) return;
    if (!currentState.hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    emit(SearchLoadingMore(currentState.books));

    try {
      final nextPage = _currentPage + 1;
      final newBooks = await searchRepository.searchBooks(
        _currentQuery,
        page: nextPage,
        limit: _pageSize,
      );

      final availableBooks = _visibleBooks(newBooks);

      _currentPage = nextPage;

      emit(SearchLoaded(
        [...currentState.books, ...availableBooks],
        hasMore: newBooks.length >= _pageSize,
        query: _currentQuery,
      ));
    } catch (_) {
      // Hata durumunda mevcut listeyi koru
      emit(SearchLoaded(
        currentState.books,
        hasMore: currentState.hasMore,
        query: _currentQuery,
      ));
    } finally {
      _isLoadingMore = false;
    }
  }

  void clearSearch() {
    _currentQuery = '';
    _currentPage = 1;
    _isLoadingMore = false;
    emit(SearchInitial());
  }
}
