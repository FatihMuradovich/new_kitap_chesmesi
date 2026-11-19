import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/core/utils/slide_route.dart';
export 'package:new_kitap_chesmesi/features/book/domain/model/book_category_type.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_category_type.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_list_context.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/book/books_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/books_filter_page.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/book_item.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class BooksPage extends StatefulWidget {
  final int? subcategoryId;
  final String name;
  final BookCategoryType categoryType;

  const BooksPage(
      {super.key,
      this.subcategoryId,
      required this.name,
      required this.categoryType});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late final BooksCubit _booksCubit;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _autoLoadMoreTriggered = false;

  @override
  void initState() {
    super.initState();
    _booksCubit = di<BooksCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchBooks());
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(BooksPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subcategoryId != widget.subcategoryId ||
        oldWidget.categoryType != widget.categoryType) {
      _autoLoadMoreTriggered = false;
      _fetchBooks();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _booksCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = _booksCubit.state;

      if (state is! BooksLoaded || !state.hasMore) return;

      final pending = _loadMore();
      if (pending == null) return;

      _isLoadingMore = true;
      pending.then((_) => _isLoadingMore = false);
    }
  }

  void _openFilterPage() {
    Navigator.of(context).push(
      SlideRoute(
        page: BooksFilterPage(
          initialFilters: _booksCubit.activeFilters,
          onFiltersApplied: (criteria) {
            _autoLoadMoreTriggered = false;
            if (criteria.isEmpty) {
              _fetchBooks();
            } else {
              _booksCubit.applyFilters(criteria, _listContext());
            }
          },
          onClearFilters: () {
            _autoLoadMoreTriggered = false;
            _fetchBooks();
          },
        ),
        direction: SlideDirection.fromRight,
      ),
    );
  }

  bool _usesPagination() {
    if (widget.categoryType == BookCategoryType.allBooks) return true;
    if (widget.categoryType == BookCategoryType.discounted) return true;
    return false;
  }

  /// Sonsuz kaydırma ve ekran doldurma için ortak tetikleyici.
  /// Sayfalama desteklemeyen tiplerde `null` döner.
  Future<void>? _loadMore() {
    switch (widget.categoryType) {
      case BookCategoryType.allBooks:
        return _booksCubit.loadMoreAllBooks();
      case BookCategoryType.discounted:
        return _booksCubit.loadMoreDiscountedBooks();
      default:
        return null;
    }
  }

  BookListContext _listContext() {
    return BookListContext.fromPage(
      categoryType: widget.categoryType,
      subcategoryId: widget.subcategoryId,
    );
  }

  void _fetchBooks() {
    switch (widget.categoryType) {
      case BookCategoryType.subcategory:
        if (widget.subcategoryId != null) {
          _booksCubit.fetchBookByCategory(widget.subcategoryId!);
        }
        break;
      case BookCategoryType.newBooks:
        _booksCubit.fetchLatestBooks();
        break;
      case BookCategoryType.discounted:
        _booksCubit.fetchDiscountedBooks();
        break;
      case BookCategoryType.turkmen:
        _booksCubit.fetchBooksByLanguage(4);
        break;
      case BookCategoryType.childrenBooks:
        _booksCubit.fetchBooksByCategory(6);
        break;
      case BookCategoryType.literature:
        _booksCubit.fetchBooksByCategory(1);
        break;
      case BookCategoryType.allBooks:
        _booksCubit.fetchAllBooks();
        break;
      case BookCategoryType.recommended:
        _booksCubit.fetchUserRecommendedBooks();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _booksCubit,
      child: Scaffold(
      appBar: AppBar(
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(50.h),
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Expanded(
        //           child: Card(
        //             color: CustomColors.orangeColor,
        //             margin: EdgeInsets.zero,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(5.r),
        //             ),
        //             child: Padding(
        //               padding:
        //                   EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        //               child: Center(
        //                 child: Text(
        //                   'Süzgüç',
        //                   style: TextStyle(
        //                     fontFamily: 'Poppins-regular',
        //                     fontSize: 14.sp,
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //         SizedBox(width: 10.w),
        //         Expanded(
        //           child: Card(
        //             color: CustomColors.orangeColor,
        //             margin: EdgeInsets.zero,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(5.r),
        //             ),
        //             child: Padding(
        //               padding:
        //                   EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        //               child: Center(
        //                 child: Text(
        //                   'Filter',
        //                   style: TextStyle(
        //                       fontFamily: 'Poppins-regular',
        //                       fontSize: 14.sp,
        //                       color: Colors.white),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        title: Text(widget.name),
        actions: [
          IconButton(
            onPressed: _openFilterPage,
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: BlocBuilder<BooksCubit, BookState>(
        builder: (context, state) {
          if (state is BooksLoading) {
            return _buildShimmerLoading();
          }

          if (state is BooksLoadingMore) {
            return _buildBooksGrid(state.currentBooks, showLoader: true);
          }

          if (state is BooksLoaded) {
            final books = state.books;
            if (books.isEmpty) {
              return _buildEmptyMessage(context.l10n.emptyCategory);
            }
            if (_usesPagination() &&
                books.length < 10 &&
                state.hasMore &&
                !_autoLoadMoreTriggered) {
              _autoLoadMoreTriggered = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _loadMore();
              });
            }
            return _buildBooksGrid(books);
          }

          if (state is BookError) {
            return _buildEmptyMessage(context.l10n.errorMessage);
          }

          return _buildEmptyMessage(context.l10n.emptyCategory);
        },
      ),
    ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 14.sp,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildBooksGrid(List books, {bool showLoader = false}) {
    final usePagination = _usesPagination();
    final itemCount = showLoader ? books.length + 1 : books.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        controller: usePagination ? _scrollController : null,
        itemCount: itemCount,
        gridDelegate: _gridDelegate,
        itemBuilder: (context, index) {
          // Show loader at the end
          if (showLoader && index == books.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return BookItem(
            margin: false,
            book: books[index],
          );
        },
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount get _gridDelegate {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisExtent: 245.w,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        itemCount: 10,
        gridDelegate: _gridDelegate,
        itemBuilder: (context, index) => _buildShimmerBookItem(),
      ),
    );
  }

  Widget _buildShimmerBookItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Container(
            height: 14.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            height: 12.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            height: 14.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
