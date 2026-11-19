// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/customn_icons.dart';
import 'package:new_kitap_chesmesi/features/category/domain/model/category_model.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

// ignore: must_be_immutable
class CategoryItem extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryItem({
    super.key,
    required this.categoryModel,
  });

  String getLocalazedTitle(String locale) {
    switch (locale) {
      case 'en':
        return categoryModel.name;
      case 'ru':
        return categoryModel.name;
      case 'tr':
        return categoryModel.name;
      default:
        return categoryModel.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = getLocalazedTitle(context.l10n.localeName);

    return GestureDetector(
      onTap: () {
        di<AppRouter>().push(
          SubcategoryRoute(
            id: categoryModel.id.toString(),
            title: categoryModel.name,
          ),
        );
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: const Color(0xFFFAFAFA),
        elevation: 0.3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Poppins-regular',
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              CustomIcons.rightChevron,
            ],
          ),
        ),
      ),
    );
  }
}
