import 'package:flutter/foundation.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/book_detail_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_detail_repository.dart';

class BookDetailRepositoryImpl implements BookDetailRepository {
  final BookDetailDataSource remoteDataSource;

  BookDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BookModel> getBookById(int id, ) async {
    debugPrint('loading');
    try {
      final book = await remoteDataSource.getBookById(id);
      debugPrint('Booook - $book');
      return book;
    } catch (e) {
      debugPrint('Error - $e');
      throw Exception('Repository error: $e');
    }
  }
}
