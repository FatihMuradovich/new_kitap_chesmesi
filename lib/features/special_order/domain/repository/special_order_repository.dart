import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';

abstract class SpecialOrderRepository {
  Future<SpecialOrderRequestData> createRequest(
    CreateSpecialOrderRequest request,
  );

  Future<SpecialOrdersPage> getMyRequests({
    int page,
    int limit,
    SpecialOrderStatus? status,
  });

  Future<SpecialOrderRequestData> getRequestById(int id);

  Future<OrderData> approve(int id, ApproveSpecialOrderRequest request);

  Future<SpecialOrderRequestData> reject(int id, {String? reason});

  Future<SpecialOrderRequestData> cancel(int id, {String? reason});
}
