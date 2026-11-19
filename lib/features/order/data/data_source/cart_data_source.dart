import 'package:flutter/foundation.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/cart_model.dart';

class CartDataSource {
  final DioClient dioClient;

  CartDataSource({
    required this.dioClient,
  });

  Future<CartResponseModel> getCartItems() async {
    try {
      final response = await dioClient.dio.get('/cart');

      if (response.statusCode == 200) {
        try {
          return CartResponseModel.fromMap(response.data);
        } catch (e, trace) {
          debugPrint(e.toString());
          debugPrint(trace.toString());
        }
        return CartResponseModel.fromMap(response.data);
      } else {
        throw Exception('Sepet öğeleri getirilemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Sepet API hatası: $e');
    }
  }

  Future<void> addToCart(int bookId, int quantity) async {
    try {
      final response = await dioClient.dio.post(
        '/cart',
        data: {
          'bookId': bookId,
          'quantity': quantity,
        },
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Ürün sepete eklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Sepete ekleme API hatası: $e');
    }
  }

  Future<void> updateCartQuantityByBookId(int bookId, int quantity) async {
    try {
      final response = await dioClient.dio.patch(
        '/cart',
        data: {
          'bookId': bookId,
          'quantity': quantity,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Sepet miktarı güncellenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Sepet miktar güncelleme API hatası: $e');
    }
  }

  Future<void> removeFromCartByBookId(int bookId) async {
    try {
      final response = await dioClient.dio.delete('/cart/$bookId');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Ürün sepetten çıkarılamadı: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Sepetten çıkarma API hatası: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      final response = await dioClient.dio.delete('/cart');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Sepet temizlenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Sepet temizleme API hatası: $e');
    }
  }
}
