import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/book_detail.dart';
import 'package:new_kitap_chesmesi/features/navBar/cubit/nav_bar_cubit.dart';

// ignore: must_be_immutable
class BookItem extends StatefulWidget {
  bool margin = false;
  // BookModel book;
  BookItem({super.key, required this.margin});

  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  // var bookList = <BookModel>[];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<NavBarCubit>().hideNavBar();
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => BookDetail())).then((_) {
          // Geri dönüldüğünde navbar tekrar gösterilir
          context.read<NavBarCubit>().showNavBar();
        });
      },
      child: Container(
        margin:
            widget.margin
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
                    child: Image(
                      image: AssetImage('assets/images/1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: -3,
                  top: -4,
                  child: IconButton(
                    icon: Icon(
                      // widget.book.isFavorite
                      // ? FluentSystemIcons.ic_fluent_heart_filled
                      FluentSystemIcons.ic_fluent_heart_regular,
                      // color: Colors.red,
                    ),
                    onPressed: () {
                      // context
                      //     .read<FavoritesCubit>()
                      //     .toggleFavorite(widget.book);
                    },
                  ),
                ),
                // Positioned(
                //   right: -1,
                //   top: -3,
                //   child: BlocBuilder<FavoritesCubit, FavoritesState>(
                //     builder: (context, state) {
                //       return IconButton(
                //         icon: Icon(
                //           widget.book.isFavorite
                //               ? FluentSystemIcons.ic_fluent_heart_filled
                //               : FluentSystemIcons.ic_fluent_heart_regular,
                //           color: widget.book.isFavorite ? Colors.red : null,
                //         ),
                //         onPressed: () {
                //           context
                //               .read<FavoritesCubit>()
                //               .toggleFavorite(widget.book);
                //         },
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              'Dorian Grayin Portresi',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins-black',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Oscar Wilde',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppins-regular'),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '500 TMT',
                  // '${widget.book.priceSoftcover} TMT',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: CustomColors.orangeColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-black',
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  '70.00 TMT',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black26,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.black26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-black',
                  ),
                ),
              ],
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
      ),
    );
  }
}
