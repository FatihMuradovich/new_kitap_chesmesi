import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/base_url.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/cart_model.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';

class CartItem extends StatelessWidget {
  final CartItemModel cartItem;

  const CartItem({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 65.h,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: cartItem.images.isNotEmpty
                        ? Image.network(
                            '${BaseUrl.baseUrl}${cartItem.images.first.path}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Placeholder();
                            },
                          )
                        : const Placeholder(),
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
                        SizedBox(
                          width: 160.w,
                          child: Text(
                            cartItem.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<CartCubit>()
                                .confirmRemoveFromCart(cartItem.id);
                          },
                          child: Icon(
                            Icons.cancel,
                            color: CustomColors.blueColor,
                            size: 16.h,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      cartItem.author?.name ?? 'Yazar belirtilmemiş',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${cartItem.discountedPrice.toStringAsFixed(2)} m.',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF282846),
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            if (cartItem.discountedPrice < cartItem.priceValue)
                              Text(
                                '${cartItem.priceValue.toStringAsFixed(2)} m.',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: Colors.grey,
                                  fontSize: 12.sp,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        BlocBuilder<CartCubit, CartState>(
                          builder: (context, state) {
                            final canIncrease =
                                cartItem.quantity < cartItem.stock;
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<CartCubit>()
                                        .decreaseQuantityWithCheck(cartItem);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: CustomColors.orangeColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.2),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 12.h,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '${cartItem.quantity}',
                                  style: TextStyle(
                                    color: CustomColors.blueColor,
                                    fontFamily: 'Poppins-black',
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                GestureDetector(
                                  onTap: () {
                                    if (!canIncrease) return;
                                    context
                                        .read<CartCubit>()
                                        .increaseQuantityWithStockCheck(
                                            cartItem);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      // color = CustomColors.orangeColor,
                                      color: (!canIncrease)
                                          ? Colors.grey
                                          : CustomColors.orangeColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.2),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 12.h,
                                      ),
                                    ),
                                    // borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            );
                          },
                        )
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
