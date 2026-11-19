import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/session/end_user_session.dart';
import 'package:new_kitap_chesmesi/core/session/retry_failed_loads.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/forgot/forgot_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register_code/register_code_cubit.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/category_cubit.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/cubit/subcategory_cubit.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/banner/banner_cubit.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/notification/notification_cubit.dart';
import 'package:new_kitap_chesmesi/features/navBar/cubit/nav_bar_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/gift/gift_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/my_orders/my_orders_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/order/order_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/welayat_etrap/cubit/welayatAndEtrap_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/contact/contact_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/coupon/coupon_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/page/page_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_cubit.dart';
import 'package:new_kitap_chesmesi/features/search/presentation/cubit/search_cubit.dart';
import 'package:new_kitap_chesmesi/core/service/language_service.dart';
import 'package:new_kitap_chesmesi/localization/l10n/app_localizations.dart';
import 'package:new_kitap_chesmesi/features/popup/presentation/cubit/popup_cubit.dart';

// Global keys for navigation and scaffold messenger
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();

  // ignore: library_private_types_in_public_api
  static _AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }
}

class _AppState extends State<App> {
  // main() içinde kayıtlı dil yüklendi.
  Locale locale = di<LanguageService>().locale;

  void setLocale(Locale newLocal) {
    setState(() {
      locale = newLocal;
    });

    di<LanguageService>().setLocale(newLocal);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavBarCubit()),

        // Auth cubit
        BlocProvider(create: (_) => di<RegisterCubit>()),
        BlocProvider(create: (_) => di<ForgotCubit>()),
        BlocProvider(create: (_) => di<RegisterCodeCubit>()),
        BlocProvider(create: (_) => di<LoginCubit>()),

        // User & Profile
        BlocProvider(create: (_) => di<UserCubit>()),
        BlocProvider(create: (_) => di<ContactCubit>()),
        BlocProvider(create: (_) => di<CouponCubit>()),
        BlocProvider(create: (_) => di<OrderCubit>()),
        BlocProvider(create: (_) => di<MyOrdersCubit>()),
        BlocProvider(create: (_) => di<GiftCubit>()),
        BlocProvider(create: (_) => di<FavoriteCubit>()
            // ..getFavoriteBooks()
            ),

        // Category
        BlocProvider(create: (_) => di<CategoryCubit>()..fetchCategories()),
        BlocProvider(create: (_) => di<SubcategoryCubit>()),

        // BlocProvider(
        //     create: (_) => di<DiscountedBookCubit>()..fetchDiscountedBooks()),
        BlocProvider(create: (_) => di<BannerCubit>()..fetchBannerImages()),
        // Latest book
        // BlocProvider(
        //   create: (_) => di<LatestBookCubit>()..fetchRecentBooks(),
        // ),
        BlocProvider(
          create: (_) => di<SearchCubit>(),
        ),

        // Popup cubit
        BlocProvider(
          create: (_) => di<PopupCubit>(),
        ),

        // Cart cubit - Global olarak sağlanıyor
        BlocProvider(
          create: (_) => di<CartCubit>(),
        ),
        BlocProvider(
          create: (_) => di<HomeCubit>()..loadHomeData(),
        ),
        BlocProvider(
          create: (_) => di<PageCubit>(),
        ),
        BlocProvider(
          create: (_) => di<WelayatAndEtrapCubit>(),
        ),
        BlocProvider(
          create: (_) => di<NotificationCubit>(),
        ),
      ],
      child: _SessionStartListener(
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, __) {
            final appRouter = di<AppRouter>();
            return MaterialApp.router(
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                if (deviceLocale != null) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode ==
                        deviceLocale.languageCode) {
                      return supportedLocale;
                    }
                  }
                }
                return const Locale('tr'); // fallback
              },
              locale: locale,
              title: 'Kitap Çeşmesi',
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: scaffoldMessengerKey,
              routerConfig: appRouter.config(),
              theme: ThemeData(
                cardTheme: CardThemeData(color: Colors.white),
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: AppBarTheme(
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins-regular',
                  ),
                  iconTheme: IconThemeData(color: Colors.black),
                  actionsIconTheme: IconThemeData(color: Colors.black),
                ),
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Oturum olaylarını uygulama genelinde dinler.
///
/// - Giriş / kayıt başarılı olunca kullanıcıya özel ana sayfa verisini yeniler.
///   `HomeCubit` uygulama boyunca yaşar ve ana sayfa yalnızca veri yoksa
///   yükler; bu olmadan misafirin (veya önceki kullanıcının) "önerilen
///   kitaplar" listesi yeni oturumda da görünmeye devam ederdi.
/// - Bağlantı geri gelince hata durumunda kalmış sekmeleri yeniden yükler.
/// - Sunucu oturumu reddederse (refresh token geçersiz) kullanıcıyı misafir
///   durumuna alır ve bilgilendirir; aksi halde ekranda eski kullanıcının
///   verileri kalır ama her işlem başarısız olurdu.
class _SessionStartListener extends StatefulWidget {
  const _SessionStartListener({required this.child});

  final Widget child;

  @override
  State<_SessionStartListener> createState() => _SessionStartListenerState();
}

class _SessionStartListenerState extends State<_SessionStartListener> {
  StreamSubscription<void>? _sessionExpiredSub;
  StreamSubscription<void>? _connectionRestoredSub;

  @override
  void initState() {
    super.initState();
    _sessionExpiredSub =
        di<DioClient>().onSessionExpired.listen((_) => _onSessionExpired());
    // Bir sayfada "tekrar dene" başarılı olunca diğer sekmeler de yenilensin.
    _connectionRestoredSub = di<DioClient>()
        .onConnectionRestored
        .listen((_) {
      if (mounted) retryFailedLoads(context);
    });
    _loadFavoritesIfLoggedIn();
  }

  @override
  void dispose() {
    _sessionExpiredSub?.cancel();
    _connectionRestoredSub?.cancel();
    super.dispose();
  }

  Future<void> _onSessionExpired() async {
    await endUserSession(context);

    final messengerContext = scaffoldMessengerKey.currentContext;
    if (messengerContext == null || !messengerContext.mounted) return;
    final l10n = AppLocalizations.of(messengerContext);
    if (l10n == null) return;
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(l10n.sessionExpired)),
    );
  }

  void _refreshUserScopedData(BuildContext context) {
    context.read<HomeCubit>().loadHomeData(silentRefresh: true);
    // Kitap kartlarındaki kalpler bu listeden okunur; Favoriler sekmesi
    // açılmayı beklerse kalpler boş görünür.
    context.read<FavoriteCubit>().getFavoriteBooks();
  }

  /// Uygulama girişli açıldıysa favorileri baştan yükler.
  Future<void> _loadFavoritesIfLoggedIn() async {
    final token = await di<DioClient>().getToken();
    if (!mounted || token == null || token.isEmpty) return;
    final favorites = context.read<FavoriteCubit>();
    if (favorites.state is FavoriteInitial) favorites.getFavoriteBooks();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (_, current) => current is LoginSuccess,
          listener: (context, _) => _refreshUserScopedData(context),
        ),
        BlocListener<RegisterCubit, RegisterState>(
          listenWhen: (_, current) => current is RegisterSuccess,
          listener: (context, _) => _refreshUserScopedData(context),
        ),
      ],
      child: widget.child,
    );
  }
}
