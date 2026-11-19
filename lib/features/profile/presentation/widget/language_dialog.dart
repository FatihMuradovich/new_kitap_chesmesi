import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/app.dart';
import 'package:new_kitap_chesmesi/common/constants/constant_button.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_text_style.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/category_cubit.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      children: [
        Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Image.asset(
              'assets/icons/globe_light.png',
              height: 30.h,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              context.l10n.selectLanguage,
              style:
                  const TextStyle(fontFamily: 'Poppins-regular', fontSize: 16),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.h),
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // NOTE: UI locale for Turkmen should be 'tr' (matches ARB: app_tr.arb)
                  App.of(context)?.setLocale(const Locale('tr'));
                  // Refetch language-dependent data
                  context.read<CategoryCubit>().fetchCategories();
                  context.read<HomeCubit>().loadHomeData();
                  Navigator.pop(context);
                },
                style: ConstantsButtonStyle.elevatedButtonStyleOrange,
                child: Text(
                  'Türkmençe',
                  style: CustomTextStyle.languageDialogText,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.h),
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  App.of(context)?.setLocale(const Locale('ru'));
                  // Refetch language-dependent data
                  context.read<CategoryCubit>().fetchCategories();
                  context.read<HomeCubit>().loadHomeData();

                  Navigator.pop(context);
                },
                style: ConstantsButtonStyle.elevatedButtonStyleOrange,
                child: Text(
                  'Русский',
                  style: CustomTextStyle.languageDialogText,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        )
      ],
    );
  }
}
