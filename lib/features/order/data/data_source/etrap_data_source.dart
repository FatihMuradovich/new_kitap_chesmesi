import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/etrap_model.dart';

class EtrapDataSource {
  final DioClient dioClient;
  EtrapDataSource({
    required this.dioClient,
  });

  Future<List<EtrapModel>> getEtraps() async {
    try {
      final response = await dioClient.dio.get('/etrap');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((etrap) => EtrapModel.fromMap(etrap)).toList();
      } else {
        throw Exception('Failed to fetch etraps: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch etraps: $e');
    }
  }

  Future<List<EtrapModel>> getEtrapsByWelayatId(
    int welayatId, {
    int page = 1,
    int limit = 15,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/etrap',
        queryParameters: {
          'welayatId': welayatId,
          'page': page,
          'limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((etrap) => EtrapModel.fromMap(etrap)).toList();
      } else {
        throw Exception('Failed to fetch etraps: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch etraps: $e');
    }
  }
}
