import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/delivery_method_model.dart';

/// Özel sipariş talebinin durumu (SPECIAL-ORDER-API.md §3).
///
/// ```
/// Pending ─┬─▶ Quoted ─┬─▶ Approved / Rejected / Expired / Cancelled
///          ├─▶ Unavailable
///          └─▶ Cancelled
/// ```
/// API PascalCase döner: `Pending`, `Quoted`, `Unavailable` …
enum SpecialOrderStatus {
  pending,
  quoted,
  approved,
  rejected,
  expired,
  cancelled,
  unavailable,
  unknown;

  static SpecialOrderStatus fromApi(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'pending':
        return SpecialOrderStatus.pending;
      case 'quoted':
        return SpecialOrderStatus.quoted;
      case 'approved':
        return SpecialOrderStatus.approved;
      case 'rejected':
        return SpecialOrderStatus.rejected;
      case 'expired':
        return SpecialOrderStatus.expired;
      case 'cancelled':
      case 'canceled':
        return SpecialOrderStatus.cancelled;
      case 'unavailable':
        return SpecialOrderStatus.unavailable;
      default:
        return SpecialOrderStatus.unknown;
    }
  }

  /// `status` query parametresi için API'nin beklediği yazım.
  String get apiValue {
    switch (this) {
      case SpecialOrderStatus.pending:
        return 'Pending';
      case SpecialOrderStatus.quoted:
        return 'Quoted';
      case SpecialOrderStatus.approved:
        return 'Approved';
      case SpecialOrderStatus.rejected:
        return 'Rejected';
      case SpecialOrderStatus.expired:
        return 'Expired';
      case SpecialOrderStatus.cancelled:
        return 'Cancelled';
      case SpecialOrderStatus.unavailable:
        return 'Unavailable';
      case SpecialOrderStatus.unknown:
        return '';
    }
  }

  /// Son durum — buradan hiçbir yere geçmez (SPECIAL-ORDER-API.md §3).
  bool get isFinal =>
      this == SpecialOrderStatus.approved ||
      this == SpecialOrderStatus.rejected ||
      this == SpecialOrderStatus.expired ||
      this == SpecialOrderStatus.cancelled ||
      this == SpecialOrderStatus.unavailable;

  /// Teklif onaylanabilir/reddedilebilir mi — yalnızca `Quoted`.
  /// Süre kontrolü ayrı: [SpecialOrderRequestData.isActionable].
  bool get canRespondToQuote => this == SpecialOrderStatus.quoted;

  /// Talep iptal edilebilir mi — `Pending` veya `Quoted`.
  bool get canCancel =>
      this == SpecialOrderStatus.pending || this == SpecialOrderStatus.quoted;
}

/// Bir kalemin belirli bir usul için birim fiyatı. `Decimal` olduğu için string.
class ItemPrice {
  final int methodId;
  final String unitPrice;

  const ItemPrice({required this.methodId, required this.unitPrice});

  double get value => double.tryParse(unitPrice) ?? 0;

  factory ItemPrice.fromMap(Map<String, dynamic> map) {
    return ItemPrice(
      methodId: (map['methodId'] as num?)?.toInt() ?? 0,
      unitPrice: (map['unitPrice'] ?? '0').toString(),
    );
  }
}

/// Bir usulün, **uygun kalemlerin tamamı seçilirse** oluşacak ürün toplamı
/// (teslimat ücreti hariç — SPECIAL-ORDER-API.md §4).
class MethodTotal {
  final int methodId;
  final String total;

  const MethodTotal({required this.methodId, required this.total});

  double get value => double.tryParse(total) ?? 0;

  factory MethodTotal.fromMap(Map<String, dynamic> map) {
    return MethodTotal(
      methodId: (map['methodId'] as num?)?.toInt() ?? 0,
      total: (map['total'] ?? '0').toString(),
    );
  }
}

/// Talepteki tek bir kitap satırı.
class SpecialOrderItemData {
  final int id;
  final int bookId;
  final int quantity;

