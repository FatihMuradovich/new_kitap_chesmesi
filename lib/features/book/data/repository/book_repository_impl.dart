// import 'package:new_kitap_chesmesi/features/book/data/data_source/book_data_source.dart';
// import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
// import 'package:new_kitap_chesmesi/features/book/domain/repository/book_repository.dart';

// class BookRepositoryImpl implements BookRepository {
//   final BookDataSource dataSource;

//   BookRepositoryImpl({required this.dataSource});

//   @override
//   Future<List<BookModel>> getAllBooks() async {
//     return await dataSource.getAllBooks();
//   }

//    @override
//   Future<List<BookModel>> fetchBookByAuthorId(
//    int authorId) async {
//     try {
//       return await dataSource.fetchBookByAuthorId(
//            authorId);
//     } catch (e) {
//       throw Exception('Repository error: $e');
//     }
//   }

//   @override
//   Future<List<BookModel>> fetchBooksByLang(int languageId) async {
//     return await dataSource.getBooksByLang(languageId);
//   }

//    @override
//   Future<BookModel> getBookById(int id, ) async {
//     print('loading');
//     try {
//       final book = await dataSource.getBookById(id);
//       print('Booook - $book');
//       return book;
//     } catch (e) {
//       print('Error - $e');
//       throw Exception('Repository error: $e');
//     }
//   }

//    @override
//   Future<List<BookModel>> fetchBookByCategory(
//        int subcategoryId) async {
//     try {
//       return await dataSource.getBooksBySubcategory(
//           subcategoryId);
//     } catch (e) {
//       throw Exception('Repository error: $e');
//     }
//   }

//    @override
//   Future<List<BookModel>> getDiscountedBooks() {
//     return dataSource.fetchDiscountedBooks();
//   }


//   @override
//   Future<List<BookModel>> getRecentBooks() {
//     return dataSource.fetchRecentBooks();
//   }
// }