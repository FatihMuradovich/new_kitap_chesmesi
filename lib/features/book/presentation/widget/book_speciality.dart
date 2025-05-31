// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:new_kitap_chesmesi/common/constants/custom_text_style.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class BookSpeciality extends StatelessWidget {
  const BookSpeciality({super.key});

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
            SpecialityItem(title1: context.l10n.productCode, title2: ''),
            SizedBox(height: 5),
            SpecialityItem(title1: context.l10n.publishYear, title2: ''),
            SizedBox(height: 5),
            SpecialityItem(title1: context.l10n.publishYear, title2: ''),
            SizedBox(height: 5),
            SpecialityItem(title1: context.l10n.productCode, title2: ''),
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
