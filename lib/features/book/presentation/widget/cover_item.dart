// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CoverItem extends StatelessWidget {
  String title;
  Color color;
  VoidCallback onTap;
  CoverItem({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 30.h,

        decoration: BoxDecoration(border: Border.all(width: 1, color: color)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
