// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:new_kitap_chesmesi/features/auth/domain/model/register_code_model.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/auth_error.dart';

abstract class RegisterCodeState extends Equatable {
  const RegisterCodeState();

  @override
  List<Object> get props => [];
}

class RegisterCodeInitial extends RegisterCodeState {}

class RegisterCodeLoading extends RegisterCodeState {}

class RegisterCodeSuccess extends RegisterCodeState {
  final RegisterCodeModel registerCodeModel;
  const RegisterCodeSuccess({
    required this.registerCodeModel,
  });
}

class RegisterCodeError extends RegisterCodeState {
  final AuthErrorReason reason;

  const RegisterCodeError({required this.reason});

  @override
  List<Object> get props => [reason];

  @override
  String toString() => 'RegisterCodeError(reason: $reason)';
}
