import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/common/utils/network_error.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/cart_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/cart_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository cartRepository;

  CartCubit({required this.cartRepository}) : super(CartInitial());

  /// Son başarılı sepet. Ekleme/silme gibi ara durumlarda ve hatalarda
  /// sepet adedi ve ürünler bunun üzerinden okunur; aksi halde kısa süreliğine
  /// 0 görünür ve stok kontrolü atlanırdı.
  CartLoaded? _lastLoaded;

  @override
  void onChange(Change<CartState> change) {
    super.onChange(change);
    final next = change.nextState;
    if (next is CartLoaded) {
      _lastLoaded = next;
    } else if (next is CartInitial) {
      _lastLoaded = null;
    }
  }

  Future<void> getCartItems() async {
    try {
      emit(CartLoading());

      final cartResponse = await cartRepository.getCartItems();
      final cartItems = cartResponse.data;

      emit(CartLoaded(
        cartItems: cartItems,
        totalAmount: _total(cartItems),
      ));
    } catch (e) {
      emit(CartError(reason: _reasonFor(e)));
    }
  }

  Future<void> addToCart(int bookId, int quantity) async {
    try {
      emit(CartItemAdding());

      await cartRepository.addToCart(bookId, quantity);

      emit(CartItemAdded());

      await getCartItems();
    } catch (e) {
      _failAction(e);
    }
  }

  Future<void> clearCart() async {
    try {
      emit(CartClearing());

      await cartRepository.clearCart();

      emit(CartCleared());

      emit(const CartLoaded(cartItems: [], totalAmount: 0.0));
    } catch (e) {
      _failAction(e);
    }
  }

  Future<void> increaseQuantityWithStockCheck(CartItemModel cartItem) async {
    if (cartItem.quantity >= cartItem.stock) {
      _failAction(null,
          reason: CartFailureReason.stockLimit, maxStock: cartItem.stock);
      return;
    }
    await _changeQuantity(cartItem, cartItem.quantity + 1);
  }

  Future<void> decreaseQuantityWithCheck(CartItemModel cartItem) async {
    if (cartItem.quantity <= 1) {
      // Dialog göstermeden direkt olarak ürünü sepetten çıkar
      await confirmRemoveFromCart(cartItem.id);
      return;
    }
    await _changeQuantity(cartItem, cartItem.quantity - 1);
  }

  Future<void> _changeQuantity(CartItemModel cartItem, int newQuantity) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    // Optimistic update - önce UI'ı güncelle
    final updatedItems = currentState.cartItems.map((item) {
      if (item.cartItemId == cartItem.cartItemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    emit(currentState.copyWith(
      cartItems: updatedItems,
      totalAmount: _total(updatedItems),
      updatingItemId: cartItem.cartItemId,
    ));

    try {
      await cartRepository.updateCartQuantityByBookId(cartItem.id, newQuantity);

      // Başarılı olursa loading durumunu temizle
      final now = state;
      if (now is CartLoaded) emit(now.copyWith(clearUpdatingItemId: true));
    } catch (e) {
      // Hata olursa sunucudaki son bilinen duruma geri dön
      _failAction(e, restore: currentState);
      // İnternet varsa gerçek veriyi sunucudan tekrar yükle (sunucu değişikliği
      // kısmen uygulamış olabilir). İnternet yoksa yüklemek sepeti silerdi.
      if (!isConnectionError(e)) await _reloadQuietly();
    }
  }

  Future<void> confirmRemoveFromCart(int bookId) async {
    try {
      emit(CartItemRemoving());

      await cartRepository.removeFromCartByBookId(bookId);

      emit(CartItemRemoved());

      await getCartItems();
    } catch (e) {
      _failAction(e);
    }
  }

  /// Oturum kapanınca çağrılır — önceki kullanıcının sepeti ekranda kalmasın.
  void reset() => emit(CartInitial());

  /// Bu kitaptan sepette kaç adet var (sepet hiç yüklenmediyse 0).
  int quantityInCart(int bookId) {
    for (final item in _lastLoaded?.cartItems ?? const <CartItemModel>[]) {
      if (item.id == bookId) return item.quantity;
    }
    return 0;
  }

  int get cartItemCount => (_lastLoaded?.cartItems ?? const <CartItemModel>[])
      .fold<int>(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _lastLoaded?.totalAmount ?? 0.0;

  void _failAction(
    Object? error, {
    CartFailureReason? reason,
    int? maxStock,
    CartLoaded? restore,
  }) {
    emit(CartActionError(
      reason: reason ?? _reasonFor(error!),
      maxStock: maxStock,
    ));
    final previous = restore ?? _lastLoaded;
    if (previous != null) emit(previous.copyWith(clearUpdatingItemId: true));
  }

  Future<void> _reloadQuietly() async {
    try {
      final response = await cartRepository.getCartItems();
      emit(CartLoaded(
        cartItems: response.data,
        totalAmount: _total(response.data),
      ));
    } catch (_) {
      // Eldeki sepet ekranda kalsın.
    }
  }

  static double _total(List<CartItemModel> items) =>
      items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

  static CartFailureReason _reasonFor(Object error) => isConnectionError(error)
      ? CartFailureReason.connection
      : CartFailureReason.unknown;
}
