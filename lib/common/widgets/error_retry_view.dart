import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

/// Sayfa içeriği yüklenemediğinde tam sayfa hata + "tekrar dene".
/// Tüm sayfalarda aynı görünüm için tek yerden kullanılır.
class ErrorRetryView extends StatelessWidget {
  const ErrorRetryView({super.key, required this.onRetry, this.message});

  final VoidCallback onRetry;

  /// Açıklama satırı; verilmezse "internet bağlantınızı kontrol edin".
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 56.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              context.l10n.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message ?? context.l10n.noInternetMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 13.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.orangeColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                context.l10n.tryAgain,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sayfanın bir bölümü yüklenemediğinde tek satırlık, az yer kaplayan uyarı.
class InlineErrorBanner extends StatelessWidget {
  const InlineErrorBanner({super.key, required this.onRetry, this.margin});

  final VoidCallback onRetry;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.only(left: 12.w, right: 4.w, top: 4.h, bottom: 4.h),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              context.l10n.errorMessage,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 13.sp,
                fontFamily: 'Poppins-regular',
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              context.l10n.tryAgain,
              style: TextStyle(
                color: CustomColors.orangeColor,
                fontSize: 13.sp,
                fontFamily: 'Poppins-regular',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
