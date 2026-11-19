import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/forgot_password_model.dart';

abstract class ForgotPasswordRepository {
  Future<ForgotPasswordModel> forgotPassword(ForgotPasswordModel forgotPasswordModel, BuildContext context);
}
