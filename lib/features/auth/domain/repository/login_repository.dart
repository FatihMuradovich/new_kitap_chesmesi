import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/login_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';

abstract class LoginRepository {
  Future<RegisterModel> login(LoginModel loginModel, BuildContext context);
}
