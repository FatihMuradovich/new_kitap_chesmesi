// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cubit.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

// ignore: must_be_immutable
class DetailBottomBar extends StatelessWidget {
  final BookModel book;
  const DetailBottomBar({super.key,required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.w,
      decoration: BoxDecoration(border: Border.all(width: 0.1)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 6.h),
                  Text(
                    'Bahasy:  ',
                    style: TextStyle(
                      color: CustomColors.orangeColor,
                      fontSize: 16.sp,
                      fontFamily: 'Poppins-black',
                    ),
                  ),
                  Text(
                    '100 TMT',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: CustomButton(
                backgroundColor: CustomColors.orangeColor,
                onTap: () {
                  context.read<OrderCubit>().addOrder(book);
                },
                child: Text(
                  context.l10n.add_cart,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
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
