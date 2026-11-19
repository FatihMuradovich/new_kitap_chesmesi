// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_text_style.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

// ignore: must_be_immutable
class BookSpeciality extends StatelessWidget {
  BookModel book;
  BookSpeciality({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SpecialityItem(
                title1: context.l10n.publisher,
                title2: book.publisher!.name.toString()),
            SizedBox(height: 5),
            SpecialityItem(
                title1: context.l10n.bookCover,
                title2: book.cover.toString() == 'SoftCover'
                    ? context.l10n.softCover
                    : context.l10n.hardCover),
            SizedBox(height: 5),
            SpecialityItem(
                title1: context.l10n.publishYear,
                title2: book.publishYear.toString()),
            SizedBox(height: 5),
            SpecialityItem(
                title1: context.l10n.page, title2: book.pageCount.toString()),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SpecialityItem extends StatelessWidget {
  String title1, title2;
  SpecialityItem({super.key, required this.title1, required this.title2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title1, style: CustomTextStyle.kitapOzellik),
        Text(title2, style: CustomTextStyle.kitapOzellik),
      ],
    );
  }
}
