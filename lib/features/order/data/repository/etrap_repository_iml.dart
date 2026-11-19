import 'package:new_kitap_chesmesi/features/order/data/data_source/etrap_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/etrap_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/etrap_repository.dart';

class EtrapRepositoryImpl implements EtrapRepository {
  final EtrapDataSource etrapDataSource;
  EtrapRepositoryImpl({
    required this.etrapDataSource,
  });

  @override
  Future<List<EtrapModel>> getEtraps() async {
    try {
      return await etrapDataSource.getEtraps();
    } catch (e) {
      throw Exception('Failed to fetch etraps: $e');
    }
  }

  @override
  Future<List<EtrapModel>> getEtrapsByWelayatId(
    int welayatId, {
    int page = 1,
    int limit = 15,
  }) async {
    try {
      return await etrapDataSource.getEtrapsByWelayatId(
        welayatId,
        page: page,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to fetch etraps by welayat: $e');
    }
  }
}