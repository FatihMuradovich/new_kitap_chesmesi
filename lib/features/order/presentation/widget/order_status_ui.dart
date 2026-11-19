import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

/// Sipariş listesi ve detay ekranının paylaştığı durum görselleri.

String orderStatusLabel(BuildContext context, OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return context.l10n.orderStatusPending;
    case OrderStatus.confirmed:
      return context.l10n.orderStatusConfirmed;
    case OrderStatus.shipped:
      return context.l10n.orderStatusShipped;
    case OrderStatus.delivered:
      return context.l10n.orderStatusDelivered;
    case OrderStatus.cancelled:
      return context.l10n.orderStatusCancelled;
    case OrderStatus.unknown:
      return '-';
  }
}

Color orderStatusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return Colors.orange;
    case OrderStatus.confirmed:
      return Colors.blue;
    case OrderStatus.shipped:
      return Colors.indigo;
    case OrderStatus.delivered:
      return Colors.green;
    case OrderStatus.cancelled:
      return Colors.red;
    case OrderStatus.unknown:
      return Colors.grey;
  }
}

String orderActorLabel(BuildContext context, String actorType) {
  switch (actorType.toLowerCase()) {
    case 'user':
      return context.l10n.orderActorUser;
    case 'admin':
      return context.l10n.orderActorAdmin;
    case 'system':
      return context.l10n.orderActorSystem;
    default:
      return actorType;
  }
}

String formatOrderDate(String dateStr) {
  if (dateStr.isEmpty) return '-';
  final dt = DateTime.tryParse(dateStr);
  if (dt == null) return dateStr;
  final local = dt.toLocal();
  return '${local.day.toString().padLeft(2, '0')}.'
      '${local.month.toString().padLeft(2, '0')}.${local.year}';
}

String formatOrderDateTime(String dateStr) {
  if (dateStr.isEmpty) return '-';
  final dt = DateTime.tryParse(dateStr);
  if (dt == null) return dateStr;
  final local = dt.toLocal();
  return '${formatOrderDate(dateStr)} '
      '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = orderStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        orderStatusLabel(context, status),
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

/// Dört adımlı ilerleme: Garaşylýar → Tassyklandy → Ýolda → Gowşuryldy.
///
/// Adımlar alt alta dizilir — yatay dizilimde dört etiket 56.w'lik kutulara
/// sığmayıp kırpılıyordu. Durum geçmişi zaman çizelgesiyle de aynı görsel dil.
class OrderStepper extends StatelessWidget {
  final OrderStatus status;

  const OrderStepper({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.l10n.orderStatusPending,
      context.l10n.orderStatusConfirmed,
      context.l10n.orderStatusShipped,
      context.l10n.orderStatusDelivered,
    ];
    final currentStep = status.stepIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(labels.length, (index) {
        return StatusStepRow(
          label: labels[index],
          isDone: index < currentStep,
          isCurrent: index == currentStep,
          isLast: index == labels.length - 1,
        );
      }),
    );
  }
}

/// Tek bir çizelge adımı. `OrderStepper` (sipariş ekseni) ve `SupplyStepper`
/// (özel siparişin tedarik ekseni) aynı görsel dili paylaşsın diye public.
class StatusStepRow extends StatelessWidget {
  const StatusStepRow({
    super.key,
    required this.label,
    required this.isDone,
    required this.isCurrent,
    required this.isLast,
  });

  final String label;
  final bool isDone;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final active = isDone || isCurrent;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? CustomColors.orangeColor : Colors.white,
                  border: Border.all(
                    color:
                        active ? CustomColors.orangeColor : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isDone
                    ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    color: isDone
                        ? CustomColors.orangeColor
                        : Colors.grey[300],
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 3.h, bottom: isLast ? 0 : 14.h),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 12.sp,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                  color: active ? CustomColors.orangeColor : Colors.grey[500],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// İptal edilmiş siparişlerde stepper yerine gösterilen kırmızı şerit.
class OrderCancelledBanner extends StatelessWidget {
  const OrderCancelledBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        context.l10n.orderStatusCancelled,
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
    );
  }
}
