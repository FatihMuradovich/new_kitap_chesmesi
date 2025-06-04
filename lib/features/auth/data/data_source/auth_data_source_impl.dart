import 'package:dio/dio.dart';
import 'package:new_kitap_chesmesi/features/auth/data/data_source/auth_data_source.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/user_model.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio dio;

  AuthDataSourceImpl({required this.dio});

  @override
  Future<UserModel> register({
    required String name,
    required String surname,
    required String birthday,
    required String phone,
    required String password,
  }) async {
    final response = await dio.post('register/',
        data: {
          'first_name': name,
          'last_name': surname,
          'birthday': birthday,
          'phone_number': phone,
          'password': password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}));
    return UserModel.fromJsonRegister(response.data);
  }

  @override
  Future<UserModel> login({
    required String phone,
    required String password,
  }) async {
    final response = await dio.post(
      'login/',
      data: {'username': phone, 'password': password},
    );
    print(response.data);

    return UserModel.fromJson(response.data);
  }
}
