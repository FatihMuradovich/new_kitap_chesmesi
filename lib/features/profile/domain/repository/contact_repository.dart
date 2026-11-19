import 'package:new_kitap_chesmesi/features/profile/domain/model/contact_model.dart';

abstract class ContactRepository {
  Future<ContactModel> sendMessage(String message);
}
