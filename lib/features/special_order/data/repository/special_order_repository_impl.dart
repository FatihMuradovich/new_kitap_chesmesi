import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/data/data_source/special_order_data_source.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/repository/special_order_repository.dart';

class SpecialOrderRepositoryImpl implements SpecialOrderRepository {
  final SpecialOrderDataSource specialOrderDataSource;

  SpecialOrderRepositoryImpl({required this.specialOrderDataSource});

  @override
  Future<SpecialOrderRequestData> createRequest(
    CreateSpecialOrderRequest request,
  ) async =>
      await specialOrderDataSource.createRequest(request);

  @override
  Future<SpecialOrdersPage> getMyRequests({
    int page = 1,
    int limit = 20,
    SpecialOrderStatus? status,
  }) async =>
      await specialOrderDataSource.getMyRequests(
        page: page,
        limit: limit,
        status: status,
      );

  @override
  Future<SpecialOrderRequestData> getRequestById(int id) async =>
      await specialOrderDataSource.getRequestById(id);

  @override
  Future<OrderData> approve(
    int id,
    ApproveSpecialOrderRequest request,
  ) async =>
      await specialOrderDataSource.approve(id, request);

  @override
  Future<SpecialOrderRequestData> reject(int id, {String? reason}) async =>
      await specialOrderDataSource.reject(id, reason: reason);

  @override
  Future<SpecialOrderRequestData> cancel(int id, {String? reason}) async =>
      await specialOrderDataSource.cancel(id, reason: reason);
}
