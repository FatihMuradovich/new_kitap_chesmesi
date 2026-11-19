import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/forgot_password_model.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/auth_error.dart';

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
  final AuthErrorReason reason;

  const ForgotError({required this.reason});

  @override
  List<Object> get props => [reason];

  @override
  String toString() => 'ForgotError(reason: $reason)';
}
