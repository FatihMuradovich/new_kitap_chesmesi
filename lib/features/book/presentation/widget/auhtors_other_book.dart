// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/book_item.dart';

class AutgorsOtherBooks extends StatelessWidget {
  final int id;
  final int bookId;
  final int itemCount;
  final List<BookModel> books;
  const AutgorsOtherBooks({
    super.key,
    required this.id,
    required this.bookId,
    required this.itemCount,
    required this.books,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemExtent: 145.w,
      itemCount: itemCount,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return BookItem(margin: true, book: books[index]);
      },
    );
  }
}
