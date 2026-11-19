import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static final Connectivity _connectivity = Connectivity();

  /// İnternet bağlantısını kontrol eder
  /// Returns: true = internet var, false = internet yok
  static Future<bool> checkConnectivity() async {
    try {
      final List<ConnectivityResult> connectivityResult = 
          await _connectivity.checkConnectivity();
      
      // Bağlantı yoksa false döndür
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }
      
      // WiFi veya Mobile data varsa true döndür
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.ethernet)) {
        return true;
      }
      
      return false;
    } catch (e) {
      // Hata durumunda false döndür (güvenli taraf)
      return false;
    }
  }

  /// Bağlantı türünü string olarak döndürür
  static Future<String> getConnectionType() async {
    try {
      final List<ConnectivityResult> connectivityResult = 
          await _connectivity.checkConnectivity();
      
      if (connectivityResult.contains(ConnectivityResult.wifi)) {
        return 'WiFi';
      } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
        return 'Mobile Data';
      } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
        return 'Ethernet';
      } else {
        return 'No Connection';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
