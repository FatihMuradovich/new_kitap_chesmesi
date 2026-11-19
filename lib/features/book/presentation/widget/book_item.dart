import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/base_url.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/common/utils/auth_guard.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

// ignore: must_be_immutable
class BookItem extends StatelessWidget {
  final BookModel book;

  bool margin = false;

  BookItem({
    super.key,
    required this.margin,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = book.hasDiscount;
    return GestureDetector(
        onTap: () {
          // final navBarCubit = context.read<NavBarCubit>();
          // navBarCubit.hideNavBar();
          di<AppRouter>().push(BookDetailRoute(id: book.id));
        },
        child: Container(
          margin: margin
              ? const EdgeInsets.only(left: 12, bottom: 8, top: 5)
              : const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[100],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: '${BaseUrl.baseUrl}${book.images[0].path}',
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -3,
                    top: -4,
                    child: BlocBuilder<FavoriteCubit, FavoriteState>(
                      builder: (context, state) {
                        final favoriteCubit = context.read<FavoriteCubit>();
                        final isFavorite =
                            favoriteCubit.isBookFavorite(book.id);
                        // final isUpdating = state is FavoriteLoaded &&
                        //     state.updatingBookId == book.id;

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.black,
                              ),
                              onPressed: () async {
                                final ok = await ensureLoggedIn(context);
                                if (!ok) return;
                                // ignore: use_build_context_synchronously
                                favoriteCubit.toggleFavorite(book.id);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
                  // // Stokta yok ama getirtilebilir — kullanıcı listede ayırt
                  // // edebilsin (SPECIAL-ORDER-API.md §7).
                  // if (book.isSpecialOrderable)
                  // Positioned(
                  // left: 4,
                  // bottom: 4,
                  // child: Container(
                  // padding: EdgeInsets.symmetric(
                  // horizontal: 6.w,
                  // vertical: 2.h,
                  // ),
                  // decoration: BoxDecoration(
                  // color: CustomColors.orangeColor,
                  // borderRadius: BorderRadius.circular(999),
                  // ),
                  // child: Text(
                  // context.l10n.specialOrderBadge,
                  // style: TextStyle(
                  // color: Colors.white,
                  // fontFamily: 'Poppins-regular',
                  // fontSize: 9.sp,
                  // fontWeight: FontWeight.w600,
                  // ),
                  // ),
                  // ),
                  // ),
                ],
              ),
              SizedBox(height: 5.h),
              Text(
                book.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins-regular',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                book.author!.name.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 10.sp,
                  fontFamily: 'Poppins-regular',
                ),
              ),

              SizedBox(height: 2.h),
              // _BookRatingStars(book: book),
              // `Finished` kitapta fiyat null gelir — formatlamak yerine
              // "ýörite sargyt" yazılır (SPECIAL-ORDER-API.md §4).
              if (!book.hasPrice)
                Text(
                  context.l10n.priceOnRequest,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: CustomColors.orangeColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-regular',
                  ),
                )
              else if (hasDiscount)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${book.discountedPrice.toStringAsFixed(2)} m.',
                      style: TextStyle(
                        color: CustomColors.orangeColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-black',
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${book.priceValue.toStringAsFixed(2)} m.',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                  ],
                )
              else
                Text(
                  '${book.priceValue.toStringAsFixed(2)} m.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: CustomColors.orangeColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-black',
                  ),
                ),
              // SizedBox(
              //   height: 35,
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.white,
              //       foregroundColor: CustomColors.orangeColor,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10)),
              //     ),
              //     onPressed: () {},
              //     child: const Icon(
              //       Icons.shopping_cart,
              //       size: 20,
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
