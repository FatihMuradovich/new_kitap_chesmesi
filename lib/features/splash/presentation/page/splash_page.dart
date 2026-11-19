import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/service/service.dart';
import 'package:new_kitap_chesmesi/core/utils/connectivity_helper.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

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

    Future.delayed(const Duration(seconds: 2), () async {
      // Check internet connectivity first
      await _checkConnectivityAndProceed();
    });
  }

  Future<void> _checkConnectivityAndProceed() async {
    // Check internet connectivity
    final hasInternet = await ConnectivityHelper.checkConnectivity();

    if (!mounted) return;

    if (hasInternet) {
      await _checkTokenAndNavigate();
    } else {
      // Internet yok, dialog göster
      _showNoInternetDialog();
    }
  }

  Future<void> _checkTokenAndNavigate() async {
    final dioClient = di<DioClient>();
    final token = await dioClient.getToken();
    final refreshToken =
        await dioClient.secureStorage.read(key: Keys.REFRESH_TOKEN);

    if (!mounted) return;

    // App Store uyumlu guest-first akış:
    // Session yoksa bile kullanıcı home'a girebilmeli.
    if (token == null || token.isEmpty || refreshToken == null || refreshToken.isEmpty) {
      _navigateToHome();
      return;
    }

    try {
      // Session doğrulama: access token expired ise interceptor refresh deneyip
      // isteği otomatik tekrarlar. Başarılıysa kullanıcı girişte kalır.
      await dioClient.dio.get('/user/me');
      if (!mounted) return;
      _navigateToHome();
    } on DioException catch (_) {
      // Refresh başarısızsa session temizlenir ama kullanıcı guest olarak devam eder.
      await dioClient.clearTokens();
      if (!mounted) return;
      _navigateToHome();
    } catch (_) {
      await dioClient.clearTokens();
      if (!mounted) return;
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    di<AppRouter>().replaceAll([const CustomNavBarRoute()]);
    // Uygulama bildirime tıklanarak kapalıdan açıldıysa, router hazır olmadığı
    // için bekletilen sipariş derin bağlantısı burada açılır.
    di<FirebaseNotificatioService>().consumePendingDeepLink();
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog dışına tıklayınca kapanmasın
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.wifi_off,
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                context.l10n.noInternetTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ],
          ),
          content: Text(
            context.l10n.noInternetMessage,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-regular',
              color: Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
                _checkConnectivityAndProceed(); // Tekrar kontrol et
              },
              child: Text(
                context.l10n.tryAgain,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ),
          ],
        );
      },
    );
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
