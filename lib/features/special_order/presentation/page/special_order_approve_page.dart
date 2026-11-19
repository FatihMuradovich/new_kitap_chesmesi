import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
import 'package:new_kitap_chesmesi/features/order/domain/model/gift_model.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/gift/gift_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/gift/gift_state.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/widget/success_order_dialog.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/delivery_method_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/special_order_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/approve_special_order/approve_special_order_cubit.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/approve_special_order/approve_special_order_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

/// Teklif onayı — adres, hediye paketi ve son toplam.
/// `POST /special-order/:id/approve` **siparişi burada oluşturur** (§4).
///
/// Checkout (`order_page.dart`) ile aynı welayat/etrap/adres akışını kullanır;
/// tek farkı **kupon alanı yoktur** — özel siparişte kupon geçmez.
@RoutePage()
class SpecialOrderApprovePage extends StatelessWidget {
  const SpecialOrderApprovePage({
    super.key,
    required this.requestId,
    required this.method,
    required this.items,
  });

  final int requestId;
  final DeliveryMethodModel method;

  /// Teklif ekranında seçilmiş, bu usulle getirilebilen kalemler.
  final List<SpecialOrderItemData> items;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<ApproveSpecialOrderCubit>(),
      child: _SpecialOrderApproveView(
        requestId: requestId,
        method: method,
        items: items,
      ),
    );
  }
}

class _SpecialOrderApproveView extends StatefulWidget {
  const _SpecialOrderApproveView({
    required this.requestId,
    required this.method,
    required this.items,
  });

  final int requestId;
  final DeliveryMethodModel method;
  final List<SpecialOrderItemData> items;

  @override
  State<_SpecialOrderApproveView> createState() =>
      _SpecialOrderApproveViewState();
}

class _SpecialOrderApproveViewState extends State<_SpecialOrderApproveView> {
  late final TextEditingController _addressController;
  late final TextEditingController _noteController;
  late final TextEditingController _welayatController;
  late final TextEditingController _etrapController;

  int? _selectedGiftId;
  int? _selectedWelayatId;
  int? _selectedEtrapId;
  double? _deliveryFee;

