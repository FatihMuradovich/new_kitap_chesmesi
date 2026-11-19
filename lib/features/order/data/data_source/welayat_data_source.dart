// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/welayat_model.dart';

class WelayatDataSource {
  final DioClient dioClient;
  WelayatDataSource({
    required this.dioClient,
  });

  Future<List<WelayatModel>> getWelayats() async {
    try {
      final response = await dioClient.dio.get('/welayat');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data
            .map((welayat) => WelayatModel.fromMap(welayat))
            .toList();
      } else {
        throw Exception('Failed to fetch welayats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch welayats: $e');
    }
  }
}
