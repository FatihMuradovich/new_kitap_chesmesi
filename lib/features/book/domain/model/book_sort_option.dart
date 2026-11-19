enum BookSortOption {
  priceAsc,
  priceDesc,
  mostPurchased;

  String? get priceOrder {
    switch (this) {
      case BookSortOption.priceAsc:
        return 'asc';
      case BookSortOption.priceDesc:
        return 'desc';
      case BookSortOption.mostPurchased:
        return null;
    }
  }

  bool get isMostPurchased => this == BookSortOption.mostPurchased;
}
