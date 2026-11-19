import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_kitap_chesmesi/core/service/fcm_message_text.dart';

const String _fcmChannelId = 'kitap_chesmesi_channel';

/// Sunucu yalnızca `data` (data-only) gönderdiğinde arka plan / kapalı uygulamada
/// sistem bildirimi çıkmaz; bu handler yerel bildirim gösterir.
///
/// `notification` + `data` gönderildiğinde işletim sistemi zaten tepsi bildirimini
/// gösterir; burada tekrar göstermiyoruz.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.notification != null) {
    return;
  }

  final title = fcmTitleFromData(message.data);
  final body = fcmBodyFromData(message.data);
  if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
    log(
      'FCM background: data-only message without title/body keys',
      name: 'FCM',
    );
    return;
  }

  final plugin = FlutterLocalNotificationsPlugin();
  await plugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
  );

  const channel = AndroidNotificationChannel(
    _fcmChannelId,
    'Kitap Çeşmesi Bildirimleri',
    description: 'Kitap Çeşmesi uygulama bildirimleri',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );
  await plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const androidDetails = AndroidNotificationDetails(
    _fcmChannelId,
    'Kitap Çeşmesi Bildirimleri',
    channelDescription: 'Kitap Çeşmesi uygulama bildirimleri',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );
  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  await plugin.show(
    message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch % 2147483647,
    title?.isNotEmpty == true ? title! : 'Kitap Çeşmesi',
    body ?? '',
    const NotificationDetails(android: androidDetails, iOS: iosDetails),
    // Tıklandığında `jsonDecode` edilecek — `toString()` geçerli JSON
    // üretmediği için derin bağlantı sessizce çalışmıyordu.
    payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
  );
}
