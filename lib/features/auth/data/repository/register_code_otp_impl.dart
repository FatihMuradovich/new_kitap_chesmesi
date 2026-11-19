import 'package:new_kitap_chesmesi/features/auth/data/data_source/register_code_otp_data_source.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_code_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/register_code_otp_repository.dart';

class RegisterCodeOtpImpl implements RegisterCodeOtpRepository {
  RegisterCodeOtpDataSource registerCodeOtpDataSource;
  RegisterCodeOtpImpl({
    required this.registerCodeOtpDataSource,
  });
  @override
  Future<RegisterCodeModel> sendCode(String phoneNumber, String type, context) async {
    return await registerCodeOtpDataSource.sendCode(phoneNumber, type, context);
  }
}
