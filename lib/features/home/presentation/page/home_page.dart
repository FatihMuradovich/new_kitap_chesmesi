import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/books_page.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/book_item.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/widget/custom_banner.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/widget/custom_home_category.dart';
import 'package:new_kitap_chesmesi/features/navBar/cubit/nav_bar_cubit.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import 'package:new_kitap_chesmesi/common/widgets/shimmer_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // State'i koru, her seferinde yeniden yükleme

  @override
  void initState() {
    super.initState();
    // Sadece ilk yüklemede loading ile veri çek
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<HomeCubit>().state is! HomeLoaded) {
        context.read<HomeCubit>().loadHomeData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin için gerekli
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => context.read<HomeCubit>().loadHomeData(),
        child: SingleChildScrollView(
          physics:
              AlwaysScrollableScrollPhysics(), // RefreshIndicator için gerekli
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const ShimmerLoading();
              } else if (state is HomeLoaded) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 15),
                      child: _buildSearchField(context),
                    ),
                    SizedBox(height: 10.h),
                    state.banners.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(left: 12, right: 12),
                            child: CustomBanner(banners: state.banners),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 10.h),
                    state.userBooks.isNotEmpty
                        ? _buildBookSection(
                            title: context.l10n.recommendedBooks,
                            books: state.userBooks,
                            onTap: () {
                              di<AppRouter>().push(
                                BooksRoute(
                                categoryType: BookCategoryType.recommended,
                                name: context.l10n.recommendedBooks,
                              ),
                            );
                            },
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 4.h),
                    state.newBooks.isNotEmpty
                        ? _buildBookSection(
                            title: context.l10n.newBooks,
                            books: state.newBooks,
                            onTap: () => di<AppRouter>().push(
                              BooksRoute(
                                categoryType: BookCategoryType.newBooks,
                                name: context.l10n.newBooks,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    state.discountBooks.isNotEmpty
                        ? _buildBookSection(
                            title: context.l10n.discountBook,
                            books: state.discountBooks,
                            onTap: () => di<AppRouter>().push(
                              BooksRoute(
                                categoryType: BookCategoryType.discounted,
                                name: context.l10n.discountBook,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    state.booksByLang.isNotEmpty
                        ? _buildBookSection(
                            title: context.l10n.turkmenBooks,
                            books: state.booksByLang,
                            onTap: () => di<AppRouter>().push(
                              BooksRoute(
                                categoryType: BookCategoryType.turkmen,
                                name: context.l10n.turkmenBooks,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    state.bookByCategoryId.isNotEmpty
                        ? _buildBookSection(
                            title: context.l10n.childrenBooks,
                            books: state.bookByCategoryId,
                            onTap: () => di<AppRouter>().push(
                              BooksRoute(
                                categoryType: BookCategoryType.childrenBooks,
                                name: context.l10n.childrenBooks,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                );
              } else if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.errorMessage,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: CustomColors.orangeColor,
      surfaceTintColor: CustomColors.orangeColor,
      shadowColor: Colors.white,
      centerTitle: false,
      title: Image.asset(width: 90.w, 'assets/logo/logo 1.PNG'),
      actions: [
        IconButton(
          onPressed: () {
            di<AppRouter>().push(const NotificationRoute());
          },
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final navBarCubit = context.read<NavBarCubit>();
        navBarCubit.hideNavBar();
        di<AppRouter>().push(const SearchRoute()).then((_) {
          if (mounted) {
            navBarCubit.showNavBar();
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          enabled: false,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            hintText: context.l10n.bookAuthorSearch,
            hintStyle: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 14.sp,
              color: Colors.grey[400],
            ),
            prefixIcon: Icon(
              Icons.search,
              color: CustomColors.blueColor,
              size: 24.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 10.h,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookSection({
    required String title,
    required List<BookModel> books,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        CustomHomeCategory(title: title, onTap: onTap),
        SizedBox(
          height: 220.w,
          child: ListView.builder(
            // padding: const EdgeInsets.only(right: 12),
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemExtent: 145.w,
            itemBuilder: (context, index) {
              return BookItem(
                margin: true,
                book: books[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
