import 'package:flutter/widgets.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

/// Sepet hatasının kullanıcının dilindeki metni.
String cartErrorMessage(
  BuildContext context,
  CartFailureReason reason, {
  int? maxStock,
}) {
  return switch (reason) {
    CartFailureReason.stockLimit => context.l10n.stockLimit(maxStock ?? 0),
    CartFailureReason.connection => context.l10n.noInternetMessage,
    CartFailureReason.unknown => context.l10n.errorMessage,
  };
}
