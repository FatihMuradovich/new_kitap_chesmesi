import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/base_url.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/cart_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/gift_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/order_model.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/gift/gift_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/gift/gift_state.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/order/order_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/order/order_state.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/widget/success_order_dialog.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/coupon/coupon_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/coupon/coupon_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class OrderPage extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final double totalPrice;

  const OrderPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // Controllers
  late final TextEditingController _addressController;
  late final TextEditingController _noteController;
  late final TextEditingController _couponController;
  late final TextEditingController _welayatController;
  late final TextEditingController _etrapController;

  // State variables
  int? _selectedGiftId;
  int? _selectedWelayatId;
  int? _selectedEtrapId;
  double? _deliveryFee;
  int? _appliedCouponPercent;

  // Constants
  static const double _giftPaperFee = kGiftPaperFee;

  /// Sepette en az bir indirimli kitap varsa kupon kullanılamaz.
  bool get _couponBlockedByDiscount =>
      widget.cartItems.any((item) => item.hasCatalogDiscount);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (_couponBlockedByDiscount) {
      _appliedCouponPercent = null;
      _couponController.clear();
    }
    _loadInitialData();
  }

  void _initializeControllers() {
    _addressController = TextEditingController();
    _noteController = TextEditingController();
    _couponController = TextEditingController();
    _welayatController = TextEditingController();
    _etrapController = TextEditingController();
  }

  void _loadInitialData() {
    context.read<GiftCubit>().fetchGifts();
    context.read<CouponCubit>().loadUserCoupons();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    _couponController.dispose();
    _welayatController.dispose();
    _etrapController.dispose();
    super.dispose();
  }

  // Kupon indirimi tutarı
  double get _couponDiscount {
    if (_couponBlockedByDiscount) return 0.0;
    if (_appliedCouponPercent != null && _appliedCouponPercent! > 0) {
      return widget.totalPrice * _appliedCouponPercent! / 100;
    }
    return 0.0;
  }

  // Kupon uygulandıktan sonra kitap fiyatı
  double get _priceAfterCoupon {
    return widget.totalPrice - _couponDiscount;
  }

  double get _totalAmount {
    double total = _priceAfterCoupon;
    if (_deliveryFee != null) {
      total += _deliveryFee!;
    }
    if (_selectedGiftId != null) {
      total += _giftPaperFee;
    }
    return total;
  }

  // Helper Methods
  Future<void> _pasteCouponCode() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (!mounted) return;
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        _couponController.text = clipboardData.text!;
      });
      NotificationHelper.showSuccess(
        context,
        context.l10n.couponCopied,
      );
    } else {
      NotificationHelper.showError(
        context,
        'Göçürmek panelinde hiç bir zat ýok!',
      );
    }
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor ?? Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleWelayatSelection() async {
    final result = await di<AppRouter>().push<Map<String, dynamic>>(
      const WelayatRoute(),
    );

    if (result != null) {
      setState(() {
        _selectedWelayatId = result['id'] as int;
        _welayatController.text = result['name'] as String;
        // Reset etrap selection when welayat changes
        _selectedEtrapId = null;
        _etrapController.clear();
        _deliveryFee = null;
      });
    }
  }

  Future<void> _handleEtrapSelection() async {
    if (_selectedWelayatId == null) {
      NotificationHelper.showWarning(
        context,
        context.l10n.selectFirstProvince,
      );
      return;
    }

    final result = await di<AppRouter>().push<Map<String, dynamic>>(
      EtrapRoute(welayatId: _selectedWelayatId!),
    );

    if (result != null) {
      setState(() {
        _selectedEtrapId = result['id'] as int;
        _etrapController.text = result['name'] as String;
        _deliveryFee = double.tryParse(result['price'] as String) ?? 0.0;
      });
    }
  }

  bool _validateOrder() {
    if (_selectedWelayatId == null) {
      _showSnackBar(context.l10n.chooseProvince);
      return false;
    }

    if (_selectedEtrapId == null) {
      _showSnackBar(context.l10n.chooseDistrict);
      return false;
    }

    if (_addressController.text.trim().isEmpty) {
      _showSnackBar(context.l10n.addressIsRequired);
      return false;
    }

    return true;
  }

  bool _validateCoupon(String couponCode) {
    if (_couponBlockedByDiscount) return false;
    final couponState = context.read<CouponCubit>().state;
    if (couponState is CouponLoaded) {
      try {
        final validCoupon = couponState.coupons.firstWhere(
          (coupon) => coupon.coupon == couponCode && coupon.active,
        );

        // Kupon geçerliyse yüzde değerini kaydet
        setState(() {
          _appliedCouponPercent = validCoupon.percent;
        });
        return true;
      } catch (e) {
        _showSnackBar(context.l10n.invalidCoupon);
        setState(() {
          _appliedCouponPercent = null;
        });
        return false;
      }
    } else {
      _showSnackBar(context.l10n.couponError);
      setState(() {
        _appliedCouponPercent = null;
      });
      return false;
    }
  }

  Future<void> _submitOrder() async {
    if (!_validateOrder()) return;

    final couponRaw = _couponController.text.trim();
    final couponCode =
        _couponBlockedByDiscount || couponRaw.isEmpty ? null : couponRaw;

    final orderItems = widget.cartItems
        .map((cartItem) => OrderItem(
              bookId: cartItem.id,
              quantity: cartItem.quantity,
            ))
        .toList();

    final orderRequest = OrderRequest(
      address: _addressController.text.trim(),
      giftCoverId: _selectedGiftId,
      coupon: couponCode,
      desc: _noteController.text.trim().isNotEmpty
          ? _noteController.text.trim()
          : null,
      etrapId: _selectedEtrapId,
      items: orderItems,
    );

    try {
      context.read<OrderCubit>().createOrder(orderRequest);
    } catch (e) {
      _showSnackBar(context.l10n.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.completeOrder),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationSection(),
            SizedBox(height: 10.h),
            _buildGiftSection(),
            SizedBox(height: 10.h),
            _buildPriceSection(),
            SizedBox(height: 10.h),
            _buildOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          controller: _welayatController,
          isPrefix: false,
          isCalendar: false,
          hintText: context.l10n.chooseProvince,
          isPassword: false,
          readOnly: true,
          onTap: _handleWelayatSelection,
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          controller: _etrapController,
          isPrefix: false,
          isCalendar: false,
          hintText: context.l10n.chooseDistrict,
          isPassword: false,
          readOnly: true,
          onTap: _handleEtrapSelection,
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          textInputAction: TextInputAction.done,
          controller: _addressController,
          isPrefix: false,
          isCalendar: false,
          hintText: context.l10n.yourAdress,
          maxLines: 3,
          isPassword: false,
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          textInputAction: TextInputAction.done,
          controller: _noteController,
          isPrefix: false,
          isCalendar: false,
          hintText: context.l10n.note,
          maxLines: 3,
          isPassword: false,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                textInputAction: TextInputAction.done,
                controller: _couponController,
                isPrefix: false,
                isCalendar: false,
                hintText: context.l10n.couponCode,
                maxLines: 1,
                isPassword: false,
                enabled: !_couponBlockedByDiscount,
                suffixIcon: IconButton(
                  onPressed: _couponBlockedByDiscount ? null : _pasteCouponCode,
                  icon: Icon(Icons.paste),
                  color: _couponBlockedByDiscount
                      ? Colors.grey
                      : CustomColors.orangeColor,
                ),
                onChanged: (value) {
                  // Kupon alanı değiştiğinde uygulanmış kuponu temizle
                  if (_appliedCouponPercent != null) {
                    setState(() {
                      _appliedCouponPercent = null;
                    });
                  }
                },
              ),
            ),
            SizedBox(width: 8.w),
            ElevatedButton(
              onPressed: _couponBlockedByDiscount
                  ? null
                  : () {
                      final couponCode = _couponController.text.trim();
                      if (couponCode.isEmpty) {
                        NotificationHelper.showWarning(
                          context,
                          context.l10n.enterCouponCode,
                        );
                        return;
                      }
                      if (_validateCoupon(couponCode)) {
                        NotificationHelper.showSuccess(
                          context,
                          context.l10n.couponUsed,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.orangeColor,
                disabledBackgroundColor: Colors.grey.shade400,
                disabledForegroundColor: Colors.white70,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                context.l10n.use,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        if (_couponBlockedByDiscount) ...[
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: CustomColors.orangeColor,
                size: 20,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  context.l10n.couponNotAllowedWithBookDiscount,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: CustomColors.orangeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (_appliedCouponPercent != null && !_couponBlockedByDiscount) ...[
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.green, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    context.l10n.couponUsed,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 12.sp,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGiftSection() {
    return BlocBuilder<GiftCubit, GiftState>(
      builder: (context, state) {
        if (state is GiftLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: CustomColors.orangeColor,
            ),
          );
        }
        if (state is GiftLoaded && state.gifts.isNotEmpty) {
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
              SizedBox(height: 5.h),
              SizedBox(
                height: 80.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.gifts.length,
                  itemBuilder: (context, index) {
                    final gift = state.gifts[index];
                    final isSelected = _selectedGiftId == gift.id;
                    return _GiftItem(
                      gift: gift,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedGiftId = isSelected ? null : gift.id;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPriceSection() {
    return Column(
      children: [
        _PriceRow(
          label: context.l10n.priceOfBooks,
          value: widget.totalPrice,
        ),
        if (!_couponBlockedByDiscount &&
            _appliedCouponPercent != null &&
            _couponDiscount > 0) ...[
          _PriceRow(
            label: '${context.l10n.couponDiscount} (%$_appliedCouponPercent)',
            value: -_couponDiscount,
            isDiscount: true,
          ),
          Divider(thickness: 0.5, color: Colors.grey[300], height: 8.h),
          _PriceRow(
            label: context.l10n.subtotal,
            value: _priceAfterCoupon,
            isSubtotal: true,
          ),
        ],
        if (_deliveryFee != null) ...[
          _PriceRow(
            label: context.l10n.deliveryFee,
            value: _deliveryFee!,
          ),
        ],
        if (_selectedGiftId != null) ...[
          _PriceRow(
            label: context.l10n.giftPaperFee,
            value: _giftPaperFee,
          ),
        ],
        Divider(thickness: 1, color: Colors.grey[300]),
        _PriceRow(
          label: context.l10n.totalAmount,
          value: _totalAmount,
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildOrderButton() {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) async {
        if (state is OrderSuccess) {
          context.read<CartCubit>().clearCart();

          // Ana sayfadaki kitap listesini sessizce güncelle (stokta tükenen kitapları kaldır)
          context.read<HomeCubit>().loadHomeData(silentRefresh: true);

          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => const SuccessOrderDialog(),
          );

          // Dialog kapatıldıktan sonra order page'i de kapat
          if (context.mounted) {
            Navigator.of(context).pop(true);
          }
        } else if (state is OrderError) {
          _showSnackBar(context.l10n.errorMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is OrderLoading;
        return CustomButton(
          onTap: isLoading ? null : _submitOrder,
          width: double.infinity,
          backgroundColor: isLoading ? Colors.grey : CustomColors.orangeColor,
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      context.l10n.orderLoading,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Text(
                  context.l10n.completeOrder,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }
}

// Extracted Widgets
class _GiftItem extends StatelessWidget {
  final dynamic gift;
  final bool isSelected;
  final VoidCallback onTap;

  const _GiftItem({
    required this.gift,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isSelected ? CustomColors.orangeColor : Colors.transparent,
                width: 3,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: '${BaseUrl.baseUrl}${gift.image}',
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
                if (isSelected)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: CustomColors.orangeColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;
  final bool isDiscount;
  final bool isSubtotal;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isDiscount = false,
    this.isSubtotal = false,
  });

  @override
  Widget build(BuildContext context) {
    Color valueColor = CustomColors.orangeColor;
    if (isDiscount) {
      valueColor = Colors.green;
    } else if (isSubtotal) {
      valueColor = Colors.blueGrey;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: isTotal ? 16.sp : 14.sp,
                fontWeight:
                    isTotal || isSubtotal ? FontWeight.bold : FontWeight.w500,
                color: isDiscount ? Colors.green[700] : Colors.black,
              ),
            ),
          ),
          Text(
            value < 0
                ? '${value.toStringAsFixed(2)} m.'
                : '${value.toStringAsFixed(2)} m.',
            style: TextStyle(
              color: valueColor,
              fontFamily: 'Poppins-regular',
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
