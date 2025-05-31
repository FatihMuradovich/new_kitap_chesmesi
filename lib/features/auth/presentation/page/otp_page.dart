import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';

// ignore: must_be_immutable
class OtpPage extends StatelessWidget {
  TextEditingController input = TextEditingController();
  OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tassyklama kody',
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              '+993 64778240 belgä ugradylan Otp tassyklama koduny giriziň',
              style: TextStyle(fontFamily: 'Poppins-regular', fontSize: 14.sp),
            ),

            SizedBox(height: 50.h),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  inputOtp(context),
                  inputOtp(context),
                  inputOtp(context),
                  inputOtp(context),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kody almadyňyzmy?',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 20.w),
                TweenAnimationBuilder(
                  tween: Tween(begin: 60.0, end: 0),
                  duration: Duration(seconds: 60),
                  builder: (context, value, child) {
                    return Text(
                      '00:${value.toInt()}',
                      style: TextStyle(
                        color: CustomColors.orangeColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-regular',
                        fontSize: 16.sp,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox inputOtp(BuildContext context) {
    return SizedBox(
      height: 68.h,
      width: 64.w,

      child: CustomTextFormField(
        inputType: TextInputType.number,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        align: TextAlign.center,
        formatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        controller: input,
        isPrefix: false,
        isCalendar: false, isPassword: false,
      ),
    );
  }
}
