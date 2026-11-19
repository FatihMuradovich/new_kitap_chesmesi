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

class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object> get props => [message];
  
  @override
  String toString() => 'LoginError(message: $message)';
}
