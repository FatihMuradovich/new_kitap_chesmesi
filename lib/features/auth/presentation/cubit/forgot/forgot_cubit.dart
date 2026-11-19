import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/forgot_password_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/forgot_password_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/forgot/forgot_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/auth_error.dart';

class ForgotCubit extends Cubit<ForgotState> {
  ForgotPasswordRepository forgotPasswordRepository;
  ForgotCubit({
    required this.forgotPasswordRepository,
  }) : super(ForgotInitial());

  Future<void> forgotPasswword(
      ForgotPasswordModel forgotPasswordModel, BuildContext context) async {
    emit(ForgotLoading());
    try {
      final result = await forgotPasswordRepository.forgotPassword(
          forgotPasswordModel, context);

      emit(ForgotSuccess(forgotPasswordModel: result));
    } catch (e) {
      // Yeni şifre isteği reddedildiyse doğrulama kodu yanlış / süresi dolmuş.
      emit(ForgotError(
        reason: classifyAuthError(e, whenRejected: AuthErrorReason.invalidCode),
      ));
    }
  }
}
