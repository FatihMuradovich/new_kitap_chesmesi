import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_kitap_chesmesi/app/app.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/login_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';

class LoginDataSource {
  final DioClient dioSetting;

  LoginDataSource({
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

  Future<RegisterModel> login(
      LoginModel loginModel, BuildContext context) async {
    try {
      final langCode = getCurrentLanguageCode(context);
      final response = await dioSetting.dio.post(
        '$langCode/auth/login',
        data: loginModel.toMap(),
      );
      if (response.statusCode == 201 && response.data['success'] == true) {
        // final getResponse = (response.data);
        // return getResponse;
        return RegisterModel.fromMap(response.data['data']);
      }
      // Yanıt geldi ama giriş kabul edilmedi.
      throw DioException.badResponse(
        statusCode: response.statusCode ?? 0,
        requestOptions: response.requestOptions,
        response: response,
      );
    } catch (e) {
      // Orijinal hatayı koru: LoginCubit bağlantı hatasını yanlış şifreden
      // ayırt edebilsin.
      debugPrint(e.toString());
      rethrow;
    }
  }
}
