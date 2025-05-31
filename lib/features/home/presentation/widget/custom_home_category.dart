// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomHomeCategory extends StatelessWidget {
  String title;
  VoidCallback onTap;
  CustomHomeCategory({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontFamily: 'Poppins-regular', fontSize: 16.sp),
          ),
          GestureDetector(
            onTap: onTap,
            child: Icon(
              FluentSystemIcons.ic_fluent_chevron_right_filled,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
