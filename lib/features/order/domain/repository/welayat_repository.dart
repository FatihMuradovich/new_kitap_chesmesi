import 'package:new_kitap_chesmesi/features/order/domain/model/welayat_model.dart';

abstract class WelayatRepository {
  Future<List<WelayatModel>> getWelayats();
}