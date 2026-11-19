// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_kitap_chesmesi/common/constants/customn_icons.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/books_page.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/cubit/subcategory_cubit.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/cubit/subcategory_state.dart';
import 'package:new_kitap_chesmesi/common/widgets/category_shimmer.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
// ignore: must_be_immutable
class SubcategoryPage extends StatefulWidget {
  String id;
  String title;
  SubcategoryPage({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  State<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  @override
  void initState() {
    context.read<SubcategoryCubit>().fetchSubCategories(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BlocBuilder<SubcategoryCubit, SubcategoryState>(
        builder: (context, state) {
          if (state is SubcategoryLoading) {
            return const SubcategoryShimmer();
          } else if (state is SubcategoryLoaded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: state.subcategories.length,
                itemBuilder: (context, index) {
                  final subcategoryItem = state.subcategories[index];

                  return GestureDetector(
                    onTap: () {
                      di<AppRouter>().push(
                        BooksRoute(
                          categoryType: BookCategoryType.subcategory,
                          subcategoryId: subcategoryItem.id!.toInt(),
                          name: subcategoryItem.name,
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subcategoryItem.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                            CustomIcons.rightChevron,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is SubcategoryError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.l10n.errorMessage,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
