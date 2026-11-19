// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/forgot_password_model.dart';

class ForgotPasswordDataSource {
  final DioClient dioSetting;
  ForgotPasswordDataSource({
    required this.dioSetting,
  });

  Future<ForgotPasswordModel> forgotPassword(
      ForgotPasswordModel forgotPasswordModel, BuildContext context) async {
    try {
      final response = await dioSetting.dio.post(
        '/auth/forgot-password',
        data: forgotPasswordModel.toMap(),
      );
      // if (response.statusCode == 200 && response.data['success'] == true) {
      return ForgotPasswordModel.fromMap(response.data['data']);
    } catch (e) {
      debugPrint(e.toString());
      rethrow; // Orijinal hata korunur: cubit nedeni (internet / red) ayırt eder.
    }
  }
}
