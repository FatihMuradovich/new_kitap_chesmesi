import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_category_type.dart';

class BookListContext extends Equatable {
  final BookCategoryType categoryType;
  final int? subcategoryId;

  const BookListContext({
    required this.categoryType,
    this.subcategoryId,
  });

  factory BookListContext.fromPage({
    required BookCategoryType categoryType,
    int? subcategoryId,
  }) {
    return BookListContext(
      categoryType: categoryType,
      subcategoryId: subcategoryId,
    );
  }

  bool get isAllBooks => categoryType == BookCategoryType.allBooks;

  @override
  List<Object?> get props => [categoryType, subcategoryId];
}
