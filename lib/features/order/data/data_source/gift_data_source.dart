
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/gift_model.dart';

class GiftDataSource {
  final DioClient dioClient;

  GiftDataSource({required this.dioClient});

  Future<List<GiftModel>> getGifts() async {
    try {
      final response = await dioClient.dio.get(
        '/gift',
      );

      if (response.statusCode == 200) {
        final giftResponse = GiftResponse.fromMap(response.data);
        return giftResponse.data;
      } else {
        throw Exception('Failed to fetch gifts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch gifts: $e');
    }
  }
}
