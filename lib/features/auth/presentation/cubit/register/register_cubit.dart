import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/register_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_state.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/service/notification_token_data_source.dart';
import 'package:new_kitap_chesmesi/core/service/service.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository registerRepository;
  final NotificationTokenDataSource notificationTokenDataSource;
  final FirebaseNotificatioService firebaseNotificationService;

  RegisterCubit({
    required this.registerRepository,
    required this.notificationTokenDataSource,
    required this.firebaseNotificationService,
  }) : super(RegisterInitial());

  Future<void> register(
      RegisterModel registerModel, BuildContext context) async {
    emit(RegisterLoading());
    try {
      final result = await registerRepository.register(registerModel, context);
    
      // Persist tokens on successful register
      if (result.accessToken != null && result.refreshToken != null) {
        // Use DioClient helper via DI
        final dioClient = di<DioClient>();
        await dioClient.addToken(result.accessToken!, result.refreshToken!);

        // Register FCM token after successful registration
        try {
          final fcmToken = await firebaseNotificationService.getToken();
          if (fcmToken != null) {
            await notificationTokenDataSource.registerToken(fcmToken);
          } else {
            log('FCM Token is null, skipping registration', name: 'Register');
          }
        } catch (e) {
          // Don't fail registration if FCM token registration fails
          log('Failed to register FCM token after registration: $e', name: 'Register Error');
        }
      }
      emit(RegisterSuccess(registerModel: result));
    } catch (e) {
      // Extract clean error message
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }
      emit(RegisterError(message: errorMessage));
    }
  }
}
