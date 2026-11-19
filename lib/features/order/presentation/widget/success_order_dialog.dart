import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class SuccessOrderDialog extends StatelessWidget {
  const SuccessOrderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        padding: EdgeInsets.all(30.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),
            ),
            SizedBox(height: 15.h),

            // Title
            Text(
              context.l10n.orderSuccess,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 15.h),
            CustomButton(
              width: double.infinity,
              backgroundColor: CustomColors.orangeColor,
              onTap: () {
                Navigator.of(context).pop(); // Close dialog only
              },
              child: Text(
                context.l10n.goIt,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Go It Button
            // SizedBox(
            //   width: double.infinity,
            //   height: 50.h,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.of(context).pop(); // Dialog'u kapat
            //       // Navigator.of(context).pop(); // Order sayfasını kapat
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: CustomColors.orangeColor,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(25.r),
            //       ),
            //       elevation: 0,
            //     ),
            //     child: Text(
            //       context.l10n.goIt,
            //       style: TextStyle(
            //         fontFamily: 'Poppins-regular',
            //         fontSize: 16.sp,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
