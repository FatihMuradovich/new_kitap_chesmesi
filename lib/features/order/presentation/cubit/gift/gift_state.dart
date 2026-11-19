import 'package:new_kitap_chesmesi/features/order/domain/model/gift_model.dart';

abstract class GiftState {}

class GiftInitial extends GiftState {}

class GiftLoading extends GiftState {}

class GiftLoaded extends GiftState {
  final List<GiftModel> gifts;
  
  GiftLoaded(this.gifts);
}

class GiftError extends GiftState {
  final String message;
  
  GiftError(this.message);
}
