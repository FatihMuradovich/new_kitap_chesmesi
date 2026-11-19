import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/popup/data/models/popup_model.dart';

abstract class PopupState extends Equatable {
  const PopupState();

  @override
  List<Object?> get props => [];
}

class PopupInitial extends PopupState {}

class PopupLoading extends PopupState {}

class PopupLoaded extends PopupState {
  final PopupModel popup;

  const PopupLoaded({required this.popup});

  @override
  List<Object?> get props => [popup];
}

class PopupEmpty extends PopupState {}

class PopupError extends PopupState {
  final String message;

  const PopupError({required this.message});

  @override
  List<Object?> get props => [message];
}

