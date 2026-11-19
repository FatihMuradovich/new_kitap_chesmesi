import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/order_repository.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/order/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository orderRepository;

  OrderCubit({required this.orderRepository}) : super(OrderInitial());

  Future<void> createOrder(OrderRequest orderRequest) async {
    try {
      log('OrderCubit: createOrder başlatıldı');
      emit(OrderLoading());
      
      final orderResponse = await orderRepository.createOrder(orderRequest);
      log('OrderCubit: Sipariş başarıyla oluşturuldu: ${orderResponse.message}');
      
      emit(OrderSuccess(orderResponse));
    } catch (e) {
      log('OrderCubit: Hata oluştu: $e');
      log('OrderCubit: Hata tipi: ${e.runtimeType}');
      emit(OrderError(e.toString()));
    }
  }

  void resetState() {
    emit(OrderInitial());
  }
}
