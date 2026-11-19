import 'package:new_kitap_chesmesi/core/config/api_config.dart';

/// Statik dosya (uploads vb.) kökü — Dio `baseUrl` (`.../api/`) ile aynı hostta.
/// Adres [ApiConfig] üzerinden türetilir ki dev/prod tek yerden değişsin.
class BaseUrl {
  static String get baseUrl => ApiConfig.host;
}
