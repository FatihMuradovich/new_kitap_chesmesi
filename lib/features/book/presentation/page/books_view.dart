import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/books_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/book_item.dart';

class BooksView extends StatelessWidget {
  final String title;
  final int categoryId;
  const BooksView({super.key, required this.title,required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<BooksCubit, BookState>(builder: (context, state) {
        if (state is BooksLoading) {
          return CircularProgressIndicator();
        } else if (state is BooksLoaded) {
          final books = state.books.where((book)=>book.categoryId == categoryId).toList();
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: 215.w,
              child: GridView.builder(
                padding: const EdgeInsets.only(right: 12),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return BookItem(
                    margin: true,
                    book: books[index],
                  );
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0.w,
                    mainAxisSpacing: 10.0.w,
                    mainAxisExtent: 300.h),
              ),
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
