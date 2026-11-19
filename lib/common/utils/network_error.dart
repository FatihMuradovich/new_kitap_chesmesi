import 'dart:io';

import 'package:dio/dio.dart';

/// İstek sunucuya hiç ulaşamadı ya da yanıt zamanında gelmedi
/// (internet yok, zayıf bağlantı). Sunucunun verdiği hatalardan ayrılır.
bool isConnectionError(Object error) {
  if (error is SocketException) return true;
  if (error is! DioException) return false;
  switch (error.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return true;
    case DioExceptionType.unknown:
      return error.error is SocketException;
    default:
      return false;
  }
}

/// Sunucunun döndüğü HTTP durum kodu; yanıt yoksa null.
int? statusCodeOf(Object error) =>
    error is DioException ? error.response?.statusCode : null;
