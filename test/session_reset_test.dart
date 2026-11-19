import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/favorite/domain/repository/favorite_repository.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/cart_repository.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/coupon_repository.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/user_repository.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/coupon/coupon_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/coupon/coupon_state.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_state.dart';

/// Her çağrıda hata fırlatan sahte repository'ler — cubit'i hata durumuna sokar.
class _ThrowingUserRepository implements UserRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw Exception('offline');
}

class _ThrowingCartRepository implements CartRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw Exception('offline');
}

class _ThrowingCouponRepository implements CouponRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw Exception('offline');
}

class _FakeFavoriteRepository implements FavoriteRepository {
  @override
  Future<List<BookModel>> getFavoriteBooks() async => [
        BookModel(
          id: 42,
          name: 'Önceki kullanıcının favorisi',
          price: '10',
          status: 'Available',
          createdAt: null,
          stock: 1,
          images: const [],
        ),
      ];

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  group('Çıkışta kullanıcıya özel cubit\'ler sıfırlanır', () {
    test('FavoriteCubit.reset favori listesini de temizler', () async {
      final cubit =
          FavoriteCubit(favoriteRepository: _FakeFavoriteRepository());
      await cubit.getFavoriteBooks();
      expect(cubit.isBookFavorite(42), isTrue);

      cubit.reset();

      expect(cubit.state, isA<FavoriteInitial>());
      // Misafirin gördüğü kitap kartlarındaki kalp buradan okunur.
      expect(cubit.isBookFavorite(42), isFalse);
    });

    test('UserCubit.reset başlangıç durumuna döner', () async {
      final cubit = UserCubit(userRepository: _ThrowingUserRepository());
      await cubit.fetchUserProfile();
      expect(cubit.state, isA<UserError>());

      cubit.reset();

      expect(cubit.state, isA<UserInitial>());
    });

    test('CartCubit.reset başlangıç durumuna döner', () async {
      final cubit = CartCubit(cartRepository: _ThrowingCartRepository());
      await cubit.getCartItems();
      expect(cubit.state, isA<CartError>());

      cubit.reset();

      expect(cubit.state, isA<CartInitial>());
      expect(cubit.cartItemCount, 0);
    });

    test('CouponCubit.reset başlangıç durumuna döner', () async {
      final cubit = CouponCubit(couponRepository: _ThrowingCouponRepository());
      await cubit.loadUserCoupons();
      expect(cubit.state, isA<CouponError>());

      cubit.reset();

      expect(cubit.state, isA<CouponInitial>());
    });
  });
}