  /// `false` ise kalem **seçilemez** — üstü çizili gösterilir, sebebi
  /// talebin `adminNote` alanında açıklanır (SPECIAL-ORDER-API.md §4).
  final bool available;

  /// Admin tarafında işaretlenmiş seçim; UI'ın başlangıç seçimi değil.
  final bool selected;
  final List<ItemPrice> prices;
  final BookModel? book;

  const SpecialOrderItemData({
    required this.id,
    required this.bookId,
    required this.quantity,
    required this.available,
    required this.selected,
    required this.prices,
    this.book,
  });

  ItemPrice? priceFor(int methodId) {
    for (final price in prices) {
      if (price.methodId == methodId) return price;
    }
    return null;
  }

  /// Bu kalem seçilen usulle getirtilebiliyor mu.
  /// `prices` boşsa o usulle getirilemiyor demektir.
  bool isSelectableFor(int methodId) =>
      available && priceFor(methodId) != null;

  /// Seçilen usul için satır toplamı: birim fiyat × adet.
  double lineTotalFor(int methodId) => (priceFor(methodId)?.value ?? 0) * quantity;

  factory SpecialOrderItemData.fromMap(Map<String, dynamic> map) {
    final rawPrices = map['prices'];
    return SpecialOrderItemData(
      id: (map['id'] as num?)?.toInt() ?? 0,
      bookId: (map['bookId'] as num?)?.toInt() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      available: map['available'] as bool? ?? true,
      selected: map['selected'] as bool? ?? false,
      prices: rawPrices is List
          ? rawPrices
              .whereType<Map<String, dynamic>>()
              .map(ItemPrice.fromMap)
              .toList()
          : const [],
      // Gömülü `book` eksik alanlar taşıyabilir — order feature'ın
      // normalize edici yardımcısını paylaşıyoruz.
      book: bookFromEmbeddedMap(map['book']),
    );
  }
}

/// Talep detayı — teklif ekranının beslendiği model (SPECIAL-ORDER-API.md §4).
class SpecialOrderRequestData {
  final int id;
  final SpecialOrderStatus status;

  /// Müşterinin talep açarken yazdığı not.
  final String? note;

  /// Adminin notu — "C kitabını tedarikçi vermiyor." gibi.
  /// `available: false` kalemlerin sebebi burada açıklanır.
  final String? adminNote;
  final String? quotedAt;
  final String? quoteExpiresAt;

  /// Onaylandıysa oluşan siparişin id'si.
  final int? orderId;
  final DeliveryMethodModel? selectedMethod;
  final List<DeliveryMethodModel> methods;
  final List<MethodTotal> totalsByMethod;
  final List<SpecialOrderItemData> items;
  final String createdAt;

  const SpecialOrderRequestData({
    required this.id,
    required this.status,
    this.note,
    this.adminNote,
    this.quotedAt,
    this.quoteExpiresAt,
    this.orderId,
    this.selectedMethod,
    this.methods = const [],
    this.totalsByMethod = const [],
    this.items = const [],
    this.createdAt = '',
  });

  DateTime? get quoteExpiresAtDate =>
      quoteExpiresAt == null ? null : DateTime.tryParse(quoteExpiresAt!);

  /// Teklif süresi doldu mu. Tarih yoksa "dolmadı" sayılır — sunucu zaten
  /// gece cron'uyla `Expired`'a çeviriyor, istemci sadece erken uyarıyor.
  bool get isQuoteExpired {
    final expiry = quoteExpiresAtDate;
    if (expiry == null) return false;
    return DateTime.now().isAfter(expiry);
  }

  /// Onayla / reddet butonları çizilebilir mi.
  bool get isActionable => status.canRespondToQuote && !isQuoteExpired;

  MethodTotal? totalFor(int methodId) {
    for (final total in totalsByMethod) {
      if (total.methodId == methodId) return total;
    }
    return null;
  }

  /// Seçilen usulle getirtilebilen kalemler.
  List<SpecialOrderItemData> selectableItemsFor(int methodId) =>
      items.where((item) => item.isSelectableFor(methodId)).toList();

