import 'package:new_kitap_chesmesi/features/auth/data/data_source/auth_data_source.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/user_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<UserModel> login({required String phone, required String password}) {
    return dataSource.login(phone: phone, password: password);
  }

  @override
  Future<UserModel> register({
    required String name,
    required String surname,
    required String birthday,
    required String phone,
    required String password,
  }) {
    return dataSource.register(
      name: name,
      surname: surname,
      birthday: birthday,
      phone: phone,
      password: password,
    );
  }
}
