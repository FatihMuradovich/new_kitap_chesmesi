import 'package:dio/dio.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_api_exception.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';

/// Sipariş uçları — ORDER-API.md §3.
///
/// Yollar sade yazılır (`user/order`): `DioClient` interceptor'ı dil önekini
/// (`tm`/`ru`/`en`) ve `Authorization` başlığını otomatik ekler, Dio `baseUrl` de
/// `.../api/` ile biter. Sonuç: `.../api/tm/user/order`.
class OrderDataSource {
  /// `reason` en fazla 500 karakter (ORDER-API.md §3).
  static const int maxCancelReasonLength = 500;

  final DioClient dioClient;

  OrderDataSource({required this.dioClient});

  Future<OrderResponse> createOrder(OrderRequest orderRequest) async {
    try {
      final response = await dioClient.dio.post(
        'order',
        data: orderRequest.toMap(),
      );
      return OrderResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _toOrderException(e);
    }
  }

  /// Giriş yapan kullanıcının siparişleri, en yeniden eskiye.
  /// Kitap detayı taşımaz — liste ekranı için kasıtlı olarak hafif.
  Future<OrdersPage> getMyOrders({
    int page = 1,
    int limit = 20,
    OrderStatus? status,
  }) async {
    try {
      final response = await dioClient.dio.get(
        'user/order',
        queryParameters: <String, dynamic>{
          'page': page,
          'limit': limit,
          if (status != null && status != OrderStatus.unknown)
            'status': status.apiValue,
          // ÖZEL SİPARİŞ — geçici olarak kapatıldı (§5 `isSpecialOrder` filtresi).
        },
      );
      return OrdersPage.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _toOrderException(e);
    }
  }

  /// Sipariş detayı — kitapların tam bilgisi ve durum geçmişi burada.
  /// Başkasının siparişi 404 döner.
  Future<OrderData> getOrderById(int id) async {
    try {
      final response = await dioClient.dio.get('user/order/$id');
      return _dataOf(response.data);
    } on DioException catch (e) {
      throw _toOrderException(e);
    }
  }

  /// Siparişi iptal et. Stok geri eklenir, kupon serbest bırakılır.
  /// Yanıt yalnızca güncellenmiş siparişi döner — `statusHistory` içermez.
  Future<OrderData> cancelOrder(int id, {String? reason}) async {
    final trimmed = reason?.trim();
    try {
      final response = await dioClient.dio.patch(
        'user/order/$id/cancel',
        data: <String, dynamic>{
          if (trimmed != null && trimmed.isNotEmpty)
            'reason': trimmed.length > maxCancelReasonLength
                ? trimmed.substring(0, maxCancelReasonLength)
                : trimmed,
        },
      );
      return _dataOf(response.data);
    } on DioException catch (e) {
      throw _toOrderException(e);
    }
  }

  OrderData _dataOf(dynamic body) {
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) return OrderData.fromMap(data);
      return OrderData.fromMap(body);
    }
    throw const OrderApiException(rawMessage: 'Unexpected response shape');
  }

  OrderApiException _toOrderException(DioException e) =>
      orderApiExceptionFrom(e);
}
