import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/contact_repository.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/contact/contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactRepository contactRepository;

  ContactCubit({required this.contactRepository}) : super(ContactInitial());

  Future<void> sendMessage(String message) async {
    try {
      log('ContactCubit: sendMessage başlatıldı');
      emit(ContactLoading());
      
      final contact = await contactRepository.sendMessage(message);
      log('ContactCubit: Mesaj başarıyla gönderildi: ${contact.message}');
      
      emit(ContactSuccess(contact));
    } catch (e) {
      log('ContactCubit: Hata oluştu: $e');
      log('ContactCubit: Hata tipi: ${e.runtimeType}');
      emit(ContactError(e.toString()));
    }
  }

  void resetState() {
    emit(ContactInitial());
  }
}
