/// Hediye paketi ücreti — **sabit iş kuralı**.
///
/// `GiftModel.price` alanı yanıtta gelse de kullanılmaz: hangi paket seçilirse
/// seçilsin ücret aynıdır. Normal sipariş (`order_page.dart`) ve özel sipariş
/// onayı bu tek sabiti paylaşır.
const double kGiftPaperFee = 15.0;

class GiftModel {
  final int id;
  final String name;
  final String price;
  final String image;
  final String createdAt;
  final String updatedAt;

  GiftModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  GiftModel copyWith({
    int? id,
    String? name,
    String? price,
    String? image,
    String? createdAt,
    String? updatedAt,
  }) {
    return GiftModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory GiftModel.fromMap(Map<String, dynamic> map) {
    return GiftModel(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as String,
      image: map['image'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }

  @override
  String toString() {
    return 'GiftModel(id: $id, name: $name, price: $price, image: $image, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant GiftModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.price == price &&
      other.image == image &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      image.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}

class GiftResponse {
  final bool success;
  final int count;
  final List<GiftModel> data;

  GiftResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GiftResponse.fromMap(Map<String, dynamic> map) {
    return GiftResponse(
      success: map['success'] as bool,
      count: map['count'] as int,
      data: List<GiftModel>.from(
        (map['data'] as List<dynamic>).map<GiftModel>(
          (x) => GiftModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
