import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/core/utils/animate_route.dart';
import 'package:new_kitap_chesmesi/features/navBar/cubit/nav_bar_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/page/order_page.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class OrderBottom extends StatelessWidget {
  final String? totalOrderPrice;
  final int? bookCount;
  // final List<CartItemModel> cartItems;
  const OrderBottom({
    super.key,
    this.totalOrderPrice,
    this.bookCount,
    // required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return bookCount != null
        ? Container(
          height: 55.h,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),

            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -10),
                blurRadius: 20,
                // ignore: deprecated_member_use
                color: const Color(0xFFDADADA).withOpacity(0.10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${context.l10n.amount}:',
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: totalOrderPrice,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: const Color(0xFFFF9E0D),
                            ),
                            children: [
                              TextSpan(
                                text: ' TMT',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    158,
                                    13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: CustomButton(
                    backgroundColor: CustomColors.orangeColor,
                    onTap: () {
                      // List<Map<String, dynamic>> orderList =
                      //     cartItems.map((item) => item.toJson()).toList();
                      context.read<NavBarCubit>().hideNavBar();
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => OrderPage(),
                            ),
                          )
                          .then((_) {
                            // Geri dönüldüğünde navbar tekrar gösterilir
                            context.read<NavBarCubit>().showNavBar();
                          });
                      // context.read<NavBarCubit>().hideNavBar();
                      // Navigator.of(
                      //   context,
                      // ).push(createFadeRoute(OrderPage())).then((_) {
                      //   context.read<NavBarCubit>().showNavBar();
                      // });
                    },
                    height: 40.w,
                    child: Text(
                      'Sargyt et',
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
        )
        : const SizedBox();
  }
}
