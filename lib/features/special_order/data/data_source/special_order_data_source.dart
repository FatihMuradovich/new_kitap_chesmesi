import 'package:dio/dio.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_api_exception.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';

/// Özel sipariş uçları — SPECIAL-ORDER-API.md §4.
///
/// Yollar sade yazılır (`special-order`): `DioClient` interceptor'ı dil önekini
/// (`tm`/`ru`/`en`) ve `Authorization` başlığını otomatik ekler, Dio `baseUrl` de
/// `.../api/` ile biter. Sonuç: `.../api/tm/special-order`.
class SpecialOrderDataSource {
  /// `reason` alanı için üst sınır — `OrderDataSource.maxCancelReasonLength` ile aynı.
  static const int maxReasonLength = 500;

  final DioClient dioClient;

  SpecialOrderDataSource({required this.dioClient});

  /// Talep aç. Bir talepte birden fazla kitap olabilir.
  ///
  /// 400 dönen durumlar: kitap stokta, kitap özel siparişe kapalı, ya da
  /// kullanıcının açık (`Pending`/`Quoted`) bir talebinde o kitap zaten var.
  Future<SpecialOrderRequestData> createRequest(
    CreateSpecialOrderRequest request,
  ) async {
    try {
      final response = await dioClient.dio.post(
        'special-order',
        data: request.toMap(),
      );
      return _requestOf(response.data);
    } on DioException catch (e) {
      throw orderApiExceptionFrom(e);
    }
  }

  /// Taleplerim, en yeniden eskiye.
  Future<SpecialOrdersPage> getMyRequests({
    int page = 1,
    int limit = 20,
    SpecialOrderStatus? status,
  }) async {
    try {
      final response = await dioClient.dio.get(
        'user/special-order',
        queryParameters: <String, dynamic>{
          'page': page,
          'limit': limit,
          if (status != null && status != SpecialOrderStatus.unknown)
            'status': status.apiValue,
        },
      );
      return SpecialOrdersPage.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw orderApiExceptionFrom(e);
    }
  }

  /// Talep detayı — teklif ekranının beslendiği uç. Başkasının talebi 404.
  Future<SpecialOrderRequestData> getRequestById(int id) async {
    try {
      final response = await dioClient.dio.get('user/special-order/$id');
      return _requestOf(response.data);
    } on DioException catch (e) {
      throw orderApiExceptionFrom(e);
    }
  }

  /// Teklifi onayla — **bu çağrı siparişi oluşturur**.
  /// Yanıt doğrudan `Order`: `isSpecialOrder: true`, `status: Confirmed`,
  /// `supplyStatus: Preparing`.
  Future<OrderData> approve(
    int id,
    ApproveSpecialOrderRequest request,
  ) async {
    try {
      final response = await dioClient.dio.post(
        'special-order/$id/approve',
        data: request.toMap(),
      );
      return _orderOf(response.data);
    } on DioException catch (e) {
      throw orderApiExceptionFrom(e);
    }
  }

  /// Teklifi reddet. Yalnızca `Quoted` iken.
  Future<SpecialOrderRequestData> reject(int id, {String? reason}) =>
      _postWithReason('special-order/$id/reject', reason);

  /// Talebi iptal et. `Pending` veya `Quoted` iken.
  Future<SpecialOrderRequestData> cancel(int id, {String? reason}) =>
      _postWithReason('special-order/$id/cancel', reason);

  Future<SpecialOrderRequestData> _postWithReason(
    String path,
    String? reason,
  ) async {
    final trimmed = reason?.trim();
    try {
      final response = await dioClient.dio.post(
        path,
        data: <String, dynamic>{
          if (trimmed != null && trimmed.isNotEmpty)
            'reason': trimmed.length > maxReasonLength
                ? trimmed.substring(0, maxReasonLength)
                : trimmed,
        },
      );
      return _requestOf(response.data);
    } on DioException catch (e) {
      throw orderApiExceptionFrom(e);
    }
  }

  SpecialOrderRequestData _requestOf(dynamic body) {
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return SpecialOrderRequestData.fromMap(data);
      }
      return SpecialOrderRequestData.fromMap(body);
    }
    throw const OrderApiException(rawMessage: 'Unexpected response shape');
  }

  OrderData _orderOf(dynamic body) {
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) return OrderData.fromMap(data);
      return OrderData.fromMap(body);
    }
    throw const OrderApiException(rawMessage: 'Unexpected response shape');
  }
}
