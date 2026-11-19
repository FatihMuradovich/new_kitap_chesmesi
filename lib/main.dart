import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/core/service/fcm_background_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/app/app.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/core/service/service.dart';
import 'package:new_kitap_chesmesi/core/service/notification_token_data_source.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/service/language_service.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  await initLocatorService();
  await di<LanguageService>().load();

  if (kDebugMode) {
    Bloc.observer = TalkerBlocObserver(talker: di<Talker>());
  } else {
    // Release'te debugPrint logcat'e yazar; kullanıcı verisi sızmasın.
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  
  // FCM token setup
  _setupFCMToken();
  
  runApp(const App());
}

void _setupFCMToken() async {
  try {
    final firebaseService = di<FirebaseNotificatioService>();
    final notificationTokenDataSource = di<NotificationTokenDataSource>();
    final dioClient = di<DioClient>();
    
    // Firebase bildirim servisini başlat
    firebaseService.connectNotification();
    
    // Token'ı al ve backend'e gönder (kullanıcı giriş yapmışsa)
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        // Kullanıcının giriş yapıp yapmadığını kontrol et
        final hasToken = await dioClient.getToken();
        
        if (hasToken != null && hasToken.isNotEmpty) {
          final fcmToken = await firebaseService.getToken();
          if (fcmToken != null) {
            log('Sending FCM token to backend on app start: $fcmToken', 
                name: 'FCM Token Setup');
            await notificationTokenDataSource.registerToken(fcmToken);
          }
        } else {
          log('User not logged in, skipping FCM token registration', 
              name: 'FCM Token Setup');
        }
      } catch (e) {
        log('Error sending FCM token on app start: $e', 
            name: 'FCM Token Setup Error');
      }
    });
    
    // Token yenilenme listener'ı ekle
    firebaseService.messaging.onTokenRefresh.listen((newToken) async {
      log('FCM Token refreshed: $newToken', name: 'FCM Token Refresh');
      
      try {
        // Kullanıcının giriş yapıp yapmadığını kontrol et
        final hasToken = await dioClient.getToken();
        
        if (hasToken != null && hasToken.isNotEmpty) {
          await notificationTokenDataSource.registerToken(newToken);
          log('New FCM token sent to backend successfully', 
              name: 'FCM Token Refresh');
        }
      } catch (e) {
        log('Error sending refreshed FCM token: $e', 
            name: 'FCM Token Refresh Error');
      }
    });
  } catch (e) {
    log('Error in FCM token setup: $e', name: 'FCM Token Setup Error');
  }
}

// class Get {
//   static BuildContext? get context => navigatorKey.currentContext;
// }
