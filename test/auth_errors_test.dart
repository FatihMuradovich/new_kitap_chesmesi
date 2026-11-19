import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/core/service/notification_token_data_source.dart';
import 'package:new_kitap_chesmesi/core/service/service.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/forgot_password_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_code_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/forgot_password_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/register_code_otp_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/register_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/auth_error.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/forgot/forgot_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/forgot/forgot_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register_code/register_code_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register_code/register_code_state.dart';

class _Ctx extends Fake implements BuildContext {}

class _Tokens extends Fake implements NotificationTokenDataSource {}

class _Firebase extends Fake implements FirebaseNotificatioService {}

class _Repo
    implements
        RegisterCodeOtpRepository,
        RegisterRepository,
        ForgotPasswordRepository {
  _Repo(this.error);
  final Object error;

  @override
  Future<RegisterCodeModel> sendCode(
          String phoneNumber, String type, BuildContext context) =>
      Future.error(error);
  @override
  Future<RegisterModel> register(RegisterModel m, BuildContext context) =>
      Future.error(error);
  @override
  Future<ForgotPasswordModel> forgotPassword(
          ForgotPasswordModel m, BuildContext context) =>
      Future.error(error);
}

DioException _http(int status) {
  final o = RequestOptions(path: 'x');
  return DioException(
    requestOptions: o,
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: o,
      statusCode: status,
      // Sunucunun İngilizce doğrulama listesi kullanıcıya gösterilmemeli.
      data: {
        'message': ['phoneNumber must be a valid phone number'],
      },
    ),
  );
}

final _offline = DioException(
  requestOptions: RequestOptions(path: 'x'),
  type: DioExceptionType.connectionError,
);

Future<AuthErrorReason> _sendCode(Object error, String type) async {
  final cubit = RegisterCodeCubit(registerCodeOtpRepository: _Repo(error));
  await cubit.sendCode('+99361000000', type, _Ctx());
  return (cubit.state as RegisterCodeError).reason;
}

Future<AuthErrorReason> _register(Object error) async {
  final cubit = RegisterCubit(
    registerRepository: _Repo(error),
    notificationTokenDataSource: _Tokens(),
    firebaseNotificationService: _Firebase(),
  );
  await cubit.register(
    RegisterModel(
      userDetailModel: UserDetailModel(
        name: 'A',
        surname: 'B',
        phoneNumber: '+99361000000',
        birthday: '2000-01-01',
      ),
    ),
    _Ctx(),
  );
  return (cubit.state as RegisterError).reason;
}

Future<AuthErrorReason> _forgot(Object error) async {
  final cubit = ForgotCubit(forgotPasswordRepository: _Repo(error));
  await cubit.forgotPasswword(ForgotPasswordModel(), _Ctx());
  return (cubit.state as ForgotError).reason;
}

void main() {
  test('Kayıt kodu: 4xx → numara zaten kayıtlı', () async {
    expect(await _sendCode(_http(409), 'Register'),
        AuthErrorReason.phoneAlreadyRegistered);
    expect(await _sendCode(_http(400), 'Register'),
        AuthErrorReason.phoneAlreadyRegistered);
  });

  test('Şifre sıfırlama kodu: 4xx → genel hata (numara kayıtlı mesajı değil)',
      () async {
    expect(
        await _sendCode(_http(400), 'ForgotPassword'), AuthErrorReason.unknown);
  });

  test('Kayıt / yeni şifre: 4xx → kod yanlış', () async {
    expect(await _register(_http(400)), AuthErrorReason.invalidCode);
    expect(await _forgot(_http(400)), AuthErrorReason.invalidCode);
  });

  test('Ortak: internet yok, çok fazla deneme, sunucu hatası', () async {
    expect(await _sendCode(_offline, 'Register'), AuthErrorReason.connection);
    expect(await _register(_offline), AuthErrorReason.connection);
    expect(await _forgot(_offline), AuthErrorReason.connection);
    expect(await _sendCode(_http(429), 'Register'),
        AuthErrorReason.tooManyRequests);
    expect(await _register(_http(500)), AuthErrorReason.unknown);
  });
}
