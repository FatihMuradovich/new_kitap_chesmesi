import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/core/session/reload_language_dependent_data.dart';
import 'package:new_kitap_chesmesi/features/category/domain/repository/category_repository.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/category_cubit.dart';
import 'package:new_kitap_chesmesi/features/favorite/domain/repository/favorite_repository.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:new_kitap_chesmesi/features/home/domain/repository/home_repository.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/cart_repository.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/order_repository.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/my_orders/my_orders_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/coupon_repository.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/coupon/coupon_cubit.dart';

/// Hangi isteklerin atıldığını kaydeder; her istek hata verir (cubit'ler bunu
/// yakalar). Burada yalnızca "yeniden istendi mi" önemli.
class _Recorder {
  final List<String> calls = [];
}

class _Repo {
  _Repo(this.name, this.recorder);
  final String name;
  final _Recorder recorder;

  Never record(Invocation i) {
    recorder.calls.add(name);
    throw Exception('offline');
  }
}

class _HomeRepo extends _Repo implements HomeRepository {
  _HomeRepo(_Recorder r) : super('home', r);
  @override
  dynamic noSuchMethod(Invocation i) => record(i);
}

class _CategoryRepo extends _Repo implements CategoryRepository {
  _CategoryRepo(_Recorder r) : super('category', r);
  @override
  dynamic noSuchMethod(Invocation i) => record(i);
}

class _CartRepo extends _Repo implements CartRepository {
  _CartRepo(_Recorder r) : super('cart', r);
  @override
  dynamic noSuchMethod(Invocation i) => record(i);
}

class _FavoriteRepo extends _Repo implements FavoriteRepository {
  _FavoriteRepo(_Recorder r) : super('favorites', r);
  @override
  dynamic noSuchMethod(Invocation i) => record(i);
}

class _OrderRepo extends _Repo implements OrderRepository {
  _OrderRepo(_Recorder r) : super('orders', r);
  @override
  dynamic noSuchMethod(Invocation i) => record(i);
}

class _CouponRepo extends _Repo implements CouponRepository {
  _CouponRepo(_Recorder r) : super('coupons', r);
  @override
  dynamic noSuchMethod(Invocation i) => record(i);
}

class _Cubits {
  _Cubits(_Recorder r)
      : home = HomeCubit(homeRepository: _HomeRepo(r)),
        category = CategoryCubit(categoryRepository: _CategoryRepo(r)),
        cart = CartCubit(cartRepository: _CartRepo(r)),
        favorites = FavoriteCubit(favoriteRepository: _FavoriteRepo(r)),
        orders = MyOrdersCubit(orderRepository: _OrderRepo(r)),
        coupons = CouponCubit(couponRepository: _CouponRepo(r));

  final HomeCubit home;
  final CategoryCubit category;
  final CartCubit cart;
  final FavoriteCubit favorites;
  final MyOrdersCubit orders;
  final CouponCubit coupons;
}

Future<BuildContext> _pump(WidgetTester tester, _Cubits c) async {
  late BuildContext captured;
  await tester.pumpWidget(MultiBlocProvider(
    providers: [
      BlocProvider.value(value: c.home),
      BlocProvider.value(value: c.category),
      BlocProvider.value(value: c.cart),
      BlocProvider.value(value: c.favorites),
      BlocProvider.value(value: c.orders),
      BlocProvider.value(value: c.coupons),
    ],
    child: Builder(builder: (context) {
      captured = context;
      return const SizedBox();
    }),
  ));
  return captured;
}

void main() {
  testWidgets(
      'Dil değişince daha önce yüklenmiş sepet, favoriler, siparişler ve '
      'kuponlar da yeni dilde yeniden istenir', (tester) async {
    final r = _Recorder();
    final c = _Cubits(r);
    final context = await _pump(tester, c);

    // Girişli kullanıcı: bu bölümler daha önce bir kez yüklendi.
    await tester.runAsync(() async {
      await c.cart.getCartItems();
      await c.favorites.getFavoriteBooks();
      await c.orders.refresh();
      await c.coupons.loadUserCoupons();
    });
    r.calls.clear();

    reloadLanguageDependentData(context);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));

    expect(r.calls.toSet(),
        containsAll({'home', 'category', 'cart', 'favorites', 'orders', 'coupons'}));
  });

  testWidgets(
      'Hiç yüklenmemiş kullanıcı verisi (misafir) için istek atılmaz',
      (tester) async {
    final r = _Recorder();
    final c = _Cubits(r);
    final context = await _pump(tester, c);

    reloadLanguageDependentData(context);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));

    expect(r.calls.toSet(), {'home', 'category'});
  });
}
