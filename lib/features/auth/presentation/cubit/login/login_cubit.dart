import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/login_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/login_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_state.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/service/notification_token_data_source.dart';
import 'package:new_kitap_chesmesi/core/service/service.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;
  final NotificationTokenDataSource notificationTokenDataSource;
  final FirebaseNotificatioService firebaseNotificationService;

  LoginCubit({
    required this.loginRepository,
    required this.notificationTokenDataSource,
    required this.firebaseNotificationService,
  }) : super(LoginInitial());

  Future<void> login(LoginModel loginModel, BuildContext context) async {
    emit(LoginLoading());
    try {
      final result = await loginRepository.login(loginModel, context);
      // Persist tokens
      if (result.accessToken != null && result.refreshToken != null) {
        // Use DioClient helper via DI
        final dioClient = di<DioClient>();
        await dioClient.addToken(result.accessToken!, result.refreshToken!);

        // Register FCM token after successful login
        try {
          final fcmToken = await firebaseNotificationService.getToken();
          if (fcmToken != null) {
            await notificationTokenDataSource.registerToken(fcmToken);
          } else {
            log('FCM Token is null, skipping registration', name: 'Login');
          }
        } catch (e) {
          // Don't fail login if FCM token registration fails
          log('Failed to register FCM token after login: $e', name: 'Login Error');
        }
      }
      emit(LoginSuccess(registerModel: result));
    } catch (e) {
      // Extract clean error message
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }
      emit(LoginError(message: errorMessage));
    }
  }
}
