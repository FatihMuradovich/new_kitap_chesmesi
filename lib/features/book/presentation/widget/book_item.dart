import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/book_detail.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/cubit.dart';
import 'package:new_kitap_chesmesi/features/navBar/cubit/nav_bar_cubit.dart';

// ignore: must_be_immutable
class BookItem extends StatelessWidget {
  final BookModel book;
  bool margin = false;
  // BookModel book;
  BookItem({super.key, required this.margin, required this.book});

  // var bookList = <BookModel>[];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      context.read<NavBarCubit>().hideNavBar();
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => BookDetail(book: book,))).then((_) {
        // Geri dönüldüğünde navbar tekrar gösterilir
        context.read<NavBarCubit>().showNavBar();
      });
    }, child: BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        bool isFavorite = false;
        if (state is FavoriteLoaded) {
          isFavorite = state.favorites.contains(book);
        }
        return Container(
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
                      child: Image(
                        image: book.backgroundImageHard == null
                            ? AssetImage('assets/images/1.png')
                            : NetworkImage(book.backgroundImageHard as String),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -3,
                    top: -4,
                    child: IconButton(
                      icon: Icon(
                        isFavorite
                            ? FluentSystemIcons.ic_fluent_heart_filled
                            : FluentSystemIcons.ic_fluent_heart_regular,
                        // color: Colors.red,
                      ),
                      onPressed: () {
                        context.read<FavoriteCubit>().toggleFavorite(book);
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
                book.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Poppins-black',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 12.sp, fontFamily: 'Poppins-regular'),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    book.priceHardcover.toString(),
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
                    book.priceHardcover.toString(),
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
        );
      },
    ));
  }
}
