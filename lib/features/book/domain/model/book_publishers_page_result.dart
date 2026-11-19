import 'package:new_kitap_chesmesi/features/book/domain/model/book_publisher_model.dart';

class BookPublishersPageResult {
  final List<BookPublisherModel> publishers;
  final bool hasMore;

  const BookPublishersPageResult({
    required this.publishers,
    required this.hasMore,
  });
}

class BooksPublisherFilterResult {
  final List<int> publisherIds;
  final Map<int, String> publisherNames;

  const BooksPublisherFilterResult({
    required this.publisherIds,
    required this.publisherNames,
  });
}
