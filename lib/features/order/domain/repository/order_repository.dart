import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';

abstract class OrderRepository {
  Future<OrderResponse> createOrder(OrderRequest orderRequest);

  Future<OrdersPage> getMyOrders({
    int page,
    int limit,
    OrderStatus? status,
  });

  Future<OrderData> getOrderById(int id);

  Future<OrderData> cancelOrder(int id, {String? reason});
}
