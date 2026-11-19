import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_sort_option.dart';

class BooksFilterCriteria extends Equatable {
  final BookSortOption? sortOption;
  final double? minPrice;
  final double? maxPrice;
  final List<int> languageIds;
  final List<int> authorIds;
  final List<int> publisherIds;

  // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
  // /// "Getirdip bolýar" — açıkken liste getirtilebilir kitaplara daralır.
  // final bool specialOrderable;

  const BooksFilterCriteria({
    this.sortOption,
    this.minPrice,
    this.maxPrice,
    this.languageIds = const [],
    this.authorIds = const [],
    this.publisherIds = const [],
    // this.specialOrderable = false,
  });

  bool get isEmpty =>
      sortOption == null &&
      minPrice == null &&
      maxPrice == null &&
      languageIds.isEmpty &&
      authorIds.isEmpty &&
      publisherIds.isEmpty;

  bool get hasPriceFilter => minPrice != null || maxPrice != null;

  bool get hasLanguageFilter => languageIds.isNotEmpty;

  bool get hasAuthorFilter => authorIds.isNotEmpty;

  bool get hasPublisherFilter => publisherIds.isNotEmpty;

  BooksFilterCriteria copyWith({
    BookSortOption? sortOption,
    double? minPrice,
    double? maxPrice,
    List<int>? languageIds,
    List<int>? authorIds,
    List<int>? publisherIds,
    bool clearSortOption = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearLanguageIds = false,
    bool clearAuthorIds = false,
    bool clearPublisherIds = false,
  }) {
    return BooksFilterCriteria(
      sortOption: clearSortOption ? null : (sortOption ?? this.sortOption),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      languageIds:
          clearLanguageIds ? const [] : (languageIds ?? this.languageIds),
      authorIds: clearAuthorIds ? const [] : (authorIds ?? this.authorIds),
      publisherIds: clearPublisherIds
          ? const []
          : (publisherIds ?? this.publisherIds),
    );
  }

  @override
  List<Object?> get props => [
        sortOption,
        minPrice,
        maxPrice,
        languageIds,
        authorIds,
        publisherIds,
      ];
}