  /// Aktif usuller, `sortOrder` sırasında.
  List<DeliveryMethodModel> get activeMethods =>
      methods.where((method) => method.active).toList();

  factory SpecialOrderRequestData.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'];
    final rawTotals = map['totalsByMethod'];
    return SpecialOrderRequestData(
      id: (map['id'] as num?)?.toInt() ?? 0,
      status: SpecialOrderStatus.fromApi(map['status'] as String?),
      note: map['note'] as String?,
      adminNote: map['adminNote'] as String?,
      quotedAt: map['quotedAt']?.toString(),
      quoteExpiresAt: map['quoteExpiresAt']?.toString(),
      orderId: (map['orderId'] as num?)?.toInt(),
      selectedMethod: map['selectedMethod'] is Map<String, dynamic>
          ? DeliveryMethodModel.fromMap(
              map['selectedMethod'] as Map<String, dynamic>)
          : null,
      methods: DeliveryMethodModel.listFrom(map['methods']),
      totalsByMethod: rawTotals is List
          ? rawTotals
              .whereType<Map<String, dynamic>>()
              .map(MethodTotal.fromMap)
              .toList()
          : const [],
      items: rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(SpecialOrderItemData.fromMap)
              .toList()
          : const [],
      createdAt: (map['createdAt'] ?? '').toString(),
    );
  }
}

/// `GET user/special-order` sayfası. Liste ucu kalem/fiyat detayı taşımaz,
/// bu yüzden parse savunmacı — eksik alanlar boş değere düşer.
class SpecialOrdersPage {
  final List<SpecialOrderRequestData> requests;
  final int count;

  const SpecialOrdersPage({required this.requests, required this.count});

  factory SpecialOrdersPage.fromMap(Map<String, dynamic> map) {
    final rawData = map['data'];
    final requests = rawData is List
        ? rawData
            .whereType<Map<String, dynamic>>()
            .map(SpecialOrderRequestData.fromMap)
            .toList()
        : <SpecialOrderRequestData>[];
    return SpecialOrdersPage(
      requests: requests,
      count: (map['count'] as num?)?.toInt() ?? requests.length,
    );
  }
}

// ─────────────────────────── İstek gövdeleri ───────────────────────────

/// `POST /special-order` gövdesindeki tek kalem. `quantity` verilmezse 1;
/// aynı kitap iki kez gönderilirse backend adetleri toplar.
class SpecialOrderItem {
  final int bookId;
  final int quantity;

  const SpecialOrderItem({required this.bookId, this.quantity = 1});

  Map<String, dynamic> toMap() => {
        'bookId': bookId,
        if (quantity != 1) 'quantity': quantity,
      };
}

/// `POST /special-order` — talep aç.
class CreateSpecialOrderRequest {
  final List<SpecialOrderItem> items;
  final String? note;

  const CreateSpecialOrderRequest({required this.items, this.note});

  Map<String, dynamic> toMap() {
    final trimmedNote = note?.trim();
    return {
      'items': items.map((item) => item.toMap()).toList(),
      if (trimmedNote != null && trimmedNote.isNotEmpty) 'note': trimmedNote,
    };
  }
}

/// `POST /special-order/:id/approve` — teklifi onayla, sipariş oluştur.
/// Kupon alanı yoktur: özel siparişte kâr marjı değişken (§4).
class ApproveSpecialOrderRequest {
  final int methodId;
  final List<int> itemIds;
  final int? etrapId;
  final String address;
  final String? desc;
  final int? giftCoverId;

  const ApproveSpecialOrderRequest({
    required this.methodId,
    required this.itemIds,
    required this.address,
    this.etrapId,
    this.desc,
    this.giftCoverId,
  });

  Map<String, dynamic> toMap() {
    final trimmedDesc = desc?.trim();
    return {
      'methodId': methodId,
      'itemIds': itemIds,
      'address': address.trim(),
      if (etrapId != null) 'etrapId': etrapId,
      if (trimmedDesc != null && trimmedDesc.isNotEmpty) 'desc': trimmedDesc,
      if (giftCoverId != null) 'giftCoverId': giftCoverId,
    };
  }
}
