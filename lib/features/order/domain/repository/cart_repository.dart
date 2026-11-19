import 'package:new_kitap_chesmesi/features/order/domain/model/cart_model.dart';

abstract class CartRepository {
  Future<CartResponseModel> getCartItems();
  Future<void> addToCart(int bookId, int quantity);
  Future<void> updateCartQuantityByBookId(int bookId, int quantity);
  Future<void> removeFromCartByBookId(int bookId);
  Future<void> clearCart();
}
