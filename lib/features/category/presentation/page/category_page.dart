import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/customn_icons.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/books_page.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/category_cubit.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/widget/category_item.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import 'package:new_kitap_chesmesi/common/widgets/category_shimmer.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.categories)),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const CategoryShimmer();
          } else if (state is CategoryLoaded) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: state.categories.length + 1,
                itemBuilder: (context, index) {
                  // First item is "All Books"
                  if (index == 0) {
                    return _buildAllBooksItem(context);
                  }
                  // Adjust index for actual categories
                  final categoryItem = state.categories[index - 1];
                  return CategoryItem(
                    categoryModel: categoryItem,
                  );
                },
              ),
            );
          } else if (state is CategoryError) {
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

  Widget _buildAllBooksItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        di<AppRouter>().push(
          BooksRoute(
            name: context.l10n.allBooks,
            categoryType: BookCategoryType.allBooks,
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
              Text(
                context.l10n.allBooks,
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
  }
}
