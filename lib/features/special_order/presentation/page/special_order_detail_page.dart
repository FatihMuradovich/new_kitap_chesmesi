import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/common/constants/base_url.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/widget/order_status_ui.dart';
import 'package:new_kitap_chesmesi/features/special_order/data/data_source/special_order_data_source.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/delivery_method_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/special_order_detail/special_order_detail_cubit.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/special_order_detail/special_order_detail_state.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/widget/special_order_status_ui.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

/// Talep detayı / teklif ekranı — SPECIAL-ORDER-API.md §4.
///
/// `Quoted` durumunda müşteri usulü ve hangi kitapları alacağını burada seçer;
/// onaya basınca adres ekranına geçilir ve sipariş orada oluşur.
@RoutePage()
class SpecialOrderDetailPage extends StatelessWidget {
  const SpecialOrderDetailPage({super.key, required this.requestId});

  final int requestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<SpecialOrderDetailCubit>()..load(requestId),
      child: _SpecialOrderDetailView(requestId: requestId),
    );
  }
}

class _SpecialOrderDetailView extends StatefulWidget {
  const _SpecialOrderDetailView({required this.requestId});

  final int requestId;

  @override
  State<_SpecialOrderDetailView> createState() =>
      _SpecialOrderDetailViewState();
}

class _SpecialOrderDetailViewState extends State<_SpecialOrderDetailView> {
  /// Seçili getirtme usulü. İlk teklif yüklendiğinde ilk aktif usule düşer.
  int? _selectedMethodId;

  /// Seçili kalem id'leri. Usul değişince o usulle getirilemeyenler düşürülür.
  final Set<int> _selectedItemIds = {};

  bool _initializedFromRequest = false;

  /// Teklif ilk kez yüklendiğinde varsayılan seçimi kur: ilk aktif usul ve
  /// o usulle getirilebilen tüm kalemler.
  void _initializeSelection(SpecialOrderRequestData request) {
    if (_initializedFromRequest) return;
    _initializedFromRequest = true;

    final methods = request.activeMethods;
    if (methods.isEmpty) return;

    final methodId = request.selectedMethod?.id ?? methods.first.id;
    _selectedMethodId = methodId;
    _selectedItemIds
      ..clear()
      ..addAll(request.selectableItemsFor(methodId).map((item) => item.id));
  }

  void _onMethodChanged(SpecialOrderRequestData request, int methodId) {
    setState(() {
      _selectedMethodId = methodId;
      // Yeni usulle getirilemeyen kalemler seçili kalamaz.
      _selectedItemIds.removeWhere((itemId) {
        final item = request.items.firstWhere(
          (candidate) => candidate.id == itemId,
          orElse: () => const SpecialOrderItemData(
            id: -1,
            bookId: 0,
            quantity: 0,
            available: false,
            selected: false,
            prices: [],
          ),
        );
        return !item.isSelectableFor(methodId);
      });
    });
  }

  double _selectedTotal(SpecialOrderRequestData request) {
    final methodId = _selectedMethodId;
    if (methodId == null) return 0;
    return request.items
        .where((item) => _selectedItemIds.contains(item.id))
        .fold<double>(0, (sum, item) => sum + item.lineTotalFor(methodId));
  }

  Future<void> _openApprove(SpecialOrderRequestData request) async {
    final methodId = _selectedMethodId;
    if (methodId == null) return;
    if (_selectedItemIds.isEmpty) {
      NotificationHelper.showWarning(context, context.l10n.selectAtLeastOneBook);
      return;
    }

    final method = request.methods.firstWhere(
      (candidate) => candidate.id == methodId,
      orElse: () => request.activeMethods.first,
    );

    final approved = await di<AppRouter>().push<bool>(
      SpecialOrderApproveRoute(
        requestId: request.id,
        method: method,
        items: request.items
            .where((item) => _selectedItemIds.contains(item.id))
            .toList(),
      ),
    );

    // Onay ekranı sipariş oluşturduysa talep artık `Approved` — detayı tazele.
    if (approved == true && mounted) {
      await context.read<SpecialOrderDetailCubit>().load(widget.requestId);
    }
  }

