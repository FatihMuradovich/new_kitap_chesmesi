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
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_state.dart';

/// Bağlantı geri geldiğinde, yüklenemeyip hata durumunda kalmış uygulama
/// geneli bölümleri (sekmeler) yeniden yükler. Başarıyla yüklenmiş bölümlere
/// dokunmaz. Sayfaya özel ekranlar (kitap listesi, detay) zaten açık olan
/// sayfadır; kullanıcı onları kendi "tekrar dene" düğmesiyle yeniler.
///
/// [context], `App`'teki `MultiBlocProvider`'ın altında olmalıdır.
void retryFailedLoads(BuildContext context) {
  final home = context.read<HomeCubit>();
  if (home.state is HomeError) home.loadHomeData();

  final categories = context.read<CategoryCubit>();
  if (categories.state is CategoryError) categories.fetchCategories();

  final favorites = context.read<FavoriteCubit>();
  if (favorites.state is FavoriteError) favorites.getFavoriteBooks();

  final cart = context.read<CartCubit>();
  if (cart.state is CartError) cart.getCartItems();

  final user = context.read<UserCubit>();
  if (user.state is UserError) user.fetchUserProfile();

  final coupons = context.read<CouponCubit>();
  if (coupons.state is CouponError) coupons.loadUserCoupons();

  final orders = context.read<MyOrdersCubit>();
  if (orders.state is MyOrdersError) orders.refresh();
}
