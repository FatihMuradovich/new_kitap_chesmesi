// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_kitap_chesmesi/common/constants/customn_icons.dart';

// ignore: must_be_immutable
class CategoryItem extends StatelessWidget {
  Function() ontap;
  String title;
  CategoryItem({
    Key? key,
    required this.ontap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: const Color(0xFFFAFAFA),
        elevation: 0.3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Poppins-regular',
                ),
              ),
              CustomIcons.rightChevron,
            ],
          ),
        ),
      ),
    );
  }
}
