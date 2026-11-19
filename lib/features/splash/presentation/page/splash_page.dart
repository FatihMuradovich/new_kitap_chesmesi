import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/service/service.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // Açılışta ayrı bir "internet var mı" kontrolü yapılmaz: connectivity_plus
    // gerçek internete değil ağ arayüzüne bakar (VPN'i "yok" sayar, simülatörde
    // eski sonuç döner). İnternet yoksa ana sayfa kendi "tekrar dene" ekranını
    // gösterir; o ekran gerçekten sunucuya istek atar.
    Future.delayed(const Duration(seconds: 2), _checkTokenAndNavigate);
  }

  Future<void> _checkTokenAndNavigate() async {
    final dioClient = di<DioClient>();
    final token = await dioClient.getToken();

    // Oturum doğrulaması arka planda: ana sayfaya geçiş internet beklemesin.
    // Access token süresi dolmuşsa interceptor yeniler; sunucu oturumu
    // reddederse token'ları siler ve "oturum bitti" bildirir. İnternet yoksa
    // veya sunucu hata verirse oturum silinmez — kullanıcı sadece internetsiz
    // açtı diye çıkış yapmış olmasın.
    if (token != null && token.isNotEmpty) {
      unawaited(dioClient.dio.get('/user/me').then((_) {}, onError: (_) {}));
    }

    if (!mounted) return;
    _navigateToHome();
  }

  void _navigateToHome() {
    di<AppRouter>().replaceAll([const CustomNavBarRoute()]);
    // Uygulama bildirime tıklanarak kapalıdan açıldıysa, router hazır olmadığı
    // için bekletilen sipariş derin bağlantısı burada açılır.
    di<FirebaseNotificatioService>().consumePendingDeepLink();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset('assets/logo/logo 3.PNG', height: 80)],
          ),
        ),
      ),
    );
  }
}
