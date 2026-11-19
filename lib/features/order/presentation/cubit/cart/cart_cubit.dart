import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/cart_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/cart_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository cartRepository;

  CartCubit({required this.cartRepository}) : super(CartInitial());

  Future<void> getCartItems() async {
    try {
      emit(CartLoading());

      final cartResponse = await cartRepository.getCartItems();
      final cartItems = cartResponse.data;

      // Toplam tutarı hesapla
      final totalAmount = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

      emit(CartLoaded(
        cartItems: cartItems,
        totalAmount: totalAmount,
      ));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> addToCart(int bookId, int quantity) async {
    try {
      emit(CartItemAdding());

      await cartRepository.addToCart(bookId, quantity);

      emit(CartItemAdded());

      await getCartItems();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> clearCart() async {
    try {
      emit(CartClearing());

      await cartRepository.clearCart();

      emit(CartCleared());

      emit(const CartLoaded(cartItems: [], totalAmount: 0.0));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> increaseQuantityWithStockCheck(CartItemModel cartItem) async {
    if (cartItem.quantity >= cartItem.stock) {
      emit(CartError(
          message:
              'Stokta yeterli ürün bulunmamaktadır. Maksimum ${cartItem.stock} adet ekleyebilirsiniz.'));
      return;
    }

    final currentState = state;
    if (currentState is! CartLoaded) return;

    try {
      // Optimistic update - önce UI'ı güncelle
      final updatedItems = currentState.cartItems.map((item) {
        if (item.cartItemId == cartItem.cartItemId) {
          return item.copyWith(quantity: item.quantity + 1);
        }
        return item;
      }).toList();

      // Yeni total amount'u hesapla
      final newTotalAmount = updatedItems.fold<double>(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

      // UI'ı hemen güncelle ve loading durumunu göster
      emit(currentState.copyWith(
        cartItems: updatedItems,
        totalAmount: newTotalAmount,
        updatingItemId: cartItem.cartItemId,
      ));

      // Arka planda API'ye istek at
      await cartRepository.updateCartQuantityByBookId(
          cartItem.id, cartItem.quantity + 1);

      // Başarılı olursa loading durumunu temizle
      emit((state as CartLoaded).copyWith(clearUpdatingItemId: true));
    } catch (e) {
      // Hata olursa eski state'e geri dön
      emit(currentState);
      emit(CartError(message: e.toString()));
      // Gerçek veriyi sunucudan tekrar yükle
      await getCartItems();
    }
  }

  Future<void> decreaseQuantityWithCheck(CartItemModel cartItem) async {
    if (cartItem.quantity <= 1) {
      // Dialog göstermeden direkt olarak ürünü sepetten çıkar
      await confirmRemoveFromCart(cartItem.id);
      return;
    }

    final currentState = state;
    if (currentState is! CartLoaded) return;

    try {
      // Optimistic update - önce UI'ı güncelle
      final updatedItems = currentState.cartItems.map((item) {
        if (item.cartItemId == cartItem.cartItemId) {
          return item.copyWith(quantity: item.quantity - 1);
        }
        return item;
      }).toList();

      // Yeni total amount'u hesapla
      final newTotalAmount = updatedItems.fold<double>(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

      // UI'ı hemen güncelle ve loading durumunu göster
      emit(currentState.copyWith(
        cartItems: updatedItems,
        totalAmount: newTotalAmount,
        updatingItemId: cartItem.cartItemId,
      ));

      // Arka planda API'ye istek at
      await cartRepository.updateCartQuantityByBookId(
          cartItem.id, cartItem.quantity - 1);

      // Başarılı olursa loading durumunu temizle
      emit((state as CartLoaded).copyWith(clearUpdatingItemId: true));
    } catch (e) {
      // Hata olursa eski state'e geri dön
      emit(currentState);
      emit(CartError(message: e.toString()));
      // Gerçek veriyi sunucudan tekrar yükle
      await getCartItems();
    }
  }

  Future<void> confirmRemoveFromCart(int bookId) async {
    try {
      emit(CartItemRemoving());

      await cartRepository.removeFromCartByBookId(bookId);

      emit(CartItemRemoved());

      await getCartItems();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  int get cartItemCount {
    final currentState = state;
    if (currentState is CartLoaded) {
      return currentState.cartItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );
    }
    return 0;
  }

  double get totalAmount {
    final currentState = state;
    if (currentState is CartLoaded) {
      return currentState.totalAmount;
    }
    return 0.0;
  }
}
