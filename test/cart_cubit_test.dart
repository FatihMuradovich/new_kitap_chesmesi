import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/cart_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/cart_repository.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';

CartItemModel _item({int id = 1, int quantity = 2, int stock = 2}) =>
    CartItemModel(
      id: id,
      name: 'Kitap $id',
      price: '10',
      status: 'Available',
      stock: stock,
      quantity: quantity,
      cartItemId: 100 + id,
      images: const [],
    );

DioException _offline() => DioException(
      requestOptions: RequestOptions(path: 'cart'),
      type: DioExceptionType.connectionError,
    );

class _FakeCartRepository implements CartRepository {
  List<CartItemModel> items = [_item()];
  Object? actionError;
  Completer<void>? addGate;

  @override
  Future<CartResponseModel> getCartItems() async =>
      CartResponseModel(success: true, data: items);

  @override
  Future<void> addToCart(int bookId, int quantity) async {
    await addGate?.future;
    if (actionError != null) throw actionError!;
  }

  @override
  Future<void> updateCartQuantityByBookId(int bookId, int quantity) async {
    if (actionError != null) throw actionError!;
  }

  @override
  Future<void> removeFromCartByBookId(int bookId) async {
    if (actionError != null) throw actionError!;
  }

  @override
  Future<void> clearCart() async {
    if (actionError != null) throw actionError!;
  }
}

Future<(CartCubit, _FakeCartRepository, List<CartState>)> _loadedCubit() async {
  final repo = _FakeCartRepository();
  final cubit = CartCubit(cartRepository: repo);
  await cubit.getCartItems();
  final states = <CartState>[];
  cubit.stream.listen(states.add);
  return (cubit, repo, states);
}

void main() {
  test('Stok sınırı: dil bağımsız neden + sepet içeriği korunur', () async {
    final (cubit, _, states) = await _loadedCubit();

    await cubit.increaseQuantityWithStockCheck(_item(quantity: 2, stock: 2));
    await Future<void>.delayed(Duration.zero);

    final error = states.whereType<CartActionError>().single;
    expect(error.reason, CartFailureReason.stockLimit);
    expect(error.maxStock, 2);
    expect(cubit.state, isA<CartLoaded>());
    expect((cubit.state as CartLoaded).cartItems, hasLength(1));
  });

  test('Silme internet yüzünden başarısızsa ürünler ekrandan kaybolmaz',
      () async {
    final (cubit, repo, states) = await _loadedCubit();
    repo.actionError = _offline();

    await cubit.confirmRemoveFromCart(1);
    await Future<void>.delayed(Duration.zero);

    expect(states.whereType<CartActionError>().single.reason,
        CartFailureReason.connection);
    expect(cubit.state, isA<CartLoaded>());
    expect(cubit.cartItemCount, 2);
  });

  test('Ekleme sürerken sepetteki adet sıfırlanmaz', () async {
    final (cubit, repo, _) = await _loadedCubit();
    repo.addGate = Completer<void>();

    final adding = cubit.addToCart(2, 1);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isA<CartItemAdding>());
    expect(cubit.cartItemCount, 2);
    expect(cubit.quantityInCart(1), 2);

    repo.addGate!.complete();
    await adding;
  });

  test('Sepet yüklenemezse tam ekran hata (tekrar dene) gösterilir', () async {
    final cubit = CartCubit(cartRepository: _ThrowingOnLoad());

    await cubit.getCartItems();

    expect(cubit.state, isA<CartError>());
    expect((cubit.state as CartError).reason, CartFailureReason.connection);
  });
}

class _ThrowingOnLoad extends _FakeCartRepository {
  @override
  Future<CartResponseModel> getCartItems() => Future.error(_offline());
}
