import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_api_exception.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/order_repository.dart';
import 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  final OrderRepository orderRepository;

  OrderDetailCubit({required this.orderRepository})
      : super(OrderDetailInitial());

  Future<void> load(int orderId) async {
    emit(OrderDetailLoading());
    try {
      final order = await orderRepository.getOrderById(orderId);
      emit(OrderDetailLoaded(order));
    } catch (e) {
      log('Sipariş detayı yüklenemedi (id: $orderId): ${_describe(e)}',
          name: 'OrderDetail');
      emit(OrderDetailError(statusCode: _statusCodeOf(e)));
    }
  }

  Future<OrderCancelResult> cancel(int orderId, {String? reason}) async {
    final currentState = state;
    if (currentState is! OrderDetailLoaded) {
      return const OrderCancelResult.failure();
    }

    emit(OrderDetailCancelling(currentState.order));
    try {
      await orderRepository.cancelOrder(orderId, reason: reason);
    } catch (e) {
      log('Sipariş iptali başarısız (id: $orderId): ${_describe(e)}',
          name: 'OrderDetail');
      emit(OrderDetailLoaded(currentState.order));
      return OrderCancelResult.failure(
        statusCode: _statusCodeOf(e),
        rawMessage: _rawMessageOf(e),
      );
    }

    // İptal yanıtı `statusHistory` içermiyor (ORDER-API.md §5.7) — detayı yeniden
    // çekmek zorundayız. Bu çağrı başarısız olsa bile iptal gerçekleşti.
    try {
      emit(OrderDetailLoaded(await orderRepository.getOrderById(orderId)));
    } catch (e) {
      log('İptal sonrası detay tazelenemedi (id: $orderId): ${_describe(e)}',
          name: 'OrderDetail');
      emit(OrderDetailLoaded(currentState.order));
    }
    return const OrderCancelResult.success();
  }

  int? _statusCodeOf(Object e) => e is OrderApiException ? e.statusCode : null;

  String? _rawMessageOf(Object e) =>
      e is OrderApiException ? e.rawMessage : e.toString();

  String _describe(Object e) =>
      e is OrderApiException ? '${e.statusCode} — ${e.rawMessage}' : e.toString();
}
