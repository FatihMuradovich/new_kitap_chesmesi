import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cubit.dart';
import '../../../../../book/domain/model/book_model.dart';

// ignore: must_be_immutable
class CartItem extends StatefulWidget {
  BookModel book;

  CartItem({super.key, required this.book});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[50],
              ),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image(
                  fit: BoxFit.cover,
                  image: widget.book.backgroundImageHard == null
                      ? AssetImage('assets/images/1.png')
                      : NetworkImage(widget.book.backgroundImageHard ?? ''),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.book.name,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Poppins-black',
                          fontSize: 14.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<OrderCubit>().removeOrder(widget.book);
                        },
                        child: Icon(
                          Icons.cancel,
                          color: CustomColors.orangeColor,
                          size: 16.h,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Text(
                      widget.book.author,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: widget.book.priceHardcover.toString(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF282846),
                            fontSize: 14.sp,
                          ),
                          children: [
                            TextSpan(
                              text: ' TMT',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF282846),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<OrderCubit>()
                                    .decreaseQuantity(widget.book);
                                quantity--;
                                setState(() {});
                              },
                              child: Icon(
                                FluentSystemIcons.ic_fluent_remove_filled,
                                color: CustomColors.blueColor,
                                size: 14.h,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '$quantity',
                              style: TextStyle(
                                color: CustomColors.blueColor,
                                fontFamily: 'Poppins-black',
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<OrderCubit>()
                                    .increaseQuantity(widget.book);
                                quantity++;
                                setState(() {});
                              },
                              child: Icon(
                                FluentSystemIcons.ic_fluent_add_filled,
                                color: CustomColors.blueColor,
                                size: 14.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
