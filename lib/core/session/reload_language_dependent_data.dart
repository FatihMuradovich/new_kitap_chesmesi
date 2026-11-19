import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/category_cubit.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/my_orders/my_orders_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/my_orders/my_orders_state.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/coupon/coupon_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/coupon/coupon_state.dart';

/// Dil değişince sunucudan gelen, dile bağlı verileri (kitap, yazar,
/// kategori adları vb.) yeni dilde yeniden ister.
///
/// Uygulama geneli cubit'ler veriyi bellekte tutar; Sepet ve Favoriler gibi
/// sekmeler yalnızca ilk açılışta yükler. Yenilenmezlerse arayüz yeni dilde,
/// içerik eski dilde kalır. Kullanıcıya özel bölümler yalnızca daha önce
/// yüklendiyse (girişli kullanıcı) yenilenir; misafir için boşuna istek atılmaz.
/// Sayfaya özel ekranlar (kitap listesi, detay) her açılışta zaten yükler.
///
/// [context], `App`'teki `MultiBlocProvider`'ın altında olmalıdır.
void reloadLanguageDependentData(BuildContext context) {
  context.read<HomeCubit>().loadHomeData();
  context.read<CategoryCubit>().fetchCategories();

  final cart = context.read<CartCubit>();
  if (cart.state is! CartInitial) cart.getCartItems();

  final favorites = context.read<FavoriteCubit>();
  if (favorites.state is! FavoriteInitial) favorites.getFavoriteBooks();

  final orders = context.read<MyOrdersCubit>();
  if (orders.state is! MyOrdersInitial) orders.refresh();

  final coupons = context.read<CouponCubit>();
  if (coupons.state is! CouponInitial) coupons.loadUserCoupons();
}
