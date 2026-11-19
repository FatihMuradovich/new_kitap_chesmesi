import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';

abstract class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object?> get props => [];
}

class OrderDetailInitial extends OrderDetailState {}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  final OrderData order;

  const OrderDetailLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

/// İptal isteği sürerken — sipariş ekranda kalır, buton yükleme gösterir.
class OrderDetailCancelling extends OrderDetailState {
  final OrderData order;

  const OrderDetailCancelling(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderDetailError extends OrderDetailState {
  final int? statusCode;

  const OrderDetailError({this.statusCode});

  @override
  List<Object?> get props => [statusCode];
}

/// `OrderDetailCubit.cancel()` sonucu. Tek seferlik geri bildirim (toast) durum
/// olarak yayınlanmaz — çağıran doğrudan bu değere bakar.
class OrderCancelResult {
  final bool success;
  final int? statusCode;

  /// Backend'in İngilizce/teknik mesajı — yalnızca log ve debug toast'ı için.
  final String? rawMessage;

  const OrderCancelResult.success()
      : success = true,
        statusCode = null,
        rawMessage = null;

  const OrderCancelResult.failure({this.statusCode, this.rawMessage})
      : success = false;
}