  Future<void> _confirmAndRun({
    required String title,
    required String message,
    required Future<SpecialOrderActionResult> Function(String? reason) action,
    required String successMessage,
  }) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => _ReasonDialog(title: title, message: message),
    );
    if (reason == null || !mounted) return;

    final result = await action(reason.trim().isEmpty ? null : reason);
    if (!mounted) return;

    if (result.success) {
      NotificationHelper.showSuccess(context, successMessage);
    } else {
      NotificationHelper.showError(
        context,
        result.statusCode == 400
            ? context.l10n.requestActionNotAllowed
            : context.l10n.errorMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          context.l10n.specialOrderTitle,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<SpecialOrderDetailCubit, SpecialOrderDetailState>(
        builder: (context, state) {
          if (state is SpecialOrderDetailLoading ||
              state is SpecialOrderDetailInitial) {
            return Center(
              child:
                  CircularProgressIndicator(color: CustomColors.orangeColor),
            );
          }

          if (state is SpecialOrderDetailError) {
            return _DetailError(
              statusCode: state.statusCode,
              onRetry: () => context
                  .read<SpecialOrderDetailCubit>()
                  .load(widget.requestId),
            );
          }

          final request = state is SpecialOrderDetailLoaded
              ? state.request
              : (state as SpecialOrderDetailSubmitting).request;
          final isSubmitting = state is SpecialOrderDetailSubmitting;

          _initializeSelection(request);
          final methodId = _selectedMethodId;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderCard(request: request),
                if (request.adminNote != null &&
                    request.adminNote!.trim().isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  _AdminNoteCard(note: request.adminNote!),
                ],
                if (request.status.canRespondToQuote &&
                    request.isQuoteExpired) ...[
                  SizedBox(height: 16.h),
                  const _ExpiredBanner(),
                ],
                if (request.activeMethods.isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  _SectionTitle(title: context.l10n.selectDeliveryMethod),
                  SizedBox(height: 12.h),
                  ...request.activeMethods.map(
                    (method) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _MethodCard(
                        method: method,
                        total: request.totalFor(method.id),
                        isSelected: method.id == methodId,
                        // Aksiyon alınamayan talepte seçim kilitli.
                        onTap: request.isActionable
                            ? () => _onMethodChanged(request, method.id)
                            : null,
                      ),
                    ),
                  ),
                ],
                if (request.items.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  _SectionTitle(title: context.l10n.selectBooks),
                  SizedBox(height: 12.h),
                  ...request.items.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _ItemCard(
                        item: item,
                        methodId: methodId,
                        isSelected: _selectedItemIds.contains(item.id),
                        onToggle: request.isActionable &&
                                methodId != null &&
                                item.isSelectableFor(methodId)
                            ? (selected) => setState(() {
                                  if (selected) {
                                    _selectedItemIds.add(item.id);
                                  } else {
                                    _selectedItemIds.remove(item.id);
                                  }
                                })
                            : null,
                      ),
                    ),
                  ),
                ],
                if (request.isActionable && methodId != null) ...[
                  SizedBox(height: 16.h),
                  _TotalRow(total: _selectedTotal(request)),
                ],
                SizedBox(height: 24.h),
                _Actions(
                  request: request,
                  isSubmitting: isSubmitting,
                  onApprove: () => _openApprove(request),
                  onReject: () => _confirmAndRun(
                    title: context.l10n.rejectQuoteConfirmTitle,
                    message: context.l10n.rejectQuoteConfirmMessage,
                    action: (reason) => context
                        .read<SpecialOrderDetailCubit>()
                        .reject(widget.requestId, reason: reason),
                    successMessage: context.l10n.quoteRejectedSuccess,
                  ),
                  onCancel: () => _confirmAndRun(
                    title: context.l10n.cancelRequestConfirmTitle,
                    message: context.l10n.cancelRequestConfirmMessage,
                    action: (reason) => context
                        .read<SpecialOrderDetailCubit>()
                        .cancel(widget.requestId, reason: reason),
                    successMessage: context.l10n.requestCancelledSuccess,
                  ),
                  onOpenOrder: request.orderId == null
                      ? null
                      : () => di<AppRouter>()
                          .push(OrderDetailRoute(orderId: request.orderId!)),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.request});

  final SpecialOrderRequestData request;

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
                context.l10n.requestNumber(request.id),
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SpecialOrderStatusChip(status: request.status),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            formatOrderDateTime(request.createdAt),
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          if (request.quoteExpiresAt != null &&
              request.status.canRespondToQuote) ...[
            SizedBox(height: 8.h),
            Text(
              context.l10n
                  .quoteExpiresAt(formatOrderDateTime(request.quoteExpiresAt!)),
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: CustomColors.orangeColor,
              ),
            ),
          ],
          if (request.note != null && request.note!.trim().isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              request.note!,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 12.sp,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Adminin notu — `available: false` kalemlerin sebebini açıklar (§4).
class _AdminNoteCard extends StatelessWidget {
  const _AdminNoteCard({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 15.sp, color: Colors.amber[800]),
              SizedBox(width: 6.w),
              Text(
                context.l10n.adminNoteTitle,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.amber[900],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            note,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 12.sp,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiredBanner extends StatelessWidget {
  const _ExpiredBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_off_outlined, size: 16.sp, color: Colors.blueGrey),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              context.l10n.quoteExpired,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.method,
    required this.total,
    required this.isSelected,
    required this.onTap,
  });

  final DeliveryMethodModel method;
  final MethodTotal? total;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? CustomColors.orangeColor : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20.sp,
              color: isSelected ? CustomColors.orangeColor : Colors.grey[400],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    context.l10n
                        .deliveryMethodDays(method.minDays, method.maxDays),
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 11.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (total != null)
              Text(
                '${total!.total} m.',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.orangeColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.methodId,
    required this.isSelected,
    required this.onToggle,
  });

  final SpecialOrderItemData item;
  final int? methodId;
  final bool isSelected;
  final ValueChanged<bool>? onToggle;

  @override
  Widget build(BuildContext context) {
    // İki ayrı "seçilemez" sebebi var ve mesajları farklı (§4):
    // kalem hiç getirilemiyor, ya da bu usulle getirilemiyor.
    final hasPriceForMethod = methodId != null && item.priceFor(methodId!) != null;
    final blockedReason = !item.available
        ? context.l10n.itemUnavailable
        : (!hasPriceForMethod ? context.l10n.noPriceForMethod : null);
    final isBlocked = blockedReason != null;

    final imagePath =
        item.book != null && item.book!.images.isNotEmpty
            ? item.book!.images.first.path
            : null;

    return Opacity(
      opacity: isBlocked ? 0.55 : 1,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected && !isBlocked
                ? CustomColors.orangeColor
                : Colors.grey[300]!,
            width: isSelected && !isBlocked ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: isSelected && !isBlocked,
              activeColor: CustomColors.orangeColor,
              onChanged:
                  onToggle == null ? null : (value) => onToggle!(value ?? false),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            SizedBox(width: 8.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: SizedBox(
                width: 42.w,
                height: 58.h,
                child: imagePath == null
                    ? Container(color: Colors.grey[200])
                    : Image.network(
                        '${BaseUrl.baseUrl}$imagePath',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey[200]),
                      ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.book?.name ?? '#${item.bookId}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      // Getirilemeyen kalem üstü çizili (§4).
                      decoration:
                          isBlocked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '× ${item.quantity}',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 11.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  if (isBlocked)
                    Text(
                      blockedReason,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[400],
                      ),
                    )
                  else
                    Text(
                      '${item.priceFor(methodId!)!.unitPrice} m. × ${item.quantity}'
                      '  =  ${item.lineTotalFor(methodId!).toStringAsFixed(2)} m.',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.orangeColor,
                      ),
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

/// Seçili kalemlerin ürün toplamı — teslimat ve hediye paketi hariç (§4).
class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.l10n.productsTotal,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${total.toStringAsFixed(2)} m.',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: CustomColors.orangeColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.request,
    required this.isSubmitting,
    required this.onApprove,
    required this.onReject,
    required this.onCancel,
    required this.onOpenOrder,
  });

  final SpecialOrderRequestData request;
  final bool isSubmitting;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onCancel;
  final VoidCallback? onOpenOrder;

  @override
  Widget build(BuildContext context) {
    if (isSubmitting) {
      return Center(
        child: CircularProgressIndicator(color: CustomColors.orangeColor),
      );
    }

    return Column(
      children: [
        // Onaylanmış talepten oluşan siparişe geçiş.
        if (onOpenOrder != null)
          CustomButton(
            height: 45.h,
            width: double.infinity,
            backgroundColor: CustomColors.blueColor,
            onTap: onOpenOrder,
            child: Text(
              context.l10n.orderDetailTitle,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        if (request.isActionable) ...[
          CustomButton(
            height: 45.h,
            width: double.infinity,
            backgroundColor: CustomColors.orangeColor,
            onTap: onApprove,
            child: Text(
              context.l10n.approveQuote,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: onReject,
            child: Text(
              context.l10n.rejectQuote,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
        if (request.status.canCancel)
          TextButton(
            onPressed: onCancel,
            child: Text(
              context.l10n.cancelRequest,
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

/// Reddet / iptal onayı + opsiyonel sebep alanı.
/// Controller sahipliği `_CancelOrderDialog` ile aynı gerekçeyle State'te.
class _ReasonDialog extends StatefulWidget {
  const _ReasonDialog({required this.title, required this.message});

  final String title;
  final String message;

  @override
  State<_ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<_ReasonDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      backgroundColor: Colors.white,
      title: Text(
        widget.title,
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
            widget.message,
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
                SpecialOrderDataSource.maxReasonLength,
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
    final message = statusCode == 404
        ? context.l10n.requestNotFound
        : context.l10n.errorMessage;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 40.sp, color: Colors.grey[400]),
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
