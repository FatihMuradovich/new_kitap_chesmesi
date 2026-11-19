import 'package:dio/dio.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/model/contact_model.dart';

class ContactDataSource {
  final DioClient dioSettings;
  ContactDataSource({required this.dioSettings});
  
  Future<ContactModel> sendMessage(String message) async {
    try {
      final token = await dioSettings.getToken();
      final response = await dioSettings.dio.post('/contact',
          data: {
            'message': message,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ContactModel.fromMap(response.data['data']);
      } else {
        throw Exception('Failed to send contact message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send contact message: $e');
    }
  }
}
