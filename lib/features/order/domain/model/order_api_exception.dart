import 'package:dio/dio.dart';

/// Sipariş uçlarından dönen hata.
///
/// Backend mesajları İngilizce ve teknik (ORDER-API.md §3) — kullanıcıya doğrudan
/// gösterilmez. UI yalnızca [statusCode] ve siparişin mevcut durumuna bakıp kendi
/// yerelleştirilmiş metnini seçer; [rawMessage] sadece log/hata ayıklama içindir.
class OrderApiException implements Exception {
  final int? statusCode;
  final String? rawMessage;

  const OrderApiException({this.statusCode, this.rawMessage});

  @override
  String toString() =>
      'OrderApiException(statusCode: $statusCode, rawMessage: $rawMessage)';
}

/// `DioException` → [OrderApiException]. Sipariş ve özel sipariş uçlarının
/// tamamı bunu kullanır; doğrulama hataları gövdede dizi olarak geldiği için
/// (`message: [...]`) birleştirilir.
OrderApiException orderApiExceptionFrom(DioException e) {
  final body = e.response?.data;
  String? message;
  if (body is Map<String, dynamic>) {
    final raw = body['message'];
    message = raw is List ? raw.join(', ') : raw?.toString();
  }
  return OrderApiException(
    statusCode: e.response?.statusCode,
    rawMessage: message ?? e.message,
  );
}
