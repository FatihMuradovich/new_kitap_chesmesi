import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';

/// ORDER-API.md'deki örnek yanıtların birebir kopyaları.
const _listResponse = '''
{
  "success": true,
  "count": 5,
  "data": [
    {
      "id": 5,
      "status": "Cancelled",
      "total": "100",
      "address": "T",
      "desc": null,
      "etrapId": 1,
      "giftCoverId": null,
      "couponId": null,
      "createdAt": "2026-08-14T09:54:54.559Z",
      "updatedAt": "2026-08-14T09:54:54.649Z",
      "orderItems": [
        { "id": 5, "bookId": 1, "quantity": 1, "price": "100" }
      ],
      "statusHistory": []
    }
  ]
}
''';

const _detailOrderItem = '''
{
  "id": 2,
  "bookId": 1,
  "quantity": 1,
  "price": "100",
  "book": {
    "id": 1,
    "name": "Test Kitap",
    "price": "120",
    "images": [ { "path": "/uploads/books/a.jpg" } ],
    "author":   { "id": 1, "name": "Yazar" },
    "language": { "id": 1, "name": "Türkmen" }
  }
}
''';

const _statusHistoryEntry = '''
{
  "id": 11,
  "status": "Cancelled",
  "actorType": "User",
  "actorId": 1,
  "note": "fikrim değişti",
  "createdAt": "2026-08-14T09:54:54.652Z"
}
''';

void main() {
  group('OrdersPage.fromMap — liste ucu', () {
    test('userId ve orderItems[i].orderId olmadan parse eder', () {
      final page = OrdersPage.fromMap(
        jsonDecode(_listResponse) as Map<String, dynamic>,
      );

      expect(page.count, 5);
      expect(page.orders, hasLength(1));

      final order = page.orders.first;
      expect(order.id, 5);
      expect(order.userId, isNull);
      expect(order.status, OrderStatus.cancelled);
      expect(order.total, '100');
      expect(order.totalValue, 100);
      expect(order.etrapId, 1);
      expect(order.desc, isNull);
      expect(order.statusHistory, isEmpty);

      final item = order.orderItems.single;
      expect(item.id, 5);
      expect(item.orderId, isNull);
      expect(item.bookId, 1);
      expect(item.quantity, 1);
      expect(item.price, '100');
      expect(item.book, isNull);
    });

    test('count alanı yoksa liste uzunluğuna düşer', () {
      final page = OrdersPage.fromMap({'data': const []});
      expect(page.count, 0);
      expect(page.orders, isEmpty);
    });
  });

  group('OrderItemData.fromMap — detay ucu', () {
    test('gömülü kitabı, id taşımayan görselle birlikte parse eder', () {
      final item = OrderItemData.fromMap(
        jsonDecode(_detailOrderItem) as Map<String, dynamic>,
      );

      expect(item.book, isNotNull);
      expect(item.book!.name, 'Test Kitap');
      expect(item.book!.images.single.path, '/uploads/books/a.jpg');
      expect(item.book!.author!.name, 'Yazar');
      expect(item.book!.language!.name, 'Türkmen');

      // Sipariş anındaki dondurulmuş fiyat gösterilmeli, kitabın bugünkü değil.
      expect(item.price, '100');
      expect(item.book!.price, '120');
      expect(item.lineTotal, 100);
    });
  });

  group('OrderStatusHistory.fromMap', () {
    test('actorType ve note alanlarını okur', () {
      final entry = OrderStatusHistory.fromMap(
        jsonDecode(_statusHistoryEntry) as Map<String, dynamic>,
      );

      expect(entry.id, 11);
      expect(entry.status, OrderStatus.cancelled);
      expect(entry.actorType, 'User');
      expect(entry.actorId, 1);
      expect(entry.note, 'fikrim değişti');
    });
  });

  group('OrderStatus', () {
    test('API yazımını tanır', () {
      expect(OrderStatus.fromApi('Pending'), OrderStatus.pending);
      expect(OrderStatus.fromApi('Confirmed'), OrderStatus.confirmed);
      expect(OrderStatus.fromApi('Shipped'), OrderStatus.shipped);
      expect(OrderStatus.fromApi('Delivered'), OrderStatus.delivered);
      expect(OrderStatus.fromApi('Cancelled'), OrderStatus.cancelled);
      expect(OrderStatus.fromApi(null), OrderStatus.unknown);
      expect(OrderStatus.fromApi('Nonsense'), OrderStatus.unknown);
    });

    test('yalnızca Pending ve Confirmed iptal edilebilir', () {
      expect(OrderStatus.pending.isCancellable, isTrue);
      expect(OrderStatus.confirmed.isCancellable, isTrue);
      expect(OrderStatus.shipped.isCancellable, isFalse);
      expect(OrderStatus.delivered.isCancellable, isFalse);
      expect(OrderStatus.cancelled.isCancellable, isFalse);
    });

    test('Delivered ve Cancelled son durumdur', () {
      expect(OrderStatus.delivered.isFinal, isTrue);
      expect(OrderStatus.cancelled.isFinal, isTrue);
      expect(OrderStatus.pending.isFinal, isFalse);
      expect(OrderStatus.confirmed.isFinal, isFalse);
      expect(OrderStatus.shipped.isFinal, isFalse);
    });

    test('adım sırası Pending → Confirmed → Shipped → Delivered', () {
      expect(OrderStatus.pending.stepIndex, 0);
      expect(OrderStatus.confirmed.stepIndex, 1);
      expect(OrderStatus.shipped.stepIndex, 2);
      expect(OrderStatus.delivered.stepIndex, 3);
    });
  });
}
