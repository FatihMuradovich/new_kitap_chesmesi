import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/common/widgets/error_retry_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/common/constants/base_url.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/order/data/data_source/order_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/order_detail/order_detail_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/order_detail/order_detail_state.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/widget/order_status_ui.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class OrderDetailPage extends StatelessWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<OrderDetailCubit>()..load(orderId),
      child: _OrderDetailView(orderId: orderId),
    );
  }
}

class _OrderDetailView extends StatelessWidget {
  const _OrderDetailView({required this.orderId});

  final int orderId;

  Future<void> _confirmCancel(BuildContext context, OrderData order) async {
    final cubit = context.read<OrderDetailCubit>();

    // Vazgeçildiyse null, onaylandıysa (boş olabilen) sebep metni döner.
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => const _CancelOrderDialog(),
    );
    if (reason == null || !context.mounted) return;

    final result = await cubit.cancel(order.id, reason: reason);
    if (!context.mounted) return;

    if (result.success) {
      NotificationHelper.showSuccess(
        context,
        context.l10n.orderCancelledSuccess,
      );
    } else {
      NotificationHelper.showError(
          context, _cancelErrorMessage(context, result));
    }
  }

  String _cancelErrorMessage(BuildContext context, OrderCancelResult result) {
    // Geliştirirken backend'in gerçek sebebini görmek şart; son kullanıcıya
    // teknik mesaj gösterilmez (ORDER-API.md §3).
    if (kDebugMode && result.rawMessage != null) {
      return '[${result.statusCode}] ${result.rawMessage}';
    }
    switch (result.statusCode) {
      case 400:
        return context.l10n.orderCannotBeCancelled;
      case 401:
        return context.l10n.sessionExpired;
      case 404:
        return context.l10n.orderNotFound;
      default:
        return context.l10n.errorMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          context.l10n.orderDetailTitle,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<OrderDetailCubit, OrderDetailState>(
        builder: (context, state) {
          if (state is OrderDetailLoading || state is OrderDetailInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: CustomColors.orangeColor,
              ),
            );
          }

          if (state is OrderDetailError) {
            return _DetailError(
              statusCode: state.statusCode,
              onRetry: () => context.read<OrderDetailCubit>().load(orderId),
            );
          }

          final OrderData order;
          final bool isCancelling;
          if (state is OrderDetailCancelling) {
            order = state.order;
            isCancelling = true;
          } else if (state is OrderDetailLoaded) {
            order = state.order;
            isCancelling = false;
          } else {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            color: CustomColors.orangeColor,
            onRefresh: () => context.read<OrderDetailCubit>().load(orderId),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryCard(order: order),
                  SizedBox(height: 16.h),
                  if (order.orderItems.isNotEmpty) ...[
                    _SectionTitle(title: context.l10n.orderItems),
                    SizedBox(height: 8.h),
                    ...order.orderItems.map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: _OrderItemTile(item: item),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                  _DeliveryCard(order: order),
                  if (order.statusHistory.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    _SectionTitle(title: context.l10n.orderStatusHistoryTitle),
                    SizedBox(height: 8.h),
                    _StatusTimeline(history: order.statusHistory),
                  ],
                  if (order.canCancel) ...[
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        height: 48.h,
                        backgroundColor: Colors.red,
                        onTap: isCancelling
                            ? null
                            : () => _confirmCancel(context, order),
                        child: isCancelling
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                context.l10n.cancelOrder,
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// İptal onayı + opsiyonel sebep alanı.
///
/// Controller'ı bu widget'ın kendi `State`'i sahiplenir: `dispose()` route gerçekten
/// yok edildiğinde, yani kapanma animasyonu bittikten sonra çalışır. Controller'ı
/// `showDialog` döner dönmez elle dispose etmek, hâlâ ağaçta olan `EditableText`
/// odağını kaybederken `clearComposing()` çağırdığı için exception fırlatıyordu.
class _CancelOrderDialog extends StatefulWidget {
  const _CancelOrderDialog();

  @override
  State<_CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<_CancelOrderDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Klavye açılınca içerik taşmasın.
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      backgroundColor: Colors.white,
      title: Text(
        context.l10n.cancelOrderConfirmTitle,
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.cancelOrderConfirmMessage,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextFormField(
            controller: _reasonController,
            isPrefix: false,
            isCalendar: false,
            isPassword: false,
            maxLines: 3,
            hintText: context.l10n.cancelReasonHint,
            textInputAction: TextInputAction.done,
            formatters: [
              LengthLimitingTextInputFormatter(
                OrderDataSource.maxCancelReasonLength,
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            context.l10n.no,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_reasonController.text),
          child: Text(
            context.l10n.yes,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.statusCode, required this.onRetry});

  final int? statusCode;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (statusCode != 404) return ErrorRetryView(onRetry: onRetry);
    final message = context.l10n.orderNotFound;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              statusCode == 404
                  ? Icons.receipt_long_outlined
                  : Icons.wifi_off_rounded,
              size: 40.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),
            if (statusCode != 404) ...[
              SizedBox(height: 16.h),
              TextButton(
                onPressed: onRetry,
                child: Text(
                  context.l10n.tryAgain,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.orangeColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Poppins-regular',
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.order});

  final OrderData order;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${order.id}',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.orangeColor,
                ),
              ),
              OrderStatusChip(status: order.status),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            formatOrderDateTime(order.createdAt),
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 12.sp,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 18.h),
          if (order.status == OrderStatus.cancelled)
            const OrderCancelledBanner()
          else
            OrderStepper(status: order.status),
          SizedBox(height: 18.h),
          Divider(height: 1, color: Colors.grey[200]),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.orderTotal,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '${order.total} m.',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.orangeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile({required this.item});

  final OrderItemData item;

  @override
  Widget build(BuildContext context) {
    final book = item.book;
    final imagePath =
        book != null && book.images.isNotEmpty ? book.images.first.path : null;

    // Sepet kartıyla aynı düzen: solda kare görsel, sağda ad / yazar / fiyat.
    return _CardShell(
      child: SizedBox(
        height: 65.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[50],
              ),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imagePath == null
                      ? Icon(
                          Icons.menu_book_outlined,
                          color: Colors.grey[400],
                          size: 20.sp,
                        )
                      : CachedNetworkImage(
                          imageUrl: '${BaseUrl.baseUrl}$imagePath',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              color: CustomColors.orangeColor,
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book?.name ?? '#${item.bookId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    book?.author?.name ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 12.sp,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Sipariş anındaki dondurulmuş fiyat — book.price DEĞİL.
                      Text(
                        '${item.price} m.',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF282846),
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        'x${item.quantity}',
                        style: TextStyle(
                          fontFamily: 'Poppins-black',
                          color: CustomColors.blueColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard({required this.order});

  final OrderData order;

  @override
  Widget build(BuildContext context) {
    final desc = order.desc;
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined,
                  size: 18.sp, color: Colors.grey[500]),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.deliveryAddress,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      order.address.isEmpty ? '-' : order.address,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 13.sp,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (desc != null && desc.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.sticky_note_2_outlined,
                    size: 18.sp, color: Colors.grey[500]),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.note,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        desc,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 13.sp,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Durum geçmişi zaman çizelgesi — kayıtlar API'den tarihe göre artan gelir.

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.history});

  final List<OrderStatusHistory> history;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(history.length, (index) {
          final entry = history[index];
          final isLast = index == history.length - 1;
          final color = orderStatusColor(entry.status);

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      margin: EdgeInsets.only(top: 4.h),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          color: Colors.grey[300],
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                orderStatusLabel(context, entry.status),
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ),
                            Text(
                              formatOrderDateTime(entry.createdAt),
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 11.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          orderActorLabel(context, entry.actorType),
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (entry.note != null && entry.note!.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            entry.note!,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 12.sp,
                              color: Colors.grey[800],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
