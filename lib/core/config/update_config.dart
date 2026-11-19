class UpdateConfig {
  const UpdateConfig._();

  // Toggle this to true when a force update is required.
  static const bool forceUpdateEnabled = false;

  // Android applicationId published on Play Store.
  static const String playStoreId = 'com.fatih.kitapchesmesi';

  /// App Store numeric app ID (e.g. "1234567890") from App Store Connect.
  /// Leave empty to use the iOS bundle identifier for lookup (works if app is on the store).
  static const String appleId = '';

  /// iTunes Search API country code (e.g. "us", "tm"). Leave empty for API default.
  static const String appStoreCountry = '';
}
