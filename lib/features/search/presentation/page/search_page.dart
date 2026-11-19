import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/common/widgets/error_retry_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/book_item.dart';
import 'package:new_kitap_chesmesi/features/search/presentation/cubit/search_cubit.dart';
import 'package:new_kitap_chesmesi/features/search/presentation/cubit/search_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onSearchChanged() {
    // Debounce search to avoid too many API calls
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(_searchController.text);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<SearchCubit>().state;
      if (state is SearchLoaded && state.hasMore) {
        context.read<SearchCubit>().loadMoreBooks();
      }
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      context.read<SearchCubit>().clearSearch();
      return;
    }
    context.read<SearchCubit>().searchBooks(query.trim());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          context.l10n.searchPage,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
              controller: _searchController,
              autofocus: true,
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
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[600],
                          size: 20.sp,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SearchCubit>().clearSearch();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Refresh UI to show/hide clear button
              },
            ),
          ),

          // Search Results
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return _buildEmptyState();
                } else if (state is SearchLoading) {
                  return _buildLoadingState();
                } else if (state is SearchLoadingMore) {
                  return _buildSearchResults(
                    state.currentBooks,
                    showLoader: true,
                  );
                } else if (state is SearchLoaded) {
                  if (state.books.isEmpty) {
                    return _buildNoResultsFound();
                  }
                  return _buildSearchResults(state.books);
                } else if (state is SearchError) {
                  return ErrorRetryView(
                    onRetry: () => _performSearch(_searchController.text),
                  );
                }
                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 64.w,
              color: CustomColors.orangeColor,
            ),
          ),
          // SizedBox(height: 24.h),
          // Text(
          //   context.l10n.bookAuthorSearch,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: Colors.grey[700],
          //     fontSize: 16.sp,
          //     fontFamily: 'Poppins-regular',
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          // SizedBox(height: 8.h),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 48.w),
          //   child: Text(
          //     'Kitap adı veya yazar adı girin',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       color: Colors.grey[500],
          //       fontSize: 12.sp,
          //       fontFamily: 'Poppins-regular',
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: CustomColors.orangeColor,
            strokeWidth: 3,
          ),
          SizedBox(height: 24.h),
          Text(
            context.l10n.viewing,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Poppins-regular',
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.search_off,
            size: 64.w,
            color: CustomColors.orangeColor,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          context.l10n.noResultsFound,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16.sp,
            fontFamily: 'Poppins-regular',
            fontWeight: FontWeight.w500,
          ),
        ),
        // SizedBox(height: 8.h),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 48.w),
        //   child: Text(
        //     'Farklı anahtar kelimeler deneyin',
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       color: Colors.grey[500],
        //       fontSize: 12.sp,
        //       fontFamily: 'Poppins-regular',
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildSearchResults(List books, {bool showLoader = false}) {
    final itemCount = showLoader ? books.length + 1 : books.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 220.w,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              // Sona eklenen yükleniyor göstergesi
              if (showLoader && index == books.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: CircularProgressIndicator(
                      color: CustomColors.orangeColor,
                    ),
                  ),
                );
              }

              return BookItem(
                margin: false,
                book: books[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
