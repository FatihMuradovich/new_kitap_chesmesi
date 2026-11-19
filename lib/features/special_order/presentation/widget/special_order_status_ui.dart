import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

/// Talep ve tedarik durumlarının paylaşılan görselleri.
/// Tarih biçimlendirme (`formatOrderDate`) `order_status_ui.dart`'tan gelir.

String specialOrderStatusLabel(BuildContext context, SpecialOrderStatus status) {
  switch (status) {
    case SpecialOrderStatus.pending:
      return context.l10n.specialOrderStatusPending;
    case SpecialOrderStatus.quoted:
      return context.l10n.specialOrderStatusQuoted;
    case SpecialOrderStatus.approved:
      return context.l10n.specialOrderStatusApproved;
    case SpecialOrderStatus.rejected:
      return context.l10n.specialOrderStatusRejected;
    case SpecialOrderStatus.expired:
      return context.l10n.specialOrderStatusExpired;
    case SpecialOrderStatus.cancelled:
      return context.l10n.specialOrderStatusCancelled;
    case SpecialOrderStatus.unavailable:
      return context.l10n.specialOrderStatusUnavailable;
    case SpecialOrderStatus.unknown:
      return '-';
  }
}

Color specialOrderStatusColor(SpecialOrderStatus status) {
  switch (status) {
    case SpecialOrderStatus.pending:
      return Colors.orange;
    case SpecialOrderStatus.quoted:
      // Aksiyon bekleyen tek durum — marka rengiyle öne çıkar.
      return CustomColors.orangeColor;
    case SpecialOrderStatus.approved:
      return Colors.green;
    case SpecialOrderStatus.rejected:
      return Colors.red;
    case SpecialOrderStatus.expired:
      return Colors.blueGrey;
    case SpecialOrderStatus.cancelled:
      return Colors.red;
    case SpecialOrderStatus.unavailable:
      return Colors.brown;
    case SpecialOrderStatus.unknown:
      return Colors.grey;
  }
}

// ÖZEL SİPARİŞ — tedarik ekseni geçici olarak kapatıldı
// (`SupplyStatus`, order_model.dart içinde yoruma alındı).
// String supplyStatusLabel(BuildContext context, SupplyStatus status) {
//   switch (status) {
//     case SupplyStatus.preparing:
//       return context.l10n.supplyStatusPreparing;
//     case SupplyStatus.orderedAbroad:
//       return context.l10n.supplyStatusOrderedAbroad;
//     case SupplyStatus.inTransit:
//       return context.l10n.supplyStatusInTransit;
//     case SupplyStatus.arrived:
//       return context.l10n.supplyStatusArrived;
//     case SupplyStatus.unknown:
//       return '-';
//   }
// }
//
// Color supplyStatusColor(SupplyStatus status) {
//   switch (status) {
//     case SupplyStatus.preparing:
//       return Colors.orange;
//     case SupplyStatus.orderedAbroad:
//       return Colors.blue;
//     case SupplyStatus.inTransit:
//       return Colors.indigo;
//     case SupplyStatus.arrived:
//       return Colors.green;
//     case SupplyStatus.unknown:
//       return Colors.grey;
//   }
// }
//
// /// Zaman çizelgesindeki `note` alanından çözülmüş tedarik kaydı.
// class SupplyNote {
//   final SupplyStatus status;
//
//   /// Öneki çıkarılmış admin açıklaması — "Arrived: Gümrükten çıktı" → "Gümrükten çıktı".
//   final String? detail;
//
//   const SupplyNote({required this.status, this.detail});
// }
//
// /// Tedarik aşamaları `statusHistory.note` içinde `"Arrived"` ya da
// /// `"Arrived: Gümrükten çıktı"` biçiminde taşınır (SPECIAL-ORDER-API.md §5).
// /// Önek tanınmazsa `null` döner ve çağıran notu düz metin olarak gösterir.
// SupplyNote? parseSupplyNote(String? note) {
//   final trimmed = note?.trim();
//   if (trimmed == null || trimmed.isEmpty) return null;
//
//   final separator = trimmed.indexOf(':');
//   final head = separator == -1 ? trimmed : trimmed.substring(0, separator);
//   final status = SupplyStatus.fromApi(head);
//   if (status == SupplyStatus.unknown) return null;
//
//   final detail =
//       separator == -1 ? null : trimmed.substring(separator + 1).trim();
//   return SupplyNote(
//     status: status,
//     detail: detail == null || detail.isEmpty ? null : detail,
//   );
// }

/// Talep durumu rozeti — `OrderStatusChip`'in muadili.
class SpecialOrderStatusChip extends StatelessWidget {
  final SpecialOrderStatus status;

  const SpecialOrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return _Chip(
      label: specialOrderStatusLabel(context, status),
      color: specialOrderStatusColor(status),
    );
  }
}

// ÖZEL SİPARİŞ — tedarik ekseni geçici olarak kapatıldı
// (`SupplyStatus`, order_model.dart içinde yoruma alındı).
// /// Tedarik durumu rozeti.
// class SupplyStatusChip extends StatelessWidget {
//   final SupplyStatus status;
//
//   const SupplyStatusChip({super.key, required this.status});
//
//   @override
//   Widget build(BuildContext context) {
//     return _Chip(
//       label: supplyStatusLabel(context, status),
//       color: supplyStatusColor(status),
//     );
//   }
// }

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ÖZEL SİPARİŞ — tedarik ekseni geçici olarak kapatıldı.
// /// Tedarik ekseni: Taýýarlanýar → Daşary ýurtdan sargyt edildi → Ýolda → Geldi.
// /// `OrderStepper` ile aynı görsel dil (`StatusStepRow`), ayrı eksen.
// class SupplyStepper extends StatelessWidget {
//   final SupplyStatus status;
//
//   const SupplyStepper({super.key, required this.status});
//
//   @override
//   Widget build(BuildContext context) {
//     final labels = [
//       context.l10n.supplyStatusPreparing,
//       context.l10n.supplyStatusOrderedAbroad,
//       context.l10n.supplyStatusInTransit,
//       context.l10n.supplyStatusArrived,
//     ];
//     final currentStep = status.stepIndex;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: List.generate(labels.length, (index) {
//         return StatusStepRow(
//           label: labels[index],
//           isDone: index < currentStep,
//           isCurrent: index == currentStep,
//           isLast: index == labels.length - 1,
//         );
//       }),
//     );
//   }
// }
