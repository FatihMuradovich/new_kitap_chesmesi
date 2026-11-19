/// Getirtme usulü — uçak / tır (SPECIAL-ORDER-API.md §4 `GET /delivery-method`).
///
/// `name` seçilen dile göre gelir; listeler `sortOrder` sırasıyla gösterilir.
class DeliveryMethodModel {
  final int id;
  final String name;
  final int minDays;
  final int maxDays;
  final bool active;
  final int sortOrder;

  const DeliveryMethodModel({
    required this.id,
    required this.name,
    required this.minDays,
    required this.maxDays,
    this.active = true,
    this.sortOrder = 0,
  });

  /// "7–14" — ekranda gün aralığı için.
  String get dayRange => '$minDays–$maxDays';

  factory DeliveryMethodModel.fromMap(Map<String, dynamic> map) {
    return DeliveryMethodModel(
      id: (map['id'] as num).toInt(),
      name: (map['name'] ?? '').toString(),
      minDays: (map['minDays'] as num?)?.toInt() ?? 0,
      maxDays: (map['maxDays'] as num?)?.toInt() ?? 0,
      active: map['active'] as bool? ?? true,
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  /// `data` listesini parse edip `sortOrder`'a göre sıralar.
  static List<DeliveryMethodModel> listFrom(dynamic raw) {
    if (raw is! List) return const [];
    final methods = raw
        .whereType<Map<String, dynamic>>()
        .map(DeliveryMethodModel.fromMap)
        .toList();
    methods.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return methods;
  }
}
