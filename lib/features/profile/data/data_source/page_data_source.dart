import 'dart:developer';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/model/page_model.dart';

class PageDataSource {
  final DioClient dioClient;

  PageDataSource({required this.dioClient});

  Future<PageModel> getPageContent() async {
    try {
      log('PageDataSource: Fetching page content');
      
      final response = await dioClient.dio.get('/page');
      
      log('PageDataSource - Full response: ${response.data}');
      log('PageDataSource - Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final pageData = responseData['data'];
          log('PageDataSource - Page data: $pageData');
          
          return PageModel.fromMap(pageData);
        } else {
          throw Exception('Invalid response format: $responseData');
        }
      } else {
        throw Exception('Failed to fetch page content: ${response.statusCode}');
      }
    } catch (e) {
      log('PageDataSource - Error: $e');
      rethrow;
    }
  }
}
