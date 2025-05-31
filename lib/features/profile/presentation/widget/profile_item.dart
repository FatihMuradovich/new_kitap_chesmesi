import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    this.ontap,
  });
  final String icon;
  final String title;
  final Function()? ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Card(
        // color: Colors.grey[100],
        color: const Color(0xFFFAFAFA),
        elevation: 0.3,
        child: Container(
          height: 40.h,
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 20.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    icon,
                  ),
                )),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Poppins-regular',
                  //fontWeight: FontWeight.bold,
                  color: const Color(0xFF282846),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
