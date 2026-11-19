/// FCM data-only payload'larında yaygın alan adları.
String? fcmTitleFromData(Map<String, dynamic> data) {
  for (final key in const [
    'title',
    'notification_title',
    'subject',
    'headline',
    'baslik',
  ]) {
    final v = data[key];
    if (v != null && v.toString().isNotEmpty) return v.toString();
  }
  return null;
}

String? fcmBodyFromData(Map<String, dynamic> data) {
  for (final key in const [
    'body',
    'message',
    'notification_body',
    'text',
    'content',
    'mesaj',
    'icerik',
  ]) {
    final v = data[key];
    if (v != null && v.toString().isNotEmpty) return v.toString();
  }
  return null;
}
