import 'package:new_kitap_chesmesi/features/auth/data/data_source/register_data_source.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  RegisterDataSource dataSource;
  RegisterRepositoryImpl({
    required this.dataSource,
  });
  @override
  Future<RegisterModel> register(RegisterModel register, context) async {
    return await dataSource.register(register, context);
  }
}
