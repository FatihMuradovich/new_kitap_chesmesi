import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_api_exception.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/repository/special_order_repository.dart';
import 'special_order_detail_state.dart';

/// Talep detayı + teklif aksiyonları (onayla / reddet / iptal).
/// `OrderDetailCubit` ile aynı sözleşme: aksiyon sonrası detay yeniden çekilir,
/// hata olursa önceki state'e dönülür.
class SpecialOrderDetailCubit extends Cubit<SpecialOrderDetailState> {
  final SpecialOrderRepository specialOrderRepository;

  SpecialOrderDetailCubit({required this.specialOrderRepository})
      : super(SpecialOrderDetailInitial());

  Future<void> load(int requestId) async {
    emit(SpecialOrderDetailLoading());
    try {
      final request = await specialOrderRepository.getRequestById(requestId);
      emit(SpecialOrderDetailLoaded(request));
    } catch (e) {
      log('Talep detayı yüklenemedi (id: $requestId): ${_describe(e)}',
          name: 'SpecialOrderDetail');
      emit(SpecialOrderDetailError(statusCode: _statusCodeOf(e)));
    }
  }

  /// Onay ayrı bir ekranda ve ayrı bir cubit'te yürür
  /// (`ApproveSpecialOrderCubit`) — bu ekran dönüşte [load] ile tazelenir.

  Future<SpecialOrderActionResult> reject(int requestId, {String? reason}) =>
      _act(requestId, (id) => specialOrderRepository.reject(id, reason: reason),
          'Teklif reddi');

  Future<SpecialOrderActionResult> cancel(int requestId, {String? reason}) =>
      _act(requestId, (id) => specialOrderRepository.cancel(id, reason: reason),
          'Talep iptali');

  Future<SpecialOrderActionResult> _act(
    int requestId,
    Future<SpecialOrderRequestData> Function(int id) action,
    String label,
  ) async {
    final currentState = state;
    if (currentState is! SpecialOrderDetailLoaded) {
      return const SpecialOrderActionResult.failure();
    }

    emit(SpecialOrderDetailSubmitting(currentState.request));
    try {
      await action(requestId);
    } catch (e) {
      log('$label başarısız (id: $requestId): ${_describe(e)}',
          name: 'SpecialOrderDetail');
      emit(SpecialOrderDetailLoaded(currentState.request));
      return SpecialOrderActionResult.failure(
        statusCode: _statusCodeOf(e),
        rawMessage: _rawMessageOf(e),
      );
    }

    await _refreshQuietly(requestId, currentState.request);
    return const SpecialOrderActionResult.success();
  }

  /// Aksiyon yanıtı tam detayı taşımayabilir — yeniden çek. Bu çağrı başarısız
  /// olsa bile aksiyon gerçekleşti, o yüzden hata yutulur.
  Future<void> _refreshQuietly(
    int requestId,
    SpecialOrderRequestData fallback,
  ) async {
    try {
      emit(SpecialOrderDetailLoaded(
        await specialOrderRepository.getRequestById(requestId),
      ));
    } catch (e) {
      log('Aksiyon sonrası detay tazelenemedi (id: $requestId): ${_describe(e)}',
          name: 'SpecialOrderDetail');
      emit(SpecialOrderDetailLoaded(fallback));
    }
  }

  int? _statusCodeOf(Object e) => e is OrderApiException ? e.statusCode : null;

  String? _rawMessageOf(Object e) =>
      e is OrderApiException ? e.rawMessage : e.toString();

  String _describe(Object e) => e is OrderApiException
      ? '${e.statusCode} — ${e.rawMessage}'
      : e.toString();
}
