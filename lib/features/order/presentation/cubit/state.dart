
import 'package:equatable/equatable.dart';

import '../../domain/model/order.dart';


abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderModel> orders;

  const OrderLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}
