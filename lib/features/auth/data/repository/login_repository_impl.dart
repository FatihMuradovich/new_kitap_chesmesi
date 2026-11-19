import 'package:new_kitap_chesmesi/features/auth/data/data_source/login_data_source.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/login_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginDataSource loginDataSource;
  LoginRepositoryImpl({
    required this.loginDataSource,
  });
  @override
  Future<RegisterModel> login(LoginModel loginModel, context) async {
    return await loginDataSource.login(loginModel, context);
  }
}
