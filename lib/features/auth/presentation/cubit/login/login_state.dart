import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}

// ignore: must_be_immutable
class LoginSuccess extends LoginState {
  RegisterModel registerModel;
  LoginSuccess({
    required this.registerModel,
  });

  @override
  String toString() => 'LoginSuccess(registerModel: $registerModel)';
}

/// Hata metni UI'da kullanıcının diline göre seçilir; cubit yalnızca nedeni bilir.
enum LoginErrorReason { invalidCredentials, connection, unknown }

class LoginError extends LoginState {
  final LoginErrorReason reason;

  const LoginError({required this.reason});

  @override
  List<Object> get props => [reason];

  @override
  String toString() => 'LoginError(reason: $reason)';
}
