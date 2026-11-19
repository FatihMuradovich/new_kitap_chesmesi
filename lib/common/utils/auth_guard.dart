import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';

/// Kullanıcı login değilse login sayfasına yönlendirir.
/// Login ise true, değilse false döner.
Future<bool> ensureLoggedIn(BuildContext context) async {
  final dioClient = di<DioClient>();
  final token = await dioClient.getToken();
  final refreshToken =
      await dioClient.secureStorage.read(key: Keys.REFRESH_TOKEN);

  final isLoggedIn = token != null && refreshToken != null;

  if (isLoggedIn) {
    return true;
  }

  if (!context.mounted) return false;

  await di<AppRouter>().push(const LoginRoute());

  return false;
}

