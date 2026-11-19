/// Sunucu adresleri tek yerden okunur — hem Dio `baseUrl` hem statik dosya kökü
/// buradan türer, böylece dev/prod arasında tek satır değiştirmek yeterli.
///
/// Yerelde çalışırken aşağıdaki [host] satırını uygun olanla değiştirin. Android
/// emülatörü ana makineye `10.0.2.2` üzerinden ulaşır; `localhost` orada cihazın
/// kendisini gösterir ve istekler bağlanamaz (ORDER-API.md §6).
class ApiConfig {
  ApiConfig._();

  /// Statik dosya (uploads vb.) kökü — görsel yolları bunun başına eklenir.
  // static const String host = 'http://10.0.2.2:3001';    // Android emülatör
  //  static const String host = 'http://localhost:3001';   // iOS simülatör
  // static const String host = 'http://admin.kitapcesmesi.com.tm';
  static const String host = 'https://kitapchesmesi.online';

  /// Dio `baseUrl` — dil öneki interceptor tarafından eklenir (`.../api/tm/...`).
  static const String apiBaseUrl = '$host/api/';
}
