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
      updatingItemId: clearUpdatingItemId ? null : (updatingItemId ?? this.updatingItemId),
    );
  }
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
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