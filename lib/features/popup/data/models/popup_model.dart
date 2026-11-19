import 'package:equatable/equatable.dart';

class PopupModel extends Equatable {
  final int id;
  final String path;
  final String title;
  final bool active;
  final String createdAt;
  final String updatedAt;

  const PopupModel({
    required this.id,
    required this.path,
    required this.title,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PopupModel.fromJson(Map<String, dynamic> json) {
    return PopupModel(
      id: _parseInt(json['id']),
      path: _parseString(
        json['path'] ?? json['image'] ?? json['imagePath'] ?? json['url'],
      ),
      title: _parseString(json['title'] ?? json['name']),
      active: _parseActiveField(json),
      createdAt: _parseString(json['createdAt'] ?? json['created_at']),
      updatedAt: _parseString(json['updatedAt'] ?? json['updated_at']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final s = value.toLowerCase().trim();
      return s == 'true' || s == '1' || s == 'yes';
    }
    return false;
  }

  /// Alan yoksa aktif kabul et (eski API sürümleri).
  static bool _parseActiveField(Map<String, dynamic> json) {
    if (json.containsKey('active')) return _parseBool(json['active']);
    if (json.containsKey('is_active')) return _parseBool(json['is_active']);
    if (json.containsKey('isActive')) return _parseBool(json['isActive']);
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'title': title,
      'active': active,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [id, path, title, active, createdAt, updatedAt];
}

