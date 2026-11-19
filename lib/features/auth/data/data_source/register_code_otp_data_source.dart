import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_kitap_chesmesi/app/app.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_code_model.dart';

class RegisterCodeOtpDataSource {
  final DioClient dioSetting;

  RegisterCodeOtpDataSource({
    required this.dioSetting,
  });

  String getCurrentLanguageCode(BuildContext context) {
    final lang = App.of(context)?.locale.languageCode ?? 'tm';

    switch (lang) {
      case 'tr':
        return 'tm';
      case 'ru':
        return 'ru';
      case 'en':
        return 'en';
      default:
        return lang;
    }
  }

  Future<RegisterCodeModel> sendCode(
      String phoneNumber, String type, BuildContext context) async {
    try {
      final langCode = getCurrentLanguageCode(context);
      final response = await dioSetting.dio.post(
        '$langCode/auth/send-code',
        data: {
          'phoneNumber': phoneNumber,
          'type': type,
        },
      );
      if (response.statusCode == 201 && response.data['success'] == true) {
        // final getResponse = (response.data);
        // return getResponse;
        return RegisterCodeModel.fromMap(response.data['data']);
      }
      // Yanıt geldi ama kod gönderilmedi.
      throw DioException.badResponse(
        statusCode: response.statusCode ?? 0,
        requestOptions: response.requestOptions,
        response: response,
      );
    } catch (e) {
      // Orijinal hata korunur: cubit nedeni (internet / red) ayırt eder.
      debugPrint(e.toString());
      rethrow;
    }
  }
}