  /// Hediye paketi seçiliyse sabit ücret eklenir.
  double get _giftFee => _selectedGiftId == null ? 0 : kGiftPaperFee;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _noteController = TextEditingController();
    _welayatController = TextEditingController();
    _etrapController = TextEditingController();
    context.read<GiftCubit>().fetchGifts();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    _welayatController.dispose();
    _etrapController.dispose();
    super.dispose();
  }

  /// Σ (unitPrice × quantity) — yalnızca seçilen kalemler, seçilen usulün fiyatı.
  double get _productsTotal => widget.items
      .fold<double>(0, (sum, item) => sum + item.lineTotalFor(widget.method.id));

  /// toplam = ürünler + hediye paketi + etrap teslimat ücreti (§4).
  double get _totalAmount => _productsTotal + _giftFee + (_deliveryFee ?? 0);

  Future<void> _handleWelayatSelection() async {
    final result =
        await di<AppRouter>().push<Map<String, dynamic>>(const WelayatRoute());
    if (result == null || !mounted) return;
    setState(() {
      _selectedWelayatId = result['id'] as int;
      _welayatController.text = result['name'] as String;
      // Welayat değişince etrap ve teslimat ücreti sıfırlanır.
      _selectedEtrapId = null;
      _etrapController.clear();
      _deliveryFee = null;
    });
  }

  Future<void> _handleEtrapSelection() async {
    if (_selectedWelayatId == null) {
      NotificationHelper.showWarning(context, context.l10n.selectFirstProvince);
      return;
    }
    final result = await di<AppRouter>()
        .push<Map<String, dynamic>>(EtrapRoute(welayatId: _selectedWelayatId!));
    if (result == null || !mounted) return;
    setState(() {
      _selectedEtrapId = result['id'] as int;
      _etrapController.text = result['name'] as String;
      _deliveryFee = double.tryParse(result['price'] as String) ?? 0.0;
    });
  }

  bool _validate() {
    if (_selectedWelayatId == null) {
      NotificationHelper.showWarning(context, context.l10n.chooseProvince);
      return false;
    }
    if (_selectedEtrapId == null) {
      NotificationHelper.showWarning(context, context.l10n.chooseDistrict);
      return false;
    }
    if (_addressController.text.trim().isEmpty) {
      NotificationHelper.showWarning(context, context.l10n.addressIsRequired);
      return false;
    }
    if (widget.items.isEmpty) {
      NotificationHelper.showWarning(context, context.l10n.selectAtLeastOneBook);
      return false;
    }
    return true;
  }

  void _submit() {
    if (!_validate()) return;
    context.read<ApproveSpecialOrderCubit>().submit(
          widget.requestId,
          ApproveSpecialOrderRequest(
            methodId: widget.method.id,
            itemIds: widget.items.map((item) => item.id).toList(),
            etrapId: _selectedEtrapId,
            address: _addressController.text,
            desc: _noteController.text,
            giftCoverId: _selectedGiftId,
          ),
        );
  }

  Future<void> _onApproved(int orderId) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SuccessOrderDialog(),
    );
    if (!mounted) return;

    // Önce bu ekranı kapat ("onaylandı" bilgisiyle) — teklif ekranı kendini
    // tazeler — sonra yeni siparişin detayını aç.
    await di<AppRouter>().maybePop(true);
    di<AppRouter>().push(OrderDetailRoute(orderId: orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          context.l10n.approveQuote,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<ApproveSpecialOrderCubit, ApproveSpecialOrderState>(
        listener: (context, state) {
          if (state is ApproveSpecialOrderSuccess) {
            _onApproved(state.order.id);
          } else if (state is ApproveSpecialOrderFailure) {
            NotificationHelper.showError(
              context,
              // 400'ün tüm sebepleri "bu teklif artık onaylanamaz"a indirgenir;
              // kullanıcı için tek doğru aksiyon geri dönüp teklifi tazelemek.
              state.statusCode == 400
                  ? context.l10n.requestActionNotAllowed
                  : context.l10n.errorMessage,
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MethodSummary(method: widget.method),
              SizedBox(height: 16.h),
              _SelectedItems(items: widget.items, methodId: widget.method.id),
              SizedBox(height: 20.h),
              _SectionTitle(title: context.l10n.deliveryAddress),
              SizedBox(height: 8.h),
              CustomTextFormField(
                controller: _welayatController,
                isPrefix: false,
                isCalendar: false,
                isPassword: false,
                readOnly: true,
                hintText: context.l10n.chooseProvince,
                onTap: _handleWelayatSelection,
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                controller: _etrapController,
                isPrefix: false,
                isCalendar: false,
                isPassword: false,
                readOnly: true,
                hintText: context.l10n.chooseDistrict,
                onTap: _handleEtrapSelection,
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                controller: _addressController,
                isPrefix: false,
                isCalendar: false,
                isPassword: false,
                maxLines: 3,
                hintText: context.l10n.yourAdress,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                controller: _noteController,
                isPrefix: false,
                isCalendar: false,
                isPassword: false,
                maxLines: 3,
                hintText: context.l10n.note,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 20.h),
              _GiftSection(
                selectedGiftId: _selectedGiftId,
                onSelected: (gift) => setState(() {
                  // Tekrar tıklama seçimi kaldırır. Ücret paketten bağımsız
                  // sabittir — `kGiftPaperFee` (bkz. gift_model.dart).
                  _selectedGiftId = _selectedGiftId == gift.id ? null : gift.id;
                }),
              ),
              SizedBox(height: 20.h),
              _PriceRow(
                label: context.l10n.productsTotal,
                value: _productsTotal,
              ),
              if (_giftFee > 0)
                _PriceRow(label: context.l10n.giftPaper, value: _giftFee),
              if (_deliveryFee != null && _deliveryFee! > 0)
                _PriceRow(
                  label: context.l10n.deliveryFee,
                  value: _deliveryFee!,
                ),
              Divider(height: 24.h, color: Colors.grey[300]),
              _PriceRow(
                label: context.l10n.totalAmount,
                value: _totalAmount,
                isTotal: true,
              ),
              SizedBox(height: 10.h),
              // Kupon geçmez — kullanıcı kupon alanını aramasın (§4).
              Text(
                context.l10n.specialOrderNoCoupon,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 11.sp,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 15.h),
              BlocBuilder<ApproveSpecialOrderCubit, ApproveSpecialOrderState>(
                builder: (context, state) {
                  final isSubmitting = state is ApproveSpecialOrderSubmitting;
                  return CustomButton(
                    height: 35.h,
                    width: double.infinity,
                    backgroundColor: isSubmitting
                        ? Colors.grey
                        : CustomColors.orangeColor,
                    onTap: isSubmitting ? null : _submit,
                    child: isSubmitting
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            context.l10n.approveQuote,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  );
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _MethodSummary extends StatelessWidget {
  const _MethodSummary({required this.method});

  final DeliveryMethodModel method;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: CustomColors.orangeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined,
              size: 18.sp, color: CustomColors.orangeColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.deliveryMethodLabel,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  method.name,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            context.l10n.deliveryMethodDays(method.minDays, method.maxDays),
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: CustomColors.orangeColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedItems extends StatelessWidget {
  const _SelectedItems({required this.items, required this.methodId});

  final List<SpecialOrderItemData> items;
  final int methodId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        final imagePath = item.book != null && item.book!.images.isNotEmpty
            ? item.book!.images.first.path
            : null;
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: SizedBox(
                  width: 40.w,
                  height: 56.h,
                  child: imagePath == null
                      ? Container(color: Colors.grey[200])
                      : CachedNetworkImage(
                          imageUrl: '${BaseUrl.baseUrl}$imagePath',
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
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
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${item.priceFor(methodId)?.unitPrice ?? '0'} m. × ${item.quantity}',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${item.lineTotalFor(methodId).toStringAsFixed(2)} m.',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.orangeColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Hediye paketi seçimi. Ücret `GiftModel.price` üzerinden hesaplanır.
class _GiftSection extends StatelessWidget {
  const _GiftSection({required this.selectedGiftId, required this.onSelected});

  final int? selectedGiftId;
  final ValueChanged<GiftModel> onSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GiftCubit, GiftState>(
      builder: (context, state) {
        if (state is! GiftLoaded || state.gifts.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.giftPaper,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 80.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.gifts.length,
                itemBuilder: (context, index) {
                  final gift = state.gifts[index];
                  final isSelected = selectedGiftId == gift.id;
                  return GestureDetector(
                    onTap: () => onSelected(gift),
                    child: Container(
                      width: 70.w,
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected
                              ? CustomColors.orangeColor
                              : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7.r),
                        child: CachedNetworkImage(
                          imageUrl: '${BaseUrl.baseUrl}${gift.image}',
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              Container(color: Colors.grey[200]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
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

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final double value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: isTotal ? 15.sp : 13.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} m.',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: isTotal ? 17.sp : 13.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? CustomColors.orangeColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
