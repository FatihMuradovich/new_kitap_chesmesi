import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/common/constants/base_url.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/delivery_method_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/create_special_order/create_special_order_cubit.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/create_special_order/create_special_order_state.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/delivery_method/delivery_method_cubit.dart';
import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/delivery_method/delivery_method_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

/// Kitap detayından özel sipariş talebi açma sheet'i (SPECIAL-ORDER-API.md §7).
///
/// Talep başarıyla açılırsa `true` döner — çağıran ekran buna göre geri bildirim
/// gösterebilir.
Future<bool?> showSpecialOrderSheet(BuildContext context, BookModel book) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => BlocProvider(
      create: (_) => di<CreateSpecialOrderCubit>(),
      child: _SpecialOrderSheet(book: book),
    ),
  );
}

class _SpecialOrderSheet extends StatefulWidget {
  const _SpecialOrderSheet({required this.book});

  final BookModel book;

  @override
  State<_SpecialOrderSheet> createState() => _SpecialOrderSheetState();
}

class _SpecialOrderSheetState extends State<_SpecialOrderSheet> {
  final TextEditingController _noteController = TextEditingController();
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // Usuller sheet'te sadece bilgi amaçlı ("uçakla 7–14 gün") — seçim
    // teklif geldikten sonra yapılır.
    di<DeliveryMethodCubit>().loadIfNeeded();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  /// 400'ün üç sebebi var (§4); backend mesajı teknik olduğu için anahtar
  /// kelimeye bakıp lokalize metni seçiyoruz, bulamazsak genel metne düşüyoruz.
  String _failureMessage(BuildContext context, CreateSpecialOrderFailure state) {
    final raw = state.rawMessage?.toLowerCase() ?? '';
    if (raw.contains('already')) return context.l10n.bookAlreadyInOpenRequest;
    if (raw.contains('special') || raw.contains('stock')) {
      return context.l10n.bookNotSpecialOrderable;
    }
    return context.l10n.specialOrderCreateFailed;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateSpecialOrderCubit, CreateSpecialOrderState>(
      listener: (context, state) {
        if (state is CreateSpecialOrderSuccess) {
          Navigator.of(context).pop(true);
        } else if (state is CreateSpecialOrderFailure) {
          NotificationHelper.showError(context, _failureMessage(context, state));
        }
      },
      child: Padding(
        // Klavye açıldığında not alanı görünür kalsın.
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  context.l10n.specialOrderSheetTitle,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  context.l10n.specialOrderSheetInfo,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16.h),
                _BookSummary(book: widget.book),
                SizedBox(height: 16.h),
                const _DeliveryMethodHints(),
                SizedBox(height: 16.h),
                _QuantityRow(
                  quantity: _quantity,
                  onChanged: (value) => setState(() => _quantity = value),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: _noteController,
                  maxLines: 2,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: context.l10n.specialOrderNoteHint,
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  ),
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                BlocBuilder<CreateSpecialOrderCubit, CreateSpecialOrderState>(
                  builder: (context, state) {
                    final isSubmitting = state is CreateSpecialOrderSubmitting;
                    return CustomButton(
                      height: 45.h,
                      width: double.infinity,
                      backgroundColor: isSubmitting
                          ? Colors.grey
                          : CustomColors.orangeColor,
                      onTap: isSubmitting
                          ? null
                          : () => context
                              .read<CreateSpecialOrderCubit>()
                              .submit(
                                bookId: widget.book.id,
                                quantity: _quantity,
                                note: _noteController.text,
                              ),
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
                              context.l10n.sendRequest,
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookSummary extends StatelessWidget {
  const _BookSummary({required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    final imagePath = book.images.isNotEmpty ? book.images.first.path : null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: SizedBox(
            width: 46.w,
            height: 64.h,
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
                book.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (book.author != null) ...[
                SizedBox(height: 3.h),
                Text(
                  book.author!.name,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// "Uçar bilen 7–14 gün · Ýük ulagy bilen 25–45 gün" bilgi satırları.
/// Uçlar yüklenemezse bölüm tamamen gizlenir — talep açmayı engellemez.
class _DeliveryMethodHints extends StatelessWidget {
  const _DeliveryMethodHints();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryMethodCubit, DeliveryMethodState>(
      bloc: di<DeliveryMethodCubit>(),
      builder: (context, state) {
        if (state is! DeliveryMethodLoaded) return const SizedBox.shrink();
        final methods =
            state.methods.where((method) => method.active).toList();
        if (methods.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: CustomColors.orangeColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: methods.map((method) => _hintRow(context, method)).toList(),
          ),
        );
      },
    );
  }

  Widget _hintRow(BuildContext context, DeliveryMethodModel method) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined,
              size: 14.sp, color: CustomColors.orangeColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              method.name,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 12.sp,
              ),
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

class _QuantityRow extends StatelessWidget {
  const _QuantityRow({required this.quantity, required this.onChanged});

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          context.l10n.quantity,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        _StepButton(
          icon: Icons.remove,
          // Stok kısıtı yok — talep, adet üst sınırı backend'de.
          onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Text(
            '$quantity',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _StepButton(
          icon: Icons.add,
          onTap: quantity < 99 ? () => onChanged(quantity + 1) : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: enabled ? CustomColors.orangeColor : Colors.grey[300]!,
          ),
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: enabled ? CustomColors.orangeColor : Colors.grey[400],
        ),
      ),
    );
  }
}
