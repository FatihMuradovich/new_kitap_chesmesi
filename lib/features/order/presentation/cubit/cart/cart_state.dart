part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> cartItems;
  final double totalAmount;
  final int? updatingItemId; // Güncellenmekte olan item'ın ID'si

  const CartLoaded({
    required this.cartItems,
    required this.totalAmount,
    this.updatingItemId,
  });

  @override
  List<Object?> get props => [cartItems, totalAmount, updatingItemId];

  CartLoaded copyWith({
    List<CartItemModel>? cartItems,
    double? totalAmount,
    int? updatingItemId,
    bool clearUpdatingItemId = false,
  }) {
    return CartLoaded(
      cartItems: cartItems ?? this.cartItems,
      totalAmount: totalAmount ?? this.totalAmount,
      updatingItemId:
          clearUpdatingItemId ? null : (updatingItemId ?? this.updatingItemId),
    );
  }
}

/// Hata metni UI'da kullanıcının diline göre seçilir; cubit yalnızca nedeni bilir.
enum CartFailureReason { stockLimit, connection, unknown }

/// Sepet hiç yüklenemedi — tam ekran hata ve "tekrar dene".
class CartError extends CartState {
  final CartFailureReason reason;

  const CartError({required this.reason});

  @override
  List<Object?> get props => [reason];
}

/// Bir sepet işlemi (ekle/sil/adet) başarısız oldu. Tek seferlik bildirim:
/// hemen ardından son yüklenen sepet yeniden yayınlanır, ürünler ekranda kalır.
class CartActionError extends CartState {
  final CartFailureReason reason;
  final int? maxStock;

  const CartActionError({required this.reason, this.maxStock});

  @override
  List<Object?> get props => [reason, maxStock];
}

class CartItemAdding extends CartState {}

class CartItemAdded extends CartState {}

class CartItemUpdating extends CartState {}

class CartItemUpdated extends CartState {}

class CartItemRemoving extends CartState {}

class CartItemRemoved extends CartState {}

class CartClearing extends CartState {}

class CartCleared extends CartState {}

class ShowRemoveDialog extends CartState {
  final CartItemModel cartItem;

  const ShowRemoveDialog({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}
