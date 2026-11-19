import 'package:new_kitap_chesmesi/features/order/domain/model/etrap_model.dart';

abstract class EtrapRepository {
  Future<List<EtrapModel>> getEtraps();
  Future<List<EtrapModel>> getEtrapsByWelayatId(
    int welayatId, {
    int page = 1,
    int limit = 15,
  });
}