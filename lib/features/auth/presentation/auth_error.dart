import 'package:flutter/widgets.dart';
import 'package:new_kitap_chesmesi/common/utils/network_error.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

/// Giriş / kayıt / şifre sıfırlama formlarındaki hata nedeni.
///
/// Sunucunun mesajı kullanıcıya gösterilmez: doğrulama hataları her dilde
/// İngilizce ve liste olarak gelir, iş hatalarının dili de garanti değildir.
/// Bunun yerine neden belirlenir, metin kullanıcının dilinde seçilir.
enum AuthErrorReason {
  connection,
  invalidCredentials,
  phoneAlreadyRegistered,
  invalidCode,
  tooManyRequests,
  unknown,
}

/// [error]'u bir nedene çevirir. Sunucu isteği reddettiyse (4xx, ya da 2xx
/// ama `success: false`) [whenRejected] döner; çünkü form alanları istemcide
/// zaten doğrulanıyor ve her uç noktanın reddetme sebebi bellidir.
AuthErrorReason classifyAuthError(
  Object error, {
  AuthErrorReason whenRejected = AuthErrorReason.unknown,
}) {
  if (isConnectionError(error)) return AuthErrorReason.connection;
  final status = statusCodeOf(error);
  if (status == null) return AuthErrorReason.unknown;
  if (status == 429) return AuthErrorReason.tooManyRequests;
  if (status >= 200 && status < 500) return whenRejected;
  return AuthErrorReason.unknown;
}

/// Nedenin kullanıcının dilindeki metni.
String authErrorMessage(BuildContext context, AuthErrorReason reason) {
  final l10n = context.l10n;
  return switch (reason) {
    AuthErrorReason.connection => l10n.noInternetMessage,
    AuthErrorReason.invalidCredentials => l10n.invalidCredentials,
    AuthErrorReason.phoneAlreadyRegistered => l10n.phoneAlreadyRegistered,
    AuthErrorReason.invalidCode => l10n.invalidCodeEntered,
    AuthErrorReason.tooManyRequests => l10n.tooManyRequests,
    AuthErrorReason.unknown => l10n.errorMessage,
  };
}
