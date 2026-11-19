// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:equatable/equatable.dart';

import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/auth_error.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  RegisterModel registerModel;
  RegisterSuccess({
    required this.registerModel,
  });
}

class RegisterError extends RegisterState {
  final AuthErrorReason reason;

  const RegisterError({required this.reason});

  @override
  List<Object> get props => [reason];

  @override
  String toString() => 'RegisterError(reason: $reason)';
}
