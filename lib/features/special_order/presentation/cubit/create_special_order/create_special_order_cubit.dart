import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_api_exception.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/repository/special_order_repository.dart';
import 'create_special_order_state.dart';

/// Kitap detayından talep açma.
class CreateSpecialOrderCubit extends Cubit<CreateSpecialOrderState> {
  final SpecialOrderRepository specialOrderRepository;

  CreateSpecialOrderCubit({required this.specialOrderRepository})
      : super(CreateSpecialOrderInitial());

  Future<void> submit({
    required int bookId,
    int quantity = 1,
    String? note,
  }) async {
    emit(CreateSpecialOrderSubmitting());
    try {
      final request = await specialOrderRepository.createRequest(
        CreateSpecialOrderRequest(
          items: [SpecialOrderItem(bookId: bookId, quantity: quantity)],
          note: note,
        ),
      );
      emit(CreateSpecialOrderSuccess(request));
    } catch (e) {
      log('Özel sipariş talebi açılamadı (bookId: $bookId): ${_describe(e)}',
          name: 'CreateSpecialOrder');
      emit(CreateSpecialOrderFailure(
        statusCode: e is OrderApiException ? e.statusCode : null,
        rawMessage: e is OrderApiException ? e.rawMessage : e.toString(),
      ));
    }
  }

  /// Sheet yeniden açıldığında önceki hatayı taşımamak için.
  void reset() => emit(CreateSpecialOrderInitial());

  String _describe(Object e) => e is OrderApiException
      ? '${e.statusCode} — ${e.rawMessage}'
      : e.toString();
}
