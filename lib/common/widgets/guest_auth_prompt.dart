import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class GuestAuthPrompt extends StatelessWidget {
  const GuestAuthPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.registerOderSignUp,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  di<AppRouter>().push(const RegisterRoute());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.orangeColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  context.l10n.register,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  di<AppRouter>().push(const LoginRoute());
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  side: BorderSide(color: CustomColors.orangeColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  context.l10n.signIn,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.orangeColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
