import 'package:dio/dio.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_api_exception.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/delivery_method_model.dart';

/// Getirtme usulleri — SPECIAL-ORDER-API.md §4 `GET /delivery-method`.
///
/// Token istemez (public), ama interceptor varsa Authorization eklemesi zararsız.
/// Yol sade yazılır: dil önekini `DioClient` interceptor'ı ekler.
class DeliveryMethodDataSource {
  final DioClient dioClient;

  DeliveryMethodDataSource({required this.dioClient});

  Future<List<DeliveryMethodModel>> getDeliveryMethods() async {
    try {
      final response = await dioClient.dio.get('delivery-method');
      final body = response.data;
      if (body is Map<String, dynamic>) {
        return DeliveryMethodModel.listFrom(body['data']);
      }
      return DeliveryMethodModel.listFrom(body);
    } on DioException catch (e) {
      throw orderApiExceptionFrom(e);
    }
  }
}
