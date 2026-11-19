import 'package:new_kitap_chesmesi/features/auth/data/data_source/forgot_password_data_source.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/forgot_password_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/forgot_password_repository.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  ForgotPasswordDataSource forgotPasswordDataSource;
  ForgotPasswordRepositoryImpl({
    required this.forgotPasswordDataSource,
  });
  @override
  Future<ForgotPasswordModel> forgotPassword(ForgotPasswordModel forgotPasswordModel, context) async {
    return await forgotPasswordDataSource.forgotPassword(forgotPasswordModel, context);
  }
}
