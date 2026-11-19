// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:new_kitap_chesmesi/features/auth/domain/model/register_code_model.dart';

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
  final String message;

  const RegisterCodeError({required this.message});

  @override
  List<Object> get props => [message];
}
