// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginRegisterButton extends StatelessWidget {
  double? height;
  double? width;
  Widget child;
  Color backgroundColor;
  Function()? onTap;

  LoginRegisterButton({
    super.key,
    this.height,
    this.width,
    required this.child,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onTap ?? () {},
        child: child,
      ),
    );
  }
}
