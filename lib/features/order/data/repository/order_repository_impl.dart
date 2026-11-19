import 'package:new_kitap_chesmesi/features/order/data/data_source/order_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource orderDataSource;

  OrderRepositoryImpl({required this.orderDataSource});

  @override
  Future<OrderResponse> createOrder(OrderRequest orderRequest) async {
    return await orderDataSource.createOrder(orderRequest);
  }

  @override
  Future<OrdersPage> getMyOrders({
    int page = 1,
    int limit = 20,
    OrderStatus? status,
  }) async {
    return await orderDataSource.getMyOrders(
      page: page,
      limit: limit,
      status: status,
    );
  }

  @override
  Future<OrderData> getOrderById(int id) async {
    return await orderDataSource.getOrderById(id);
  }

  @override
  Future<OrderData> cancelOrder(int id, {String? reason}) async {
    return await orderDataSource.cancelOrder(id, reason: reason);
  }
}
