// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:new_kitap_chesmesi/features/book/domain/model/book_category_type.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_list_context.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_sort_option.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/books_filter_criteria.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_by_language_id_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/books_by_category_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/discounted_book_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/latest_book_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/all_books_repository.dart';
import 'package:new_kitap_chesmesi/features/home/domain/repository/home_repository.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BookState> {
  final BooksByCategoryRepository categoryRepository;
  final LatestBookRepository latestRepository;
  final DiscountedBookRepository discountedRepository;
  final BookByLanguageIdRepository languageRepository;
  final HomeRepository homeRepository;
  final AllBooksRepository allBooksRepository;

  BooksCubit({
    required this.categoryRepository,
    required this.latestRepository,
    required this.discountedRepository,
    required this.languageRepository,
    required this.homeRepository,
    required this.allBooksRepository,
  }) : super(BooksInitial());

  Future<void> fetchBookByCategory(int subcategoryId) async {
    emit(BooksLoading());
    try {
      final context = BookListContext(
        categoryType: BookCategoryType.subcategory,
        subcategoryId: subcategoryId,
      );
      final books = await _fetchBooksForContext(context);
      emit(BooksLoaded(
        books: books,
        hasMore: false,
        listContext: context,
      ));
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  Future<void> fetchLatestBooks() async {
    emit(BooksLoading());
    try {
      final books = await latestRepository.getRecentBooks();
      final availableBooks = books
          .where((book) => book.status.toLowerCase() == 'available')
          .toList();
      emit(BooksLoaded(
        books: availableBooks,
        listContext: const BookListContext(
          categoryType: BookCategoryType.newBooks,
        ),
      ));
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  static const int _discountedPageSize = 10;

  Future<void> fetchDiscountedBooks() async {
    emit(BooksLoading());
    try {
      final books = await discountedRepository.getDiscountedBooks(
        page: 1,
        limit: _discountedPageSize,
      );
      final availableBooks = books.where((book) {
        final isAvailable = book.status.toLowerCase() == 'available';
        final hasDiscount = book.discount != null && book.discount!.isNotEmpty;
        final hasDiscountType =
            book.discountType != null && book.discountType!.isNotEmpty;
        final hasValidDiscountValue = book.discountValue > 0;
        return isAvailable &&
            hasDiscount &&
            hasDiscountType &&
            hasValidDiscountValue;
      }).toList();
      emit(BooksLoaded(
        books: availableBooks,
        hasMore: books.length >= _discountedPageSize,
        currentPage: 1,
        listContext: const BookListContext(
          categoryType: BookCategoryType.discounted,
        ),
      ));
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  Future<void> loadMoreDiscountedBooks() async {
    final currentState = state;
    if (currentState is! BooksLoaded) return;
    if (!currentState.hasMore) return;

    emit(BooksLoadingMore(currentBooks: currentState.books));

    try {
      final nextPage = currentState.currentPage + 1;
      final newBooks = await discountedRepository.getDiscountedBooks(
        page: nextPage,
        limit: _discountedPageSize,
      );
      final availableBooks = newBooks.where((book) {
        final isAvailable = book.status.toLowerCase() == 'available';
        final hasDiscount = book.discount != null && book.discount!.isNotEmpty;
        final hasDiscountType =
            book.discountType != null && book.discountType!.isNotEmpty;
        final hasValidDiscountValue = book.discountValue > 0;
        return isAvailable &&
            hasDiscount &&
            hasDiscountType &&
            hasValidDiscountValue;
      }).toList();

      final allBooks = [...currentState.books, ...availableBooks];
      emit(BooksLoaded(
        books: allBooks,
        hasMore: newBooks.length >= _discountedPageSize,
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(currentState);
    }
  }

  Future<void> fetchBooksByLanguage(int languageId) async {
    emit(BooksLoading());
    try {
      final books = await homeRepository.fetchBooksByLang(languageId);
      final availableBooks = books
          .where((book) => book.status.toLowerCase() == 'available')
          .toList();
      emit(BooksLoaded(
        books: availableBooks,
        listContext: const BookListContext(
          categoryType: BookCategoryType.turkmen,
        ),
      ));
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  Future<void> fetchBooksByCategory(int categoryId) async {
    emit(BooksLoading());
    try {
      final books = await homeRepository.getBookByCategoryId(categoryId);
      final availableBooks = books
          .where((book) => book.status.toLowerCase() == 'available')
          .toList();
      final categoryType = categoryId == 6
          ? BookCategoryType.childrenBooks
          : BookCategoryType.literature;
      emit(BooksLoaded(
        books: availableBooks,
        listContext: BookListContext(categoryType: categoryType),
      ));
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  static const int _allBooksPageSize = 10;

  // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
  // static const int _specialOrderablePageSize = 20;
  static const int _maxInitialPages = 50;
  static const int _sortedFetchLimit = 50;
  static const int _maxSortedScanPages = 20;

  List<BookModel> _availableOnly(List<BookModel> books) {
    return books
        .where((book) => book.status.toLowerCase() == 'available')
        .toList();
  }

  // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
  // /// Bir kapsamdan gelen listeye uygulanan son eleme. "Getirdip bolýar"
  // /// filtresi açıkken kapsam aynı kalır, yalnızca getirtilebilir kitaplar kalır.
  // List<BookModel> _scopeFilter(
  //   List<BookModel> books, {
  //   required bool specialOrderableOnly,
  // }) {
  //   if (!specialOrderableOnly) return _availableOnly(books);
  //   return books.where((book) => book.isSpecialOrderable).toList();
  // }

  Future<({List<BookModel> books, int lastPage, bool hasMore})>
      _fetchAvailableSortedBatch({
    required BookSortOption sortOption,
    required int startPage,
    double? minPrice,
    double? maxPrice,
    List<int> languageIds = const [],
    List<int> authorIds = const [],
    List<int> publisherIds = const [],
    int minCount = _allBooksPageSize,
  }) async {
    final collected = <BookModel>[];
    int page = startPage;
    bool apiHasMore = true;

    while (apiHasMore &&
        collected.length < minCount &&
        page < startPage + _maxSortedScanPages) {
      final books = await allBooksRepository.getAllBooks(
        page: page,
        limit: _sortedFetchLimit,
        priceOrder: sortOption.priceOrder,
        mostPurchased: sortOption.isMostPurchased,
        minPrice: minPrice,
        maxPrice: maxPrice,
        languageIds: languageIds,
        authorIds: authorIds,
        publisherIds: publisherIds,
      );

      if (books.isEmpty) {
        return (books: collected, lastPage: page, hasMore: false);
      }

      collected.addAll(_availableOnly(books));
      apiHasMore = books.length >= _sortedFetchLimit;

      if (collected.length >= minCount || !apiHasMore) {
        return (books: collected, lastPage: page, hasMore: apiHasMore);
      }

      page++;
    }

    return (books: collected, lastPage: page, hasMore: apiHasMore);
  }

  BookSortOption? get activeSort {
    final currentState = state;
    if (currentState is BooksLoaded) {
      return currentState.sortOption;
    }
    return null;
  }

  BooksFilterCriteria get activeFilters {
    final currentState = state;
    if (currentState is BooksLoaded) {
      return BooksFilterCriteria(
        sortOption: currentState.sortOption,
        minPrice: currentState.minPrice,
        maxPrice: currentState.maxPrice,
        languageIds: currentState.languageIds,
        authorIds: currentState.authorIds,
        publisherIds: currentState.publisherIds,
      );
    }
    return const BooksFilterCriteria();
  }

  Future<void> fetchAllBooks() async {
    await _fetchAllBooksInternal();
  }

  Future<void> applyFilters(
    BooksFilterCriteria criteria,
    BookListContext requestedContext,
  ) async {
    final listContext = requestedContext;

    if (listContext.isAllBooks) {
      await _fetchAllBooksInternal(
        sortOption: criteria.sortOption,
        minPrice: criteria.minPrice,
        maxPrice: criteria.maxPrice,
        languageIds: criteria.languageIds,
        authorIds: criteria.authorIds,
        publisherIds: criteria.publisherIds,
      );
      return;
    }

    emit(BooksLoading());
    try {
      var books = await _fetchBooksForContext(listContext);
      books = _filterByPrice(
        books,
        minPrice: criteria.minPrice,
        maxPrice: criteria.maxPrice,
      );

      final sortOption = criteria.sortOption;
      final hasIdFilters = criteria.languageIds.isNotEmpty ||
          criteria.authorIds.isNotEmpty ||
          criteria.publisherIds.isNotEmpty;

      if (sortOption != null && sortOption.isMostPurchased) {
        // "Iň köp satylan" sıralaması zaten sunucu taraflı tarama + id
        // kesişimi yapıyor; dil/yazar/neşiriýat filtrelerini de orada uyguluyor.
        books = await _fetchMostPurchasedFromList(
          books,
          languageIds: criteria.languageIds,
          authorIds: criteria.authorIds,
          publisherIds: criteria.publisherIds,
        );
      } else {
        // Liste endpoint'i (`/book`) `languageId`/`publisher` alanlarını
        // döndürmüyor; bu yüzden dil/yazar/neşiriýat filtreleri sunucu
        // tarafında çözülüp scoped kitaplarla id üzerinden kesiştiriliyor.
        if (hasIdFilters) {
          books = await _applyServerSideIdFilter(
            books,
            languageIds: criteria.languageIds,
            authorIds: criteria.authorIds,
            publisherIds: criteria.publisherIds,
          );
        }
        if (sortOption != null) {
          books = _sortBooksLocally(books, sortOption);
        }
      }

      emit(BooksLoaded(
        books: books,
        hasMore: false,
        listContext: listContext,
        sortOption: criteria.sortOption,
        minPrice: criteria.minPrice,
        maxPrice: criteria.maxPrice,
        languageIds: criteria.languageIds,
        authorIds: criteria.authorIds,
        publisherIds: criteria.publisherIds,
      ));
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  List<BookModel> _filterByPrice(
    List<BookModel> books, {
    double? minPrice,
    double? maxPrice,
  }) {
    if (minPrice == null && maxPrice == null) return books;

    return books.where((book) {
      // Fiyatı olmayan (`Finished`) kitap bir fiyat aralığıyla kıyaslanamaz —
      // `priceValue`'nun 0 dönmesine güvenip `maxPrice` filtresinde tutmak
      // yanıltıcı olurdu. Fiyat filtresi aktifken bunları eliyoruz.
      if (!book.hasPrice) return false;

      final price = book.discountedPrice;
      if (minPrice != null && price < minPrice) return false;
      if (maxPrice != null && price > maxPrice) return false;
      return true;
    }).toList();
  }

  /// `/book` liste cevabı `languageId`/`publisher` (ve bazı durumlarda
  /// `author`) alanlarını içermediği için bu filtreler client-side
  /// uygulanamıyor. Bunun yerine seçili filtrelere uyan kitap id'lerini
  /// sunucudan çekip, scoped (context) kitaplarla kesiştiriyoruz. Sunucu
  /// `languageIds`/`authorIds`/`publisherIds` parametrelerini AND mantığıyla
  /// birleştiriyor.
  Future<List<BookModel>> _applyServerSideIdFilter(
    List<BookModel> scopedBooks, {
    List<int> languageIds = const [],
    List<int> authorIds = const [],
    List<int> publisherIds = const [],
  }) async {
    if (languageIds.isEmpty && authorIds.isEmpty && publisherIds.isEmpty) {
      return scopedBooks;
    }
    if (scopedBooks.isEmpty) return scopedBooks;

    final matchingIds = <int>{};
    int page = 1;

    while (page < _maxSortedScanPages + 1) {
      final books = await allBooksRepository.getAllBooks(
        page: page,
        limit: _sortedFetchLimit,
        languageIds: languageIds,
        authorIds: authorIds,
        publisherIds: publisherIds,
      );
      if (books.isEmpty) break;

      matchingIds.addAll(books.map((book) => book.id));

      if (books.length < _sortedFetchLimit) break;
      page++;
    }

    return scopedBooks
        .where((book) => matchingIds.contains(book.id))
        .toList();
  }

  Future<List<BookModel>> _fetchBooksForContext(BookListContext context) async {
    switch (context.categoryType) {
      case BookCategoryType.subcategory:
        final subcategoryId = context.subcategoryId;
        if (subcategoryId == null) return [];
        final books =
            await categoryRepository.fetchBookByCategory(subcategoryId);
        return books
            .where(
              (book) =>
                  book.belongsToSubcategory(subcategoryId) &&
                  book.status.toLowerCase() == 'available',
            )
            .toList();
      case BookCategoryType.newBooks:
        final books = await latestRepository.getRecentBooks();
        return _availableOnly(books);
      case BookCategoryType.discounted:
        return _fetchAllDiscountedBooks();
      case BookCategoryType.turkmen:
        final books = await homeRepository.fetchBooksByLang(4);
        return _availableOnly(books);
      case BookCategoryType.childrenBooks:
        final books = await homeRepository.getBookByCategoryId(6);
        return _availableOnly(books);
      case BookCategoryType.literature:
        final books = await homeRepository.getBookByCategoryId(1);
        return _availableOnly(books);
      case BookCategoryType.recommended:
        final books = await homeRepository.getUserRecommendedBooks();
        return _availableOnly(books);
      case BookCategoryType.allBooks:
        return _availableOnly(
          await allBooksRepository.getAllBooks(
            page: 1,
            limit: _allBooksPageSize,
          ),
        );
      // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
      // case BookCategoryType.specialOrderable:
      //   return _fetchAllSpecialOrderableBooks();
    }
  }

  // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
  // /// Getirtilebilir kitapların tamamı, sayfa sayfa.
  // /// `_fetchAllDiscountedBooks` ile aynı desen; `_availableOnly` UYGULANMAZ —
  // /// bu liste tanımı gereği `Finished` (SPECIAL-ORDER-API.md §2).
  // Future<List<BookModel>> _fetchAllSpecialOrderableBooks() async {
  // final all = <BookModel>[];
  // int page = 1;
  //
  // while (page <= _maxInitialPages) {
  // final books = await _fetchSpecialOrderablePage(page);
  // if (books.isEmpty) break;
  // all.addAll(books);
  // if (books.length < _specialOrderablePageSize) break;
  // page++;
  // }
  //
  // return all;
  // }
  //
  Future<List<BookModel>> _fetchAllDiscountedBooks() async {
    final allDiscounted = <BookModel>[];
    int page = 1;

    while (true) {
      final books = await discountedRepository.getDiscountedBooks(
        page: page,
        limit: _discountedPageSize,
      );
      if (books.isEmpty) break;

      allDiscounted.addAll(books.where((book) {
        final isAvailable = book.status.toLowerCase() == 'available';
        final hasDiscount = book.discount != null && book.discount!.isNotEmpty;
        final hasDiscountType =
            book.discountType != null && book.discountType!.isNotEmpty;
        final hasValidDiscountValue = book.discountValue > 0;
        return isAvailable &&
            hasDiscount &&
            hasDiscountType &&
            hasValidDiscountValue;
      }));

      if (books.length < _discountedPageSize) break;
      page++;
    }

    return allDiscounted;
  }

  Future<List<BookModel>> _fetchMostPurchasedFromList(
    List<BookModel> scopedBooks, {
    List<int> languageIds = const [],
    List<int> authorIds = const [],
    List<int> publisherIds = const [],
  }) async {
    if (scopedBooks.isEmpty) return [];

    final scopedById = {for (final book in scopedBooks) book.id: book};
    final orderedIds = <int>[];
    int page = 1;

    while (page < _maxSortedScanPages + 1) {
      final books = await allBooksRepository.getAllBooks(
        page: page,
        limit: _sortedFetchLimit,
        mostPurchased: true,
        languageIds: languageIds,
        authorIds: authorIds,
        publisherIds: publisherIds,
      );
      if (books.isEmpty) break;

      for (final book in books) {
        if (scopedById.containsKey(book.id) &&
            !orderedIds.contains(book.id)) {
          orderedIds.add(book.id);
        }
      }

      if (books.length < _sortedFetchLimit) break;
      page++;
    }

    return orderedIds.map((id) => scopedById[id]!).toList();
  }

  List<BookModel> _sortBooksLocally(
    List<BookModel> books,
    BookSortOption sortOption,
  ) {
    final sorted = List<BookModel>.from(books);
    switch (sortOption) {
      case BookSortOption.priceAsc:
        sorted.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
      case BookSortOption.priceDesc:
        sorted.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
      case BookSortOption.mostPurchased:
        sorted.sort(
          (a, b) => (b.createdAt ?? DateTime(0))
              .compareTo(a.createdAt ?? DateTime(0)),
        );
    }
    return sorted;
  }

  Future<void> _fetchAllBooksInternal({
    BookSortOption? sortOption,
    double? minPrice,
    double? maxPrice,
    List<int> languageIds = const [],
    List<int> authorIds = const [],
    List<int> publisherIds = const [],
  }) async {
    emit(BooksLoading());
    try {
      if (sortOption != null) {
        final result = await _fetchAvailableSortedBatch(
          sortOption: sortOption,
          startPage: 1,
          minPrice: minPrice,
          maxPrice: maxPrice,
          languageIds: languageIds,
          authorIds: authorIds,
          publisherIds: publisherIds,
        );
        emit(BooksLoaded(
          books: result.books,
          hasMore: result.hasMore,
          currentPage: result.lastPage,
          sortOption: sortOption,
          minPrice: minPrice,
          maxPrice: maxPrice,
          languageIds: languageIds,
          authorIds: authorIds,
          publisherIds: publisherIds,
          listContext: const BookListContext(
            categoryType: BookCategoryType.allBooks,
          ),
        ));
        return;
      }

      final allAvailable = <BookModel>[];
      int page = 1;
      bool hasMore = true;

      while (hasMore && page <= _maxInitialPages) {
        final books = await allBooksRepository.getAllBooks(
          page: page,
          limit: _allBooksPageSize,
          minPrice: minPrice,
          maxPrice: maxPrice,
          languageIds: languageIds,
          authorIds: authorIds,
          publisherIds: publisherIds,
        );
        allAvailable.addAll(_availableOnly(books));

        final pageFull = books.length >= _allBooksPageSize;
        hasMore = pageFull;

        if (allAvailable.length >= _allBooksPageSize || !pageFull) {
          emit(BooksLoaded(
            books: allAvailable,
            hasMore: pageFull,
            currentPage: page,
            minPrice: minPrice,
            maxPrice: maxPrice,
            languageIds: languageIds,
            authorIds: authorIds,
            publisherIds: publisherIds,
            listContext: const BookListContext(
              categoryType: BookCategoryType.allBooks,
            ),
          ));
          return;
        }
        page++;
      }

      emit(BooksLoaded(
        books: allAvailable,
        hasMore: false,
        currentPage: page - 1,
        minPrice: minPrice,
        maxPrice: maxPrice,
        languageIds: languageIds,
        authorIds: authorIds,
        publisherIds: publisherIds,
        listContext: const BookListContext(
          categoryType: BookCategoryType.allBooks,
        ),
      ));
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  Future<void> loadMoreAllBooks() async {
    final currentState = state;
    if (currentState is! BooksLoaded) return;
    if (!currentState.hasMore) return;
    if (currentState.listContext?.isAllBooks != true) return;

    emit(BooksLoadingMore(currentBooks: currentState.books));

    try {
      final sortOption = currentState.sortOption;
      final nextPage = currentState.currentPage + 1;

      if (sortOption != null) {
        final result = await _fetchAvailableSortedBatch(
          sortOption: sortOption,
          startPage: nextPage,
          minPrice: currentState.minPrice,
          maxPrice: currentState.maxPrice,
          languageIds: currentState.languageIds,
          authorIds: currentState.authorIds,
          publisherIds: currentState.publisherIds,
        );
        final allBooks = [...currentState.books, ...result.books];
        emit(BooksLoaded(
          books: allBooks,
          hasMore: result.hasMore,
          currentPage: result.lastPage,
          sortOption: sortOption,
          minPrice: currentState.minPrice,
          maxPrice: currentState.maxPrice,
          languageIds: currentState.languageIds,
          authorIds: currentState.authorIds,
          publisherIds: currentState.publisherIds,
          listContext: currentState.listContext,
        ));
        return;
      }

      final newBooks = await allBooksRepository.getAllBooks(
        page: nextPage,
        limit: _allBooksPageSize,
        minPrice: currentState.minPrice,
        maxPrice: currentState.maxPrice,
        languageIds: currentState.languageIds,
        authorIds: currentState.authorIds,
        publisherIds: currentState.publisherIds,
      );
      final availableBooks = _availableOnly(newBooks);

      final allBooks = [...currentState.books, ...availableBooks];
      emit(BooksLoaded(
        books: allBooks,
        hasMore: newBooks.length >= _allBooksPageSize,
        currentPage: nextPage,
        minPrice: currentState.minPrice,
        maxPrice: currentState.maxPrice,
        languageIds: currentState.languageIds,
        authorIds: currentState.authorIds,
        publisherIds: currentState.publisherIds,
        listContext: currentState.listContext,
      ));
    } catch (e) {
      emit(currentState);
    }
  }

  Future<void> fetchUserRecommendedBooks() async {
    emit(BooksLoading());
    try {
      final books = await homeRepository.getUserRecommendedBooks();
      final availableBooks = books
          .where((book) => book.status.toLowerCase() == 'available')
          .toList();
      emit(BooksLoaded(
        books: availableBooks,
        listContext: const BookListContext(
          categoryType: BookCategoryType.recommended,
        ),
      ));
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
  // /// "Getirtebiliriz" listesi — SPECIAL-ORDER-API.md §2.
  // /// Sunucu filtreliyor; burada `available` elemesi YAPILMAZ.
  // Future<void> fetchSpecialOrderableBooks() async {
  // emit(BooksLoading());
  // try {
  // final books = await _fetchSpecialOrderablePage(1);
  // emit(BooksLoaded(
  // books: books,
  // // Dolu sayfa geldiyse devamı olabilir.
  // hasMore: books.length >= _specialOrderablePageSize,
  // currentPage: 1,
  // listContext: const BookListContext(
  // categoryType: BookCategoryType.specialOrderable,
  // ),
  // ));
  // } catch (e) {
  // emit(BookError(message: e.toString()));
  // }
  // }
  //
  // /// Sonsuz kaydırma — `loadMoreAllBooks` ile aynı sözleşme: hata durumunda
  // /// önceki state'e dönülür, boş sayfa geldiğinde döngü durur.
  // Future<void> loadMoreSpecialOrderableBooks() async {
  // final currentState = state;
  // if (currentState is! BooksLoaded) return;
  // if (!currentState.hasMore) return;
  // if (currentState.listContext?.categoryType !=
  // BookCategoryType.specialOrderable) {
  // return;
  // }
  //
  // emit(BooksLoadingMore(currentBooks: currentState.books));
  //
  // final nextPage = currentState.currentPage + 1;
  // try {
  // final newBooks = await _fetchSpecialOrderablePage(nextPage);
  // emit(BooksLoaded(
  // books: [...currentState.books, ...newBooks],
  // hasMore: newBooks.length >= _specialOrderablePageSize,
  // currentPage: nextPage,
  // listContext: currentState.listContext,
  // ));
  // } catch (_) {
  // emit(currentState);
  // }
  // }
  //
  // Future<List<BookModel>> _fetchSpecialOrderablePage(int page) {
  // return allBooksRepository.getAllBooks(
  // page: page,
  // limit: _specialOrderablePageSize,
  // status: 'Finished',
  // specialOrderable: true,
  // );
  // }
}
