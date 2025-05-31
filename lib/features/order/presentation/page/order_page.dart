import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';

// ignore: must_be_immutable
class OrderPage extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sargyt et')),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            CustomTextFormField(
              controller: nameController,
              isPrefix: false,
              isCalendar: false,
              hintText: 'Adyňyz',
              isPassword: false,
            ),
            SizedBox(height: 10.h),
            CustomTextFormField(
              controller: phoneController,
              isPrefix: false,
              isCalendar: false,
              hintText: 'Telefon belginiz',
              isPassword: false,
            ),
            SizedBox(height: 10.h),
            CustomTextFormField(
              controller: phoneController,
              isPrefix: false,
              isCalendar: false,
              hintText: 'Salgyňyz',
              maxLines: 3,
              isPassword: false,
            ),
            SizedBox(height: 10.h),
            CustomButton(
              width: double.infinity,
              backgroundColor: CustomColors.orangeColor,
              child: Text(
                'Sargydy tamamla',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14.sp,
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
