import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';

abstract class RegisterRepository {
  Future<RegisterModel> register(RegisterModel registerModel, BuildContext context);
}
