import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_code_model.dart';

abstract class RegisterCodeOtpRepository {
  Future<RegisterCodeModel> sendCode(String phoneNumber,String type, BuildContext context);
}
