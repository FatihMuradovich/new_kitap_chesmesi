// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/register_code_otp_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register_code/register_code_state.dart';

class RegisterCodeCubit extends Cubit<RegisterCodeState> {
  RegisterCodeOtpRepository registerCodeOtpRepository;
  RegisterCodeCubit({
    required this.registerCodeOtpRepository,
  }) : super(RegisterCodeInitial());

  Future<void> sendCode(
      String phoneNumber, String type, BuildContext context) async {
    emit(RegisterCodeLoading());
    try {
      final result =
          await registerCodeOtpRepository.sendCode(phoneNumber, type, context);
      emit(RegisterCodeSuccess(registerCodeModel: result));
    } catch (e) {
      // Extract clean error message
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }
      emit(RegisterCodeError(message: errorMessage));
    }
  }
}
