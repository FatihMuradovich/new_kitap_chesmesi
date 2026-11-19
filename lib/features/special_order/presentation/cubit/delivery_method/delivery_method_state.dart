import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/delivery_method_model.dart';

abstract class DeliveryMethodState extends Equatable {
  const DeliveryMethodState();

  @override
  List<Object?> get props => [];
}

class DeliveryMethodInitial extends DeliveryMethodState {}

class DeliveryMethodLoading extends DeliveryMethodState {}

class DeliveryMethodLoaded extends DeliveryMethodState {
  final List<DeliveryMethodModel> methods;

  const DeliveryMethodLoaded(this.methods);

  @override
  List<Object?> get props => [methods];
}

class DeliveryMethodError extends DeliveryMethodState {
  final int? statusCode;

  const DeliveryMethodError({this.statusCode});

  @override
  List<Object?> get props => [statusCode];
}
