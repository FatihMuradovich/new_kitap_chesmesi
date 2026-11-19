import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final OrderResponse orderResponse;
  
  OrderSuccess(this.orderResponse);
}

class OrderError extends OrderState {
  final String message;
  
  OrderError(this.message);
}
