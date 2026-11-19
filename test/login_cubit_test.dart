import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/core/service/notification_token_data_source.dart';
import 'package:new_kitap_chesmesi/core/service/service.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/login_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/login_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_state.dart';

class _FakeContext extends Fake implements BuildContext {}

class _FakeTokenDataSource extends Fake
    implements NotificationTokenDataSource {}

class _FakeFirebase extends Fake implements FirebaseNotificatioService {}

class _ThrowingLoginRepository implements LoginRepository {
  _ThrowingLoginRepository(this.error);
  final Object error;

  @override
  Future<RegisterModel> login(LoginModel loginModel, BuildContext context) =>
      Future.error(error);
}

DioException _dioError(
    {DioExceptionType type = DioExceptionType.badResponse, int? status}) {
  final options = RequestOptions(path: 'tm/auth/login');
  return DioException(
    requestOptions: options,
    type: type,
    response: status == null
        ? null
        : Response(requestOptions: options, statusCode: status),
  );
}

Future<LoginErrorReason> _reasonFor(Object error) async {
  final cubit = LoginCubit(
    loginRepository: _ThrowingLoginRepository(error),
    notificationTokenDataSource: _FakeTokenDataSource(),
    firebaseNotificationService: _FakeFirebase(),
  );
  await cubit.login(
      LoginModel(phoneNumber: '61000000', password: 'x'), _FakeContext());
  return (cubit.state as LoginError).reason;
}

void main() {
  test('Yanlış şifre (401/400) → geçersiz bilgiler', () async {
    expect(await _reasonFor(_dioError(status: 401)),
        LoginErrorReason.invalidCredentials);
    expect(await _reasonFor(_dioError(status: 400)),
        LoginErrorReason.invalidCredentials);
  });

  test('İnternet yok / zaman aşımı → bağlantı hatası, "yanlış şifre" değil',
      () async {
    expect(await _reasonFor(_dioError(type: DioExceptionType.connectionError)),
        LoginErrorReason.connection);
    expect(
        await _reasonFor(_dioError(type: DioExceptionType.connectionTimeout)),
        LoginErrorReason.connection);
  });

  test('Sunucu hatası (500) → genel hata', () async {
    expect(await _reasonFor(_dioError(status: 500)), LoginErrorReason.unknown);
  });
}
