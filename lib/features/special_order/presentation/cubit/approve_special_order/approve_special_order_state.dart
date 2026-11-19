import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';

abstract class ApproveSpecialOrderState extends Equatable {
  const ApproveSpecialOrderState();

  @override
  List<Object?> get props => [];
}

class ApproveSpecialOrderInitial extends ApproveSpecialOrderState {}

class ApproveSpecialOrderSubmitting extends ApproveSpecialOrderState {}

/// Sipariş oluştu — `isSpecialOrder: true`, `status: Confirmed`,
/// `supplyStatus: Preparing`.
class ApproveSpecialOrderSuccess extends ApproveSpecialOrderState {
  final OrderData order;

  const ApproveSpecialOrderSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

/// 400'ün sebepleri (SPECIAL-ORDER-API.md §4): talep `Quoted` değil ya da süresi
/// dolmuş, kalem bu talebe ait değil / `available: false`, kalemin bu usul için
/// fiyatı yok, usul pasif.
class ApproveSpecialOrderFailure extends ApproveSpecialOrderState {
  final int? statusCode;
  final String? rawMessage;

  const ApproveSpecialOrderFailure({this.statusCode, this.rawMessage});

  @override
  List<Object?> get props => [statusCode, rawMessage];
}
