// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/common/utils/auth_guard.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

// ignore: must_be_immutable
class DetailBottomBar extends StatelessWidget {
  final BookModel book;
  const DetailBottomBar({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = book.hasDiscount;

    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartItemAdded) {
          NotificationHelper.showSuccess(
            context,
            context.l10n.productAddedToCart,
          );
        } else if (state is CartError) {
          NotificationHelper.showError(
            context,
            state.message.contains('Stokta') || state.message.contains('stok')
                ? state.message
                : context.l10n.errorMessage,
          );
        }
      },
      child: Container(
        height: 80.w,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Fiyatı olmayan (`Finished`) kitapta fiyat bloğu hiç çizilmez —
              // yerine yazı koymak yerine butonu tüm genişliğe bırakıyoruz (§4).
              if (book.hasPrice) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.h),
                    Text(
                      '${context.l10n.price}:  ',
                      style: TextStyle(
                        color: CustomColors.orangeColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                    hasDiscount
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${book.discountedPrice.toStringAsFixed(2)} m.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${book.priceValue.toStringAsFixed(2)} m.',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                  fontFamily: 'Poppins-regular',
                                ),
                              ),
                            ],
                          )
                        : Text(
                            '${book.priceValue.toStringAsFixed(2)} m.',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins-regular',
                            ),
                          ),
                  ],
                ),
                SizedBox(width: 10.w),
              ],
              // ÖZEL SİPARİŞ — geçici olarak kapatıldı. Açılınca burada
              // `book.isSpecialOrderable` ise `_SpecialOrderButton` çizilir.
              Expanded(
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    final isLoading = state is CartItemAdding;

                    // Sepetteki mevcut miktarı bul
                    int currentQuantityInCart = 0;
                    if (state is CartLoaded) {
                      try {
                        final cartItem = state.cartItems.firstWhere(
                          (item) => item.id == book.id,
                        );
                        currentQuantityInCart = cartItem.quantity;
                      } catch (e) {
                        // Sepette bu kitap yok
                        currentQuantityInCart = 0;
                      }
                    }

                    // Stok kontrolü
                    final canAddToCart =
                        book.stock > 0 && currentQuantityInCart < book.stock;
                    String buttonText;

                    if (book.stock == 0) {
                      buttonText = context.l10n.outOfStock;
                    } else if (currentQuantityInCart >= book.stock) {
                      buttonText = context.l10n.stockIsEmpty;
                      // buttonText = 'Stok doldy! (${currentQuantityInCart}/${book.stock})';
                    } else if (currentQuantityInCart > 0) {
                      buttonText =
                          '${context.l10n.add_cart} ($currentQuantityInCart/${book.stock})';
                    } else {
                      buttonText = context.l10n.add_cart;
                    }

                    return CustomButton(
                      backgroundColor: isLoading
                          ? Colors.grey
                          : (canAddToCart
                              ? CustomColors.orangeColor
                              : Colors.grey),
                      onTap: (isLoading || !canAddToCart)
                          ? null
                          : () async {
                              final ok = await ensureLoggedIn(context);
                              if (!ok) return;
                              // Login ise sepete ekle
                              // ignore: use_build_context_synchronously
                              context.read<CartCubit>().addToCart(book.id, 1);
                            },
                      child: isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              buttonText,
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    (currentQuantityInCart > 0 || !canAddToCart)
                                        ? 12.sp
                                        : 16.sp,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ÖZEL SİPARİŞ — geçici olarak kapatıldı.
// /// "Ýörite sargyt" butonu — stokta olmayan, getirtilebilir kitaplar için.
// /// Talep sheet'i açar; sepetle ilgisi yoktur.
// class _SpecialOrderButton extends StatelessWidget {
//   const _SpecialOrderButton({required this.book});
//
//   final BookModel book;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomButton(
//       backgroundColor: CustomColors.orangeColor,
//       onTap: () async {
//         final ok = await ensureLoggedIn(context);
//         if (!ok || !context.mounted) return;
//
//         final created = await showSpecialOrderSheet(context, book);
//         if (created == true && context.mounted) {
//           NotificationHelper.showSuccess(
//             context,
//             context.l10n.specialOrderRequestSent,
//           );
//         }
//       },
//       child: Text(
//         context.l10n.createSpecialOrder,
//         style: TextStyle(
//           fontFamily: 'Poppins-regular',
//           fontWeight: FontWeight.bold,
//           fontSize: 14.sp,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
