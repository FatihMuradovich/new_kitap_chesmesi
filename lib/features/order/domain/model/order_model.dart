import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

/// Backend'in sipariş durumları (ORDER-API.md §2).
/// API PascalCase döner: `Pending`, `Confirmed`, `Shipped`, `Delivered`, `Cancelled`.
enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled,
  unknown;

  static OrderStatus fromApi(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'pending':
      case 'processing':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
      case 'completed':
        return OrderStatus.delivered;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.unknown;
    }
  }

  /// `status` query parametresi için API'nin beklediği yazım.
  String get apiValue {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.unknown:
        return '';
    }
  }

  /// Müşteri yalnızca `Pending` ve `Confirmed` durumlarında iptal edebilir.
  bool get isCancellable =>
      this == OrderStatus.pending || this == OrderStatus.confirmed;

  /// Son durum — hiçbir yere geçmez.
  bool get isFinal =>
      this == OrderStatus.delivered || this == OrderStatus.cancelled;

  /// Zaman çizelgesi adımı: Pending → Confirmed → Shipped → Delivered.
  int get stepIndex {
    switch (this) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.delivered:
        return 3;
      case OrderStatus.cancelled:
      case OrderStatus.unknown:
        return 0;
    }
  }
}

class OrderItem {
  final int bookId;
  final int quantity;

  OrderItem({
    required this.bookId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookId': bookId,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      bookId: map['bookId'] as int,
      quantity: map['quantity'] as int,
    );
  }
}

class OrderRequest {
  final String address;
  final int? giftCoverId;
  final String? coupon;
  final String? desc;
  final int? etrapId;
  final List<OrderItem> items;

  OrderRequest({
    required this.address,
    this.giftCoverId,
    this.coupon,
    this.desc,
    this.etrapId,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'address': address,
      'items': items.map((x) => x.toMap()).toList(),
    };

    if (giftCoverId != null) {
      map['giftCoverId'] = giftCoverId;
    }

    if (coupon != null && coupon!.isNotEmpty) {
      map['coupon'] = coupon;
    }

    if (desc != null && desc!.isNotEmpty) {
      map['desc'] = desc;
    }

    if (etrapId != null) {
      map['etrapId'] = etrapId;
    }

    return map;
  }
}

class OrderResponse {
  final bool success;
  final String message;
  final OrderData? data;

  OrderResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory OrderResponse.fromMap(Map<String, dynamic> map) {
    return OrderResponse(
      success: (map['success'] ?? false) as bool,
      message: (map['message'] ?? '') as String,
      data: map['data'] != null
          ? OrderData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// `GET user/order` yanıtı: siparişler + sayfalama için toplam kayıt sayısı.
class OrdersPage {
  final List<OrderData> orders;
  final int count;

  const OrdersPage({
    required this.orders,
    required this.count,
  });

  factory OrdersPage.fromMap(Map<String, dynamic> map) {
    final rawList = map['data'];
    final orders = rawList is List
        ? rawList
            .whereType<Map<String, dynamic>>()
            .map(OrderData.fromMap)
            .toList()
        : <OrderData>[];
    return OrdersPage(
      orders: orders,
      count: (map['count'] as num?)?.toInt() ?? orders.length,
    );
  }
}

class OrderData {
  final int id;

  /// Liste ucu (`GET user/order`) bu alanı taşımaz — nullable olmalı.
  final int? userId;
  final String total;
  final OrderStatus status;
  final String address;
  final String? desc;
  final String createdAt;
  final String updatedAt;
  final int? etrapId;
  final int? giftCoverId;
  final int? couponId;
  final List<OrderItemData> orderItems;
  final List<OrderStatusHistory> statusHistory;
  final UserData? user;
  final GiftData? gift;

  OrderData({
    required this.id,
    this.userId,
    required this.total,
    required this.status,
    required this.address,
    this.desc,
    required this.createdAt,
    required this.updatedAt,
    this.etrapId,
    this.giftCoverId,
    this.couponId,
    required this.orderItems,
    this.statusHistory = const [],
    this.user,
    this.gift,
  });

  /// İptal butonunun tek kaynağı.
  bool get canCancel => status.isCancellable;

  /// `total` Prisma `Decimal` olduğu için JSON'da string gelir (ORDER-API.md §5.5).
  double get totalValue => double.tryParse(total) ?? 0;

  factory OrderData.fromMap(Map<String, dynamic> map) {
    final rawItems = map['orderItems'];
    final rawHistory = map['statusHistory'];
    return OrderData(
      id: map['id'] as int,
      userId: (map['userId'] as num?)?.toInt(),
      total: (map['total'] ?? '0').toString(),
      status: OrderStatus.fromApi(map['status'] as String?),
      address: (map['address'] ?? '').toString(),
      desc: map['desc'] as String?,
      createdAt: (map['createdAt'] ?? '').toString(),
      updatedAt: (map['updatedAt'] ?? '').toString(),
      etrapId: (map['etrapId'] as num?)?.toInt(),
      giftCoverId: (map['giftCoverId'] as num?)?.toInt(),
      couponId: (map['couponId'] as num?)?.toInt(),
      orderItems: rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(OrderItemData.fromMap)
              .toList()
          : const [],
      statusHistory: rawHistory is List
          ? rawHistory
              .whereType<Map<String, dynamic>>()
              .map(OrderStatusHistory.fromMap)
              .toList()
          : const [],
      user: map['user'] != null
          ? UserData.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      gift: map['gift'] != null
          ? GiftData.fromMap(map['gift'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OrderItemData {
  final int id;

  /// Liste ucunda gelmez — nullable.
  final int? orderId;
  final int bookId;
  final int quantity;

  /// Siparişin verildiği andaki dondurulmuş fiyat. UI'da bu gösterilir,
  /// `book.price` (kitabın bugünkü fiyatı) ASLA gösterilmez — ORDER-API.md §5.1.
  final String price;
  final String? createdAt;
  final String? updatedAt;

  /// Yalnızca detay ucunda (`GET user/order/:id`) dolu gelir.
  final BookModel? book;

  OrderItemData({
    required this.id,
    this.orderId,
    required this.bookId,
    required this.quantity,
    required this.price,
    this.createdAt,
    this.updatedAt,
    this.book,
  });

  double get priceValue => double.tryParse(price) ?? 0;

  /// Bu kalemin toplamı: dondurulmuş birim fiyat × adet.
  double get lineTotal => priceValue * quantity;

  factory OrderItemData.fromMap(Map<String, dynamic> map) {
    return OrderItemData(
      id: map['id'] as int,
      orderId: (map['orderId'] as num?)?.toInt(),
      bookId: (map['bookId'] as num?)?.toInt() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      price: (map['price'] ?? '0').toString(),
      createdAt: map['createdAt']?.toString(),
      updatedAt: map['updatedAt']?.toString(),
      book: bookFromEmbeddedMap(map['book']),
    );
  }
}

/// Sipariş veya özel sipariş talebi içindeki gömülü `book` nesnesi
/// `BookModel.fromMap`'in zorunlu saydığı bazı alanları (`status`, `stock`,
/// `images[i].id`) taşımayabilir. Paylaşılan modele dokunmadan, eksikleri
/// tamamlayıp güvenle parse ediyoruz.
BookModel? bookFromEmbeddedMap(dynamic raw) {
  if (raw is! Map<String, dynamic>) return null;
  final normalized = Map<String, dynamic>.from(raw);
  normalized['status'] ??= '';
  normalized['stock'] = (normalized['stock'] as num?)?.toInt() ?? 0;
  // `price` artık nullable — uydurma '0' koymuyoruz. Sipariş kaleminde zaten
  // dondurulmuş `OrderItemData.price` gösteriliyor, `book.price` değil.
  normalized['price'] = normalized['price']?.toString();
  normalized['name'] = (normalized['name'] ?? '').toString();

  final rawImages = normalized['images'];
  normalized['images'] = rawImages is List
      ? rawImages.whereType<Map<String, dynamic>>().map((image) {
          return <String, dynamic>{
            'id': (image['id'] as num?)?.toInt() ?? 0,
            'path': (image['path'] ?? '').toString(),
          };
        }).toList()
      : const <Map<String, dynamic>>[];

  try {
    return BookModel.fromMap(normalized);
  } catch (_) {
    return null;
  }
}

/// Sipariş durumu geçmişi — tarihe göre artan sırada gelir (ORDER-API.md §3).
class OrderStatusHistory {
  final int id;
  final OrderStatus status;

  /// `User` | `Admin` | `System`
  final String actorType;
  final int? actorId;

  /// İptal sebebi; genelde null.
  final String? note;
  final String createdAt;

  OrderStatusHistory({
    required this.id,
    required this.status,
    required this.actorType,
    this.actorId,
    this.note,
    required this.createdAt,
  });

  factory OrderStatusHistory.fromMap(Map<String, dynamic> map) {
    return OrderStatusHistory(
      id: (map['id'] as num?)?.toInt() ?? 0,
      status: OrderStatus.fromApi(map['status'] as String?),
      actorType: (map['actorType'] ?? '').toString(),
      actorId: (map['actorId'] as num?)?.toInt(),
      note: map['note'] as String?,
      createdAt: (map['createdAt'] ?? '').toString(),
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String surname;
  final String phoneNumber;
  final String birthday;
  final String referral;
  final String createdAt;
  final String updatedAt;

  UserData({
    required this.id,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.birthday,
    required this.referral,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] as int,
      name: (map['name'] ?? '').toString(),
      surname: (map['surname'] ?? '').toString(),
      phoneNumber: (map['phoneNumber'] ?? '').toString(),
      birthday: (map['birthday'] ?? '').toString(),
      referral: (map['referral'] ?? '').toString(),
      createdAt: (map['createdAt'] ?? '').toString(),
      updatedAt: (map['updatedAt'] ?? '').toString(),
    );
  }
}

class GiftData {
  final int id;
  final String name;
  final String price;
  final String image;
  final String createdAt;
  final String updatedAt;

  GiftData({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GiftData.fromMap(Map<String, dynamic> map) {
    return GiftData(
      id: map['id'] as int,
      name: (map['name'] ?? '').toString(),
      price: (map['price'] ?? '0').toString(),
      image: (map['image'] ?? '').toString(),
      createdAt: (map['createdAt'] ?? '').toString(),
      updatedAt: (map['updatedAt'] ?? '').toString(),
    );
  }
}
