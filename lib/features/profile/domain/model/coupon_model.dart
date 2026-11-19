class CouponModel {
  final int id;
  final int? userId;
  final String type;
  final String coupon;
  final bool active;
  final int percent;
  final DateTime createdAt;

  CouponModel({
    required this.id,
    this.userId,
    required this.type,
    required this.coupon,
    required this.active,
    required this.percent,
    required this.createdAt,
  });

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      id: map['id'] as int,
      userId: map['userId'] as int?,
      type: map['type'] as String,
      coupon: map['coupon'] as String,
      active: map['active'] as bool,
      percent: map['percent'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'coupon': coupon,
      'active': active,
      'percent': percent,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'CouponModel(id: $id, userId: $userId, type: $type, coupon: $coupon, active: $active, percent: $percent, createdAt: $createdAt)';
  }
}
