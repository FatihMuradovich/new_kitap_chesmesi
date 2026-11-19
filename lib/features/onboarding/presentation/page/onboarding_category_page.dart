import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/category_cubit.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class OnboardingCategoryPage extends StatefulWidget {
  const OnboardingCategoryPage({super.key});

  @override
  State<OnboardingCategoryPage> createState() => _OnboardingCategoryPageState();
}

class _OnboardingCategoryPageState extends State<OnboardingCategoryPage> {
  final Set<int> _selectedIds = {};

  bool get _canContinue => _selectedIds.length >= 3;

  void _toggleCategory(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _onContinue() async {
    if (!_canContinue) return;
    await context
        .read<UserCubit>()
        .updateRecommendedCategories(_selectedIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Text(
                context.l10n.selectCategories,
                style: TextStyle(
                  fontFamily: context.l10n.localeName == 'ru'
                      ? 'RobotoSlab-Black'
                      : 'Poppins-Regular',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                context.l10n.selectCategoriesHint,
                style: TextStyle(
                  fontFamily: context.l10n.localeName == 'ru'
                      ? 'RobotoSlab-Regular'
                      : 'Poppins-Regular',
                  fontSize: 12.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading || state is CategoryInitial) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is CategoryError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.l10n.categoriesNotLoaded,
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextButton(
                              onPressed: () => context
                                  .read<CategoryCubit>()
                                  .fetchCategories(),
                              child: Text(context.l10n.tryAgain),
                            ),
                          ],
                        ),
                      );
                    } else if (state is CategoryLoaded) {
                      final categories = state.categories;
                      if (categories.isEmpty) {
                        return Center(
                          child: Text(
                            context.l10n.categoryNotFound,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 3 / 1.2,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final categoryId = category.id ?? 0;
                          final isSelected = _selectedIds.contains(categoryId);

                          return _CategoryTile(
                            title: category.name,
                            selected: isSelected,
                            onTap: () => _toggleCategory(categoryId),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              SizedBox(height: 16.h),
              BlocListener<UserCubit, UserState>(
                listener: (context, state) {
                  if (state is UserLoaded) {
                    di<AppRouter>().replaceAll([const CustomNavBarRoute()]);
                  } else if (state is UserError) {
                    NotificationHelper.showError(
                        context, context.l10n.errorMessage);
                  }
                },
                child: BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    final isLoading = state is UserLoading;
                    final enabled = _canContinue && !isLoading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: enabled ? _onContinue : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: enabled
                              ? CustomColors.orangeColor
                              : Colors.grey[300],
                          foregroundColor:
                              enabled ? Colors.white : Colors.grey[700],
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                context.l10n.selectCategoriesButton,
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? CustomColors.orangeColor : Colors.white;
    final textColor = selected ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? CustomColors.orangeColor : Colors.grey[300]!,
            width: 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: CustomColors.orangeColor.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        // padding: EdgeInsets.symmetric(
        //   horizontal: 10.w,
        // ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ),
            if (selected)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14.sp,
                    color: CustomColors.orangeColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
