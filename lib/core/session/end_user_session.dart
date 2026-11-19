import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/service/service.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/order/order_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/coupon/coupon_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_cubit.dart';

/// Çıkışta ve hesap silmede oturumu tamamen kapatır.
///
/// Kullanıcıya özel veriler `App` seviyesindeki cubit'lerde tutulur ve
/// oturumdan uzun yaşar; bu yüzden token'ları silmek yetmez, cubit'ler de
/// sıfırlanmalıdır. Aksi halde sıradaki kullanıcı (veya misafir) öncekinin
/// sepetini, favorilerini ve profilini görür.
///
/// [context], `App`'teki `MultiBlocProvider`'ın altında olmalıdır.
Future<void> endUserSession(BuildContext context) async {
  // Backend'de token silme ucu yok. FCM token'ını geçersiz kılmak, sunucudaki
  // kaydın bu cihaza bildirim ulaştırmasını engeller; sonraki girişte yeni
  // token alınıp kaydedilir. Çevrimdışıyken çıkışı bekletmesin diye süreli.
  try {
    await di<FirebaseNotificatioService>()
        .messaging
        .deleteToken()
        .timeout(const Duration(seconds: 5));
  } catch (e) {
    log('FCM token silinemedi: $e', name: 'Session');
  }

  await di<DioClient>().clearAllStorage();

  if (!context.mounted) return;
  context.read<UserCubit>().reset();
  context.read<FavoriteCubit>().reset();
  context.read<CartCubit>().reset();
  context.read<CouponCubit>().reset();
  context.read<OrderCubit>().resetState();

  // Ana sayfadaki "önerilen kitaplar" kullanıcıya özel; misafir listesine dön.
  unawaited(context.read<HomeCubit>().loadHomeData(silentRefresh: true));
}
