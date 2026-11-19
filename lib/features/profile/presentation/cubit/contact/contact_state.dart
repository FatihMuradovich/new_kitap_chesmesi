import 'package:new_kitap_chesmesi/features/profile/domain/model/contact_model.dart';

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactSuccess extends ContactState {
  final ContactModel contact;
  ContactSuccess(this.contact);
}

class ContactError extends ContactState {
  final String message;
  ContactError(this.message);
}
