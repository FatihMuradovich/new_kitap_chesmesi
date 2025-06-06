import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/books_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/book_item.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/widget/lang_popup.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/widget/custom_banner.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/widget/custom_home_category.dart';
import 'package:new_kitap_chesmesi/features/navBar/cubit/nav_bar_cubit.dart';
import 'package:new_kitap_chesmesi/features/search/presentation/page/search_page.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.orangeColor,
        surfaceTintColor: CustomColors.orangeColor,
        shadowColor: Colors.white,
        centerTitle: false,
        title: Image.asset(width: 100.w, 'assets/logo/logo 1.PNG'),
        actions: [LangPopup()],
      ),
      body: BlocBuilder<BooksCubit, BookState>(builder: (context, state) {
        if (state is BooksLoading) {
          return CircularProgressIndicator();
        } else if (state is BooksLoaded) {
          final books = state.books;
          final newAdded = books.where((book)=> book.new_added).toList();
          final hot = books.where((book)=> book.hot).toList();
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                BlocBuilder<BooksCubit,BookState>(
                 
                  builder: (context, state) {
                    
                    if (state is BooksLoaded){
return Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 15),
                      child: CustomTextFormField(
                        onTap: () {
                          context.read<NavBarCubit>().hideNavBar();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SearchPage(books: state.books,)),
                          ).then((_) {
                            // ignore: use_build_context_synchronously
                            context.read<NavBarCubit>().showNavBar();
                          });
                        },
                        hintText: context.l10n.bookAuthorSearch,
                        isPrefix: false,
                        readOnly: true,
                        controller: null,
                        isCalendar: false,
                        isPassword: false,
                      ),
                    );
                    }else{
return Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 15),
                      child: CustomTextFormField(
                        onTap: () {
                          context.read<NavBarCubit>().hideNavBar();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SearchPage(books: [],)),
                          ).then((_) {
                            // ignore: use_build_context_synchronously
                            context.read<NavBarCubit>().showNavBar();
                          });
                        },
                        hintText: context.l10n.bookAuthorSearch,
                        isPrefix: false,
                        readOnly: true,
                        controller: null,
                        isCalendar: false,
                        isPassword: false,
                      ),
                    );
                    }
                    
                  }
                ),
                Padding(
                    padding: const EdgeInsets.all(12), child: CustomBanner()),
                CustomHomeCategory(title: context.l10n.newBooks, onTap: () {}),
                SizedBox(
                  height: 215.w,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(right: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: newAdded.length,
                    itemExtent: 145.w,
                    itemBuilder: (context, index) {
                      return BookItem(margin: true,book: newAdded[index],);
                    },
                  ),
                ),
                CustomHomeCategory(
                    title: context.l10n.discountBook, onTap: () {}),
                SizedBox(
                  height: 215.w,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(right: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: hot.length,
                    itemExtent: 145.w,
                    itemBuilder: (context, index) {
                      return BookItem(margin: true,book: hot[index],);
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Text('No books'),
          );
        }
      }),
    );
  }
}
