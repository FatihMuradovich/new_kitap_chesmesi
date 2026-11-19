import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_api_exception.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/repository/special_order_repository.dart';
import 'approve_special_order_state.dart';

/// Teklifi onaylama — **bu çağrı siparişi oluşturur** (SPECIAL-ORDER-API.md §4).
class ApproveSpecialOrderCubit extends Cubit<ApproveSpecialOrderState> {
  final SpecialOrderRepository specialOrderRepository;

  ApproveSpecialOrderCubit({required this.specialOrderRepository})
      : super(ApproveSpecialOrderInitial());

  Future<void> submit(
    int requestId,
    ApproveSpecialOrderRequest request,
  ) async {
    emit(ApproveSpecialOrderSubmitting());
    try {
      final order = await specialOrderRepository.approve(requestId, request);
      emit(ApproveSpecialOrderSuccess(order));
    } catch (e) {
      log('Teklif onayı başarısız (id: $requestId): ${_describe(e)}',
          name: 'ApproveSpecialOrder');
      emit(ApproveSpecialOrderFailure(
        statusCode: e is OrderApiException ? e.statusCode : null,
        rawMessage: e is OrderApiException ? e.rawMessage : e.toString(),
      ));
    }
  }

  String _describe(Object e) => e is OrderApiException
      ? '${e.statusCode} — ${e.rawMessage}'
      : e.toString();
}
