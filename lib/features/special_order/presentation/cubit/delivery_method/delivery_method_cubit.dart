import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_api_exception.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/repository/delivery_method_repository.dart';
import 'delivery_method_state.dart';

/// Getirtme usulleri. Talep sheet'inde ve teklif ekranında kullanıldığı için
/// tekil (`registerLazySingleton`) — liste nadiren değişir, bir kez çekmek yeter.
class DeliveryMethodCubit extends Cubit<DeliveryMethodState> {
  final DeliveryMethodRepository deliveryMethodRepository;

  DeliveryMethodCubit({required this.deliveryMethodRepository})
      : super(DeliveryMethodInitial());

  /// Zaten yüklüyse ağa çıkmaz.
  Future<void> loadIfNeeded() async {
    if (state is DeliveryMethodLoaded || state is DeliveryMethodLoading) return;
    await load();
  }

  Future<void> load() async {
    emit(DeliveryMethodLoading());
    try {
      final methods = await deliveryMethodRepository.getDeliveryMethods();
      emit(DeliveryMethodLoaded(methods));
    } catch (e) {
      log('Getirtme usulleri yüklenemedi: $e', name: 'DeliveryMethod');
      emit(DeliveryMethodError(
        statusCode: e is OrderApiException ? e.statusCode : null,
      ));
    }
  }
}
