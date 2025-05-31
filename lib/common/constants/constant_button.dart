import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';

class ConstantsButtonStyle {
  static ButtonStyle elevatedButtonStyleOrange = ElevatedButton.styleFrom(
    elevation: 0.5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: CustomColors.orangeColor,
    padding: const EdgeInsets.all(10),
    fixedSize: Size(250.w, 40.h),
  );

  static ButtonStyle elevatedButtonStyleBlue = ElevatedButton.styleFrom(
    elevation: 0.5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: CustomColors.blueColor,
    padding: const EdgeInsets.all(10),
    fixedSize: Size(250.w, 40.h),
  );
}
