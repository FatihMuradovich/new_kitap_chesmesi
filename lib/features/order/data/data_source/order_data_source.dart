import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order.dart';

class OrderDataSource {
  final DioClient dioSetting;
  OrderDataSource({required this.dioSetting});

  Future<bool> makeOrder(
      {required List<OrderModel> orders,
      required String name,
      required int userId,
      required String phone,
      required String adress}) async {
    try {
      final List<Map<String, dynamic>> orderList = orders
          .map((o) => {'book': o.book.id, 'qunatity': o.quantity})
          .toList();
      final paidMoney = orders.fold(
          0.0, (a, b) => a + (b.quantity * (b.book.priceHardcover ?? 1)));
      
      final response = await dioSetting.dio.post(
        'orders/bulk-create/',
        data: {
          'user_id':userId,
          'orders': orderList,
          'phone': phone,
          'adress': adress,
          'name': name,
          'price_paid': paidMoney,
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Error: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error making orders: $e');
    }
  }
}
