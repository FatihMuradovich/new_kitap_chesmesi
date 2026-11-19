import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/comment_model.dart';

abstract class CommentDataSource {
  Future<CommentModel> createComment(CommentCreateModel comment);
  Future<List<CommentModel>> getCommentsByBookId(int bookId);
}

class CommentDataSourceImpl implements CommentDataSource {
  final DioClient dioSetting;

  CommentDataSourceImpl({required this.dioSetting});

  // Helper method to create dummy comment model when parsing fails
  CommentModel _createDummyComment(
    CommentCreateModel comment,
    Map<String, dynamic>? data,
  ) {
    return CommentModel(
      id: data?['id'] ?? 0,
      comment: data?['comment'] ?? comment.comment,
      rating: (data?['rating'] ?? comment.rating).toString(),
      createdAt: data?['createdAt'] ?? DateTime.now().toIso8601String(),
      user: CommentUser(
        id: 0,
        name: 'User',
        surname: '',
        phoneNumber: '',
      ),
    );
  }

  @override
  Future<CommentModel> createComment(CommentCreateModel comment) async {
    try {
      debugPrint('Comment gönderiliyor: ${comment.toMap()}');
      final response = await dioSetting.dio.post(
        '/comment',
        data: comment.toMap(),
      );

      debugPrint('Comment response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null || response.data is! Map) {
          throw Exception('Geçersiz yanıt formatı');
        }

        final responseData = response.data as Map<String, dynamic>;
        
        // Check if API returned error
        if (responseData.containsKey('success') && 
            responseData['success'] == false) {
          throw Exception(
            'Comment oluşturulamadı: ${responseData['message'] ?? 'Bilinmeyen hata'}'
          );
        }

        // Try to parse the response
        try {
          final data = responseData['data'] ?? responseData;
          return CommentModel.fromMap(data);
        } catch (e) {
          debugPrint('Parse hatası: $e');
          // Return dummy model, actual data will be fetched when refreshing comments
          return _createDummyComment(comment, responseData['data']);
        }
      }
      
      throw Exception('Comment oluşturulamadı. Status kodu: ${response.statusCode}');
    } on DioException catch (e) {
      debugPrint('DioException: ${e.response?.statusCode} - ${e.response?.data}');
      
      // Sometimes Dio treats 201 as error, check if response is actually success
      if (e.response != null && 
          (e.response!.statusCode == 200 || e.response!.statusCode == 201)) {
        try {
          final data = e.response!.data;
          if (data is Map) {
            return CommentModel.fromMap(data['data'] ?? data);
          }
        } catch (parseError) {
          debugPrint('Parse hatası (DioException): $parseError');
          return _createDummyComment(
            comment,
            e.response!.data is Map ? e.response!.data['data'] : null,
          );
        }
      }
      
      throw Exception('Ağ hatası: ${e.message}');
    } catch (e) {
      debugPrint('Beklenmeyen hata: $e');
      throw Exception('Beklenmeyen hata: $e');
    }
  }

  @override
  Future<List<CommentModel>> getCommentsByBookId(int bookId) async {
    try {
      final response = await dioSetting.dio.get('/comment/$bookId');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> commentsJson = response.data['data'];
        return commentsJson
            .map((json) => CommentModel.fromMap(json))
            .toList();
      } else {
        throw Exception('Comment API hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Comment API hatası: $e');
    }
  }
}
