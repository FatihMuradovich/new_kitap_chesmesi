import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';

abstract class CreateSpecialOrderState extends Equatable {
  const CreateSpecialOrderState();

  @override
  List<Object?> get props => [];
}

class CreateSpecialOrderInitial extends CreateSpecialOrderState {}

class CreateSpecialOrderSubmitting extends CreateSpecialOrderState {}

class CreateSpecialOrderSuccess extends CreateSpecialOrderState {
  final SpecialOrderRequestData request;

  const CreateSpecialOrderSuccess(this.request);

  @override
  List<Object?> get props => [request];
}

/// Talep açılamadı. 400'ün üç sebebi var (SPECIAL-ORDER-API.md §4) ve backend
/// mesajı teknik — UI [statusCode] + [rawMessage] üzerinden kendi lokalize
/// metnini seçer.
class CreateSpecialOrderFailure extends CreateSpecialOrderState {
  final int? statusCode;
  final String? rawMessage;

  const CreateSpecialOrderFailure({this.statusCode, this.rawMessage});

  @override
  List<Object?> get props => [statusCode, rawMessage];
}
