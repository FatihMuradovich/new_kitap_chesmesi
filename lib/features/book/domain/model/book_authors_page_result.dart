import 'package:new_kitap_chesmesi/features/book/domain/model/book_author_model.dart';

class BookAuthorsPageResult {
  final List<BookAuthorModel> authors;
  final bool hasMore;

  const BookAuthorsPageResult({
    required this.authors,
    required this.hasMore,
  });
}

class BooksAuthorFilterResult {
  final List<int> authorIds;
  final Map<int, String> authorNames;

  const BooksAuthorFilterResult({
    required this.authorIds,
    required this.authorNames,
  });
}
