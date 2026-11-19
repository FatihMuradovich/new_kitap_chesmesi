import 'package:new_kitap_chesmesi/features/order/data/data_source/welayat_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/welayat_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/welayat_repository.dart';

class WelayatRepositoryImpl implements WelayatRepository {
  final WelayatDataSource welayatDataSource;
  WelayatRepositoryImpl({
    required this.welayatDataSource,
  });

  @override
  Future<List<WelayatModel>> getWelayats() async {
    try {
      return await welayatDataSource.getWelayats();
    } catch (e) {
      throw Exception('Failed to fetch welayats: $e');
    }
  }
}
