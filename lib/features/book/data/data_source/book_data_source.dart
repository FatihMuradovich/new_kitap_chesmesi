// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
// import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

// class BookDataSource {
//   final DioClient dioSetting;
//   BookDataSource({
//     required this.dioSetting,
//   });

//   Future<List<BookModel>> getAllBooks() async {
//     try {
//       final response = await dioSetting.dio.get(
//         "/book",
//       );

//       if (response.statusCode == 200) {
//         final List data = response.data["data"];
//         return data.map((json) => BookModel.fromMap(json)).toList();
//       } else {
//         throw Exception("Kitapları getirme başarısız");
//       }
//     } catch (e) {
//       throw Exception("API hatası: $e");
//     }
//   }

//  Future<BookModel> getBookById(int id) async {
//     try {
     
//       final response = await dioSetting.dio.get('/book/$id');
//       if (response.statusCode == 200) {
//         return BookModel.fromMap(response.data['data']);
//       } else {
//         throw Exception('Failed to load books');
//       }
//     } catch (e) {
//       print(e);
//       throw Exception('Error fetching books: $e');
//     }
//   }

//   Future<List<BookModel>> fetchBookByAuthorId(int authorId) async {
//     try {
//       final response = await dioSetting.dio.get('/book', queryParameters: {
//         'authorId': authorId,
//       });
//       if (response.statusCode == 200) {
//         List<BookModel> books = (response.data['data'] as List)
//             .map((book) => BookModel.fromMap(book))
//             .toList();
//         return books;
//       } else {
//         throw Exception('Failed to load books');
//       }
//     } catch (e) {
//       throw Exception('Failed to load discounted books');
//     }
//   }

//   Future<List<BookModel>> getBooksByLang(int languageId) async {
//     try {
//       final response = await dioSetting.dio.get(
//         "/book",
//         queryParameters: {"languageId": languageId}, // API dil parametresi
//       );

//       if (response.statusCode == 200) {
//         final List data = response.data["data"];
//         return data.map((json) => BookModel.fromMap(json)).toList();
//       } else {
//         throw Exception("Kitapları getirme başarısız");
//       }
//     } catch (e) {
//       throw Exception("API hatası: $e");
//     }
//   }

//   Future<List<BookModel>> getBooksBySubcategory(int subcategoryId) async {
//     try {
//       final response = await dioSetting.dio.get(
//         '/book',
//         queryParameters: {'subcategoryId': subcategoryId},
//       );

//       if (response.statusCode == 200) {
//         List<BookModel> books = (response.data['data'] as List)
//             .map((book) => BookModel.fromMap(book))
//             .toList();
//         return books;
//       } else {
//         throw Exception('Failed to load books');
//       }
//     } catch (e) {
//       print(e);
//       throw Exception('Error fetching books: $e');
//     }
//   }

//   Future<List<BookModel>> fetchDiscountedBooks() async {
//     try {
//       final response = await dioSetting.dio.get('/book', queryParameters: {
//         'discount': true,
//       });
//       if (response.statusCode == 200) {
//         List<BookModel> books = (response.data['data'] as List)
//             .map((book) => BookModel.fromMap(book))
//             .toList();
//         return books;
//       } else {
//         throw Exception('Failed to load books');
//       }
//     } catch (e) {
//       throw Exception('Failed to load discounted books');
//     }
//   }

//   Future<List<BookModel>> fetchRecentBooks() async {
//     try {
//       final response =
//           await dioSetting.dio.get('/book', queryParameters: {'limit': 10});
//       if (response.statusCode == 200) {
//         List<BookModel> books = (response.data['data'] as List)
//             .map((book) => BookModel.fromMap(book))
//             .toList();
//         return books;
//       } else {
//         throw Exception('Failed to load books');
//       }
//     } catch (e) {
//       throw Exception('Error fetching books: $e');
//     }
//   }
// }
