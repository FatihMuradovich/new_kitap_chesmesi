import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/forgot_password_model.dart';

abstract class ForgotState extends Equatable {
  const ForgotState();

  @override
  List<Object> get props => [];
}

class ForgotInitial extends ForgotState {
  @override
  String toString() => 'ForgotInitial';
}

class ForgotLoading extends ForgotState {
  @override
  String toString() => 'ForgotLoading';
}

// ignore: must_be_immutable
class ForgotSuccess extends ForgotState {
  ForgotPasswordModel forgotPasswordModel;
  ForgotSuccess({
    required this.forgotPasswordModel,
  });

  @override
  String toString() =>
      'ForgotSuccess(forgotPasswordModel: $forgotPasswordModel)';
}

class ForgotError extends ForgotState {
  final String message;

  const ForgotError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ForgotError(message: $message)';
}
