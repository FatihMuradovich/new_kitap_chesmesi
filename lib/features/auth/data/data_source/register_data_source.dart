// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:new_kitap_chesmesi/app/app.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';

class RegisterDataSource {
  final DioClient dioSetting;

  RegisterDataSource({
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

  Future<RegisterModel> register(
      RegisterModel registerModel, BuildContext context) async {
    try {
      final langCode = getCurrentLanguageCode(context);
      final response = await dioSetting.dio.post(
        '$langCode/auth/register',
        data: registerModel.userDetailModel.toMap(),
      );
      // if (response.statusCode == 200 && response.data['success'] == true) {
      return RegisterModel.fromMap(response.data['data']);
    } catch (e) {
      debugPrint(e.toString());
      rethrow; // Orijinal hata korunur: cubit nedeni (internet / red) ayırt eder.
    }
  }
}
