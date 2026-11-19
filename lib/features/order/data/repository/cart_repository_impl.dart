import 'package:new_kitap_chesmesi/features/order/data/data_source/cart_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/cart_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartDataSource cartDataSource;

  CartRepositoryImpl({
    required this.cartDataSource,
  });

  @override
  Future<CartResponseModel> getCartItems() async {
    try {
      return await cartDataSource.getCartItems();
    } catch (e) {
      rethrow; // Orijinal hata korunur: CartCubit bağlantı hatasını ayırt eder.
    }
  }

  @override
  Future<void> addToCart(int bookId, int quantity) async {
    try {
      await cartDataSource.addToCart(bookId, quantity);
    } catch (e) {
      rethrow; // Orijinal hata korunur: CartCubit bağlantı hatasını ayırt eder.
    }
  }

  @override
  Future<void> updateCartQuantityByBookId(int bookId, int quantity) async {
    try {
      await cartDataSource.updateCartQuantityByBookId(bookId, quantity);
    } catch (e) {
      rethrow; // Orijinal hata korunur: CartCubit bağlantı hatasını ayırt eder.
    }
  }

  @override
  Future<void> removeFromCartByBookId(int bookId) async {
    try {
      await cartDataSource.removeFromCartByBookId(bookId);
    } catch (e) {
      rethrow; // Orijinal hata korunur: CartCubit bağlantı hatasını ayırt eder.
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await cartDataSource.clearCart();
    } catch (e) {
      rethrow; // Orijinal hata korunur: CartCubit bağlantı hatasını ayırt eder.
    }
  }
}
