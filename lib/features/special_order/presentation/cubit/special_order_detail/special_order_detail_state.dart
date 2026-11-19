import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';

abstract class SpecialOrderDetailState extends Equatable {
  const SpecialOrderDetailState();

  @override
  List<Object?> get props => [];
}

class SpecialOrderDetailInitial extends SpecialOrderDetailState {}

class SpecialOrderDetailLoading extends SpecialOrderDetailState {}

class SpecialOrderDetailLoaded extends SpecialOrderDetailState {
  final SpecialOrderRequestData request;

  const SpecialOrderDetailLoaded(this.request);

  @override
  List<Object?> get props => [request];
}

/// Reddet/iptal/onay isteği sürerken — talep ekranda kalır, buton yükleme gösterir.
class SpecialOrderDetailSubmitting extends SpecialOrderDetailState {
  final SpecialOrderRequestData request;

  const SpecialOrderDetailSubmitting(this.request);

  @override
  List<Object?> get props => [request];
}

class SpecialOrderDetailError extends SpecialOrderDetailState {
  final int? statusCode;

  const SpecialOrderDetailError({this.statusCode});

  @override
  List<Object?> get props => [statusCode];
}

/// Reddet / iptal sonucu. Tek seferlik geri bildirim — durum olarak yayınlanmaz.
class SpecialOrderActionResult {
  final bool success;
  final int? statusCode;

  /// Backend'in İngilizce/teknik mesajı — yalnızca log ve debug toast'ı için.
  final String? rawMessage;

  const SpecialOrderActionResult.success()
      : success = true,
        statusCode = null,
        rawMessage = null;

  const SpecialOrderActionResult.failure({this.statusCode, this.rawMessage})
      : success = false;
}
