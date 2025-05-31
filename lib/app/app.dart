import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/category_cubit.dart';
import 'package:new_kitap_chesmesi/features/navBar/cubit/nav_bar_cubit.dart';
import 'package:new_kitap_chesmesi/features/splash/presentation/page/splash_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();

  static _AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }
}

class _AppState extends State<App> {
  Locale _locale = const Locale('tr');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavBarCubit()),
        BlocProvider(create: (_) => di<AuthCubit>()),
        BlocProvider(create: (_) => di<CategoryCubit>()..fetchCategories()),
      ],
      child: ScreenUtilInit(
        builder: (_, child) {
          return MaterialApp(
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null || !supportedLocales.contains(locale)) {
                return const Locale('tr');
              }
              return locale;
            },
            locale: _locale,
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              cardTheme: CardThemeData(color: Colors.white),
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
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

            home: child,
          );
        },
        designSize: const Size(360, 640),
        // designSize: Size(
        //   MediaQuery.sizeOf(context).width,
        //   MediaQuery.sizeOf(context).height,
        // ),
        minTextAdapt: true,
        splitScreenMode: true,
        child: SplashPage(),
      ),
    );
  }
}
