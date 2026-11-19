import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/service/language_service.dart';

class NotificationTokenDataSource {
  final DioClient dioClient;

  NotificationTokenDataSource({required this.dioClient});

  Future<void> registerToken(String token) async {
    try {
      log('Registering FCM Token: $token', name: 'FCM Token Registration');
      
      final response = await dioClient.dio.post(
        '/notification/register-token',
        data: {
          'token': token,
          // Bildirim metninin dili buradan seçilir; gönderilmezse Türkmence gider.
          'locale': di<LanguageService>().apiLanguageCode,
        },
         options: Options(
          extra: {DioClient.kSkipTokenRefresh: true}, 
        ),
      );

      if (response.statusCode == 200) {
        log('FCM Token registered successfully', name: 'FCM Token Registration');
      } else {
        log('Failed to register FCM token. Status code: ${response.statusCode}', 
            name: 'FCM Token Registration Error');
       // throw Exception('Failed to register FCM token');
      }
    } catch (e) {
      log('Error registering FCM token: $e', name: 'FCM Token Registration Error');
      //throw Exception('Error registering FCM token: $e');
    }
  }
}

