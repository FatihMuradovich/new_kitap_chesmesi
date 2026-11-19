import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class CartResponseModel {
  final bool success;
  final List<CartItemModel> data;

  CartResponseModel({
    required this.success,
    required this.data,
  });

  factory CartResponseModel.fromMap(Map<String, dynamic> map) {
    return CartResponseModel(
      success: map['success'] as bool,
      data: List<CartItemModel>.from(
        (map['data'] as List).map<CartItemModel>(
          (x) => CartItemModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class CartItemModel {
  final int id;
  final String name;
  final String? desc;
  final String? productCode;
  final String price;
  final String? discountType;
  final int? publishYear;
  final int? pageCount;
  final String? discount;
  final String status;
  final int stock;
  final String? cover;
  final int quantity;
  final int cartItemId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Author? author;
  final List<ImageModel> images;

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.status,
    required this.stock,
    required this.quantity,
    required this.cartItemId,
    required this.images,
    this.desc,
    this.productCode,
    this.discountType,
    this.publishYear,
    this.pageCount,
    this.discount,
    this.cover,
    this.createdAt,
    this.updatedAt,
    this.author,
  });

  double get priceValue => double.tryParse(price) ?? 0;

  double get discountValue => double.tryParse(discount ?? '') ?? 0;

  double get discountedPrice {
    if (discountType?.toLowerCase() == 'percent') {
      return priceValue - (priceValue * discountValue / 100);
    } else if (discountType?.toLowerCase() == 'amount') {
      return priceValue - discountValue;
    }
    return priceValue;
  }

  double get totalPrice => discountedPrice * quantity;

  /// Katalog indirimi varsa (yüzde veya tutar) bu satırda kupon kullanılamaz.
  bool get hasCatalogDiscount {
    final type = discountType?.toLowerCase();
    if (type != 'percent' && type != 'amount') return false;
    return discountValue > 0;
  }

  CartItemModel copyWith({
    int? id,
    String? name,
    String? desc,
    String? productCode,
    String? price,
    String? discountType,
    int? publishYear,
    int? pageCount,
    String? discount,
    String? status,
    int? stock,
    String? cover,
    int? quantity,
    int? cartItemId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Author? author,
    List<ImageModel>? images,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      productCode: productCode ?? this.productCode,
      price: price ?? this.price,
      discountType: discountType ?? this.discountType,
      publishYear: publishYear ?? this.publishYear,
      pageCount: pageCount ?? this.pageCount,
      discount: discount ?? this.discount,
      status: status ?? this.status,
      stock: stock ?? this.stock,
      cover: cover ?? this.cover,
      quantity: quantity ?? this.quantity,
      cartItemId: cartItemId ?? this.cartItemId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
      images: images ?? this.images,
    );
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      desc: map['desc'] as String?,
      productCode: map['productCode'] as String?,
      price: map['price'] as String,
      discountType: map['discountType'] as String?,
      publishYear: map['publishYear'] as int?,
      pageCount: map['pageCount'] as int?,
      discount: map['discount'] as String?,
      status: map['status'] as String,
      stock: map['stock'] as int,
      cover: map['cover'] as String?,
      quantity: map['quantity'] as int,
      cartItemId: map['cartItemId'] as int,
      createdAt: (map['createdAt'] as String?) != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: (map['updatedAt'] as String?) != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      author: map['author'] != null
          ? Author.fromJson(map['author'] as Map<String, dynamic>)
          : null,
      images: List<ImageModel>.from(
        (map['images'] as List).map<ImageModel>(
          (x) => ImageModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'desc': desc,
      'productCode': productCode,
      'price': price,
      'discountType': discountType,
      'publishYear': publishYear,
      'pageCount': pageCount,
      'discount': discount,
      'status': status,
      'stock': stock,
      'cover': cover,
      'quantity': quantity,
      'cartItemId': cartItemId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'author': author?.toMap(),
      'images': images.map((x) => x.toMap()).toList(),
    };
  }
}

// Author sınıfı için toMap metodu eklenmesi gerekebilir
extension AuthorExtension on Author {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'desc': desc,
    };
  }
}

// ImageModel sınıfı için toMap metodu eklenmesi gerekebilir
extension ImageModelExtension on ImageModel {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'path': path,
    };
  }
}
