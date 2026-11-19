import 'package:new_kitap_chesmesi/features/profile/data/data_source/contact_data_source.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/model/contact_model.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactDataSource contactDataSource;

  ContactRepositoryImpl({required this.contactDataSource});

  @override
  Future<ContactModel> sendMessage(String message) async {
    return await contactDataSource.sendMessage(message);
  }
}