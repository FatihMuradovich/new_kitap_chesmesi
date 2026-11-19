part of 'books_cubit.dart';


abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object> get props => [];
}

class BooksInitial extends BookState {}

class BooksLoading extends BookState {}

class BooksLoaded extends BookState {
  final List<BookModel> books;
  final bool hasMore;
  final int currentPage;
  final BookSortOption? sortOption;
  final BookListContext? listContext;
  final double? minPrice;
  final double? maxPrice;
  final List<int> languageIds;
  final List<int> authorIds;
  final List<int> publisherIds;

  const BooksLoaded({
    required this.books,
    this.hasMore = true,
    this.currentPage = 1,
    this.sortOption,
    this.listContext,
    this.minPrice,
    this.maxPrice,
    this.languageIds = const [],
    this.authorIds = const [],
    this.publisherIds = const [],
  });

  BooksLoaded copyWith({
    List<BookModel>? books,
    bool? hasMore,
    int? currentPage,
    BookSortOption? sortOption,
    BookListContext? listContext,
    double? minPrice,
    double? maxPrice,
    List<int>? languageIds,
    List<int>? authorIds,
    List<int>? publisherIds,
    bool clearSortOption = false,
    bool clearPriceFilter = false,
    bool clearLanguageFilter = false,
    bool clearAuthorFilter = false,
    bool clearPublisherFilter = false,
  }) {
    return BooksLoaded(
      books: books ?? this.books,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      sortOption: clearSortOption ? null : (sortOption ?? this.sortOption),
      listContext: listContext ?? this.listContext,
      minPrice: clearPriceFilter ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPriceFilter ? null : (maxPrice ?? this.maxPrice),
      languageIds: clearLanguageFilter
          ? const []
          : (languageIds ?? this.languageIds),
      authorIds:
          clearAuthorFilter ? const [] : (authorIds ?? this.authorIds),
      publisherIds: clearPublisherFilter
          ? const []
          : (publisherIds ?? this.publisherIds),
    );
  }

  @override
  List<Object> get props => [
        books,
        hasMore,
        currentPage,
        sortOption ?? '',
        listContext ?? '',
        minPrice ?? '',
        maxPrice ?? '',
        languageIds,
        authorIds,
        publisherIds,
      ];
}

class BooksLoadingMore extends BookState {
  final List<BookModel> currentBooks;

  const BooksLoadingMore({required this.currentBooks});

  @override
  List<Object> get props => [currentBooks];
}

class BookError extends BookState {
  final String message;

  const BookError({required this.message});

  @override
  List<Object> get props => [message];
}
