import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/core/service/fcm_message_text.dart';
import 'package:new_kitap_chesmesi/main.dart' show navigatorKey;

class FirebaseNotificatioService {
  FirebaseMessaging get messaging => FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeLocalNotifications() async {
    // Android notification channel oluştur
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'kitap_chesmesi_channel', // id
      'Kitap Çeşmesi Bildirimleri', // name
      description: 'Kitap Çeşmesi uygulama bildirimleri',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    // Channel'ı Android'e kaydet
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        // Bildirme tıklandığında yapılacak işlemler
        log('Notification clicked: ${details.payload}', name: 'Notification');
        final payload = details.payload;
        if (payload == null || payload.isEmpty) return;
        try {
          final decoded = jsonDecode(payload);
          if (decoded is Map<String, dynamic>) {
            handleNotificationPayload(decoded);
          }
        } catch (e) {
          log('Invalid notification payload: $e', name: 'Notification');
        }
      },
    );
    
    log('Local notifications initialized with channel', name: 'Notification Setup');
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    // Büyük resim için style
    BigPictureStyleInformation? bigPictureStyle;
    
    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        // Network resmini indirip göster
        final response = await http.get(Uri.parse(imageUrl));
        
        if (response.statusCode == 200) {
          // Resmi byte array olarak al
          final bytes = response.bodyBytes;
          
          bigPictureStyle = BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(
              base64Encode(bytes),
            ),
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            contentTitle: title,
            summaryText: body,
            htmlFormatContentTitle: true,
            htmlFormatSummaryText: true,
          );
        }
      } catch (e) {
        log('Error loading notification image: $e', name: 'Notification');
      }
    }

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'kitap_chesmesi_channel',
      'Kitap Çeşmesi Bildirimleri',
      channelDescription: 'Kitap Çeşmesi uygulama bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFFF9800), // Turuncu renk
      playSound: true,
      enableVibration: true,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: bigPictureStyle ?? 
        BigTextStyleInformation(
          body,
          htmlFormatBigText: true,
          contentTitle: title,
          htmlFormatContentTitle: true,
          summaryText: 'Kitap Çeşmesi',
          htmlFormatSummaryText: true,
        ),
      ticker: title,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<String?> getToken() async {
    try {
      // For iOS, wait for APNS token
      if (Platform.isIOS) {
        // Request permission first
        await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        // Wait for APNS token first, then request FCM token.
        String? apnsToken;
        int apnsRetryCount = 0;
        const maxApnsRetries = 10;

        while (apnsToken == null && apnsRetryCount < maxApnsRetries) {
          apnsToken = await messaging.getAPNSToken();
          if (apnsToken == null) {
            apnsRetryCount++;
            if (apnsRetryCount < maxApnsRetries) {
              log(
                'APNS token not ready yet... Retry $apnsRetryCount/$maxApnsRetries',
                name: 'FCM Token',
              );
              await Future.delayed(const Duration(seconds: 2));
            } else {
              log(
                'APNS token not available after $maxApnsRetries attempts',
                name: 'FCM Token Error',
              );
              return null;
            }
          }
        }

        String? token;
        int retryCount = 0;
        const maxRetries = 5;
        
        while (token == null && retryCount < maxRetries) {
          try {
            token = await messaging.getToken();
            if (token == null) {
              retryCount++;
              if (retryCount < maxRetries) {
                log('Waiting for FCM token... Retry $retryCount/$maxRetries', 
                    name: 'FCM Token');
                await Future.delayed(const Duration(seconds: 2));
              }
            }
          } catch (e) {
            retryCount++;
            if (retryCount < maxRetries) {
              log('Error getting token, retrying... ($retryCount/$maxRetries): $e', 
                  name: 'FCM Token');
              await Future.delayed(const Duration(seconds: 2));
            } else {
              log('Failed to get FCM token after $maxRetries attempts: $e', 
                  name: 'FCM Token Error');
              return null;
            }
          }
        }

        if (token != null) {
          log('FCM Token retrieved (iOS): $token', name: 'FCM Token');
        } else {
          log('Could not retrieve FCM token after $maxRetries attempts', 
              name: 'FCM Token Error');
        }
        return token;
      } else {
        // For Android
        final token = await messaging.getToken();
        if (token != null) {
          log('FCM Token retrieved (Android): $token', name: 'FCM Token');
        }
        return token;
      }
    } catch (e) {
      log('Error getting FCM token: $e', name: 'FCM Token Error');
      return null;
    }
  }

  Future<void> connectNotification() async {
    await Firebase.initializeApp();
    
    // Initialize local notifications
    await initializeLocalNotifications();

    // Request notification permissions
    await settingNotification();

    // Set foreground notification options
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );
    
    // Listen for foreground messages (uygulama açıkken gelen bildirimler)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('📱 Foreground message received', name: 'FCM Notification');
      log('Title: ${message.notification?.title}', name: 'FCM Notification');
      log('Body: ${message.notification?.body}', name: 'FCM Notification');
      log('Data: ${message.data}', name: 'FCM Notification');

      final title = message.notification?.title ??
          fcmTitleFromData(message.data) ??
          'Kitap Çeşmesi';
      final body = message.notification?.body ?? fcmBodyFromData(message.data) ?? '';

      if (message.notification != null ||
          fcmTitleFromData(message.data) != null ||
          fcmBodyFromData(message.data) != null) {
        final imageUrl = _extractImageUrl(message);
        log('Image URL: $imageUrl', name: 'FCM Notification');

        await showNotification(
          title: title,
          body: body,
          // Map.toString() ayrıştırılamaz — tıklamada geri çözebilmek için JSON.
          payload: jsonEncode(message.data),
          imageUrl: imageUrl,
        );
        log('✅ Local notification displayed', name: 'FCM Notification');
      } else {
        log('⚠️ No notification or displayable data fields', name: 'FCM Notification');
      }
    });

    // Listen for background messages when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a terminated state notification
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // Get and log FCM token
    final token = await getToken();
    log('FCM Token: $token', name: 'FCM Token');
  }

  // Extract image URL from notification message
  String? _extractImageUrl(RemoteMessage message) {
    // Android için notification içinden
    if (message.notification?.android?.imageUrl != null) {
      return message.notification!.android!.imageUrl;
    }
    // iOS için notification içinden
    if (message.notification?.apple?.imageUrl != null) {
      return message.notification!.apple!.imageUrl;
    }
    // Data içinden kontrol et
    if (message.data.containsKey('image')) {
      return message.data['image'];
    }
    if (message.data.containsKey('imageUrl')) {
      return message.data['imageUrl'];
    }
    return null;
  }

  // Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    log('🔔 Notification tapped', name: 'FCM Notification');
    log('Title: ${message.notification?.title}', name: 'FCM Notification');
    log('Data: ${message.data}', name: 'FCM Notification');
    handleNotificationPayload(message.data);
  }

  /// Bildirim payload'ına göre derin bağlantı (ORDER-API.md §6):
  ///
  /// | `type`                 | ek alanlar              | hedef          |
  /// |------------------------|-------------------------|----------------|
  /// | `order_status`         | `orderId`, `status`     | sipariş detayı |
  void handleNotificationPayload(Map<String, dynamic> data) {
    final link = _deepLinkFrom(data);
    if (link == null) return;

    // Soğuk açılışta router henüz mount olmamış olabilir — o durumda beklet,
    // SplashPage init'ini bitirince `consumePendingDeepLink()` ile tüketilir.
    if (navigatorKey.currentState == null) {
      log('Router not ready, deferring deep link: ${link.type}/${link.id}',
          name: 'FCM Notification');
      _pendingDeepLink = link;
      return;
    }

    _openDeepLink(link);
  }

  _PendingDeepLink? _deepLinkFrom(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    switch (type) {
      case 'order_status':
        final orderId = int.tryParse(data['orderId']?.toString() ?? '');
        return orderId == null
            ? null
            : _PendingDeepLink(_DeepLinkTarget.order, orderId);
      default:
        return null;
    }
  }

  /// Router hazır olmadan gelen derin bağlantı burada bekler.
  _PendingDeepLink? _pendingDeepLink;

  /// Bekleyen derin bağlantı varsa açar. Router mount olduktan sonra çağrılmalı.
  void consumePendingDeepLink() {
    final link = _pendingDeepLink;
    if (link == null) return;
    _pendingDeepLink = null;
    _openDeepLink(link);
  }

  void _openDeepLink(_PendingDeepLink link) {
    try {
      // `di` çözümü tıklama anına ertelenir — servis kurulurken router henüz yok.
      final router = di<AppRouter>();
      switch (link.type) {
        case _DeepLinkTarget.order:
          router.push(OrderDetailRoute(orderId: link.id));
      }
    } catch (e) {
      log('Failed to open deep link: $e', name: 'FCM Notification Error');
    }
  }


  Future<void> settingNotification() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('Notification permission status: ${settings.authorizationStatus}', 
        name: 'FCM Permission');
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('✅ User granted notification permission', name: 'FCM Permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('⚠️ User granted provisional notification permission', name: 'FCM Permission');
    } else {
      log('❌ User declined notification permission', name: 'FCM Permission');
    }
  }
}

enum _DeepLinkTarget { order }

/// Router mount olmadan gelen bildirim tıklaması burada bekletilir.
class _PendingDeepLink {
  final _DeepLinkTarget type;
  final int id;

  const _PendingDeepLink(this.type, this.id);
}
