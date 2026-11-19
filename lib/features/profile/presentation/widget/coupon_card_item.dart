import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/model/coupon_model.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class CouponCardItem extends StatelessWidget {
  final CouponModel coupon;

  const CouponCardItem({
    super.key,
    required this.coupon,
  });

  void _copyCouponCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: coupon.coupon));
    NotificationHelper.showSuccess(context, context.l10n.couponCopied);
  }

  @override
  Widget build(BuildContext context) {
    final isActive = coupon.active;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [
                  CustomColors.orangeColor.withValues(alpha: 0.7),
                  CustomColors.orangeColor
                ]
              : [Colors.grey[350]!, Colors.grey[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: isActive ? Colors.white : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    coupon.type == 'holiday'
                        ? context.l10n.couponTypeHoliday
                        : coupon.type == 'birthday'
                            ? context.l10n.couponTypeBirthday
                            : context.l10n.couponTypeOther,
                    style: TextStyle(
                      color: isActive
                          ? CustomColors.orangeColor
                          : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      fontFamily: 'Poppins-regular',
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green[600] : Colors.grey[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? context.l10n.active : context.l10n.passive,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                      fontFamily: 'Poppins-regular',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.discountRate,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[200],
                        fontFamily: 'Poppins-regular',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '%${coupon.percent}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[100],
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      context.l10n.couponCode,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[200],
                        fontSize: 12.sp,
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: isActive ? () => _copyCouponCode(context) : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.grey[300]!.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isActive
                                ? Colors.white.withValues(alpha: 0.3)
                                : Colors.grey[300]!.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              coupon.coupon,
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.grey[100],
                                // ignore: deprecated_member_use
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                            if (isActive) ...[
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.copy,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.created,
                  style: TextStyle(
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.grey[300],
                    fontSize: 12.sp,
                    fontFamily: 'Poppins-regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatDate(coupon.createdAt),
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.grey[300],
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
