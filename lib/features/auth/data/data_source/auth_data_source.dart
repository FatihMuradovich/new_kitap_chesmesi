import 'package:new_kitap_chesmesi/features/auth/domain/model/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> register({
    required String name,
    required String surname,
    required String birthday,
    required String phone,
    required String password,
  });

  Future<UserModel> login({
    required String phone,
    required String password,
  });
}