// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:new_kitap_chesmesi/common/constants/base_url.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/getBookByAuthorId/book_by_author_id_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/getBookById/get_book_by_id_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/getBookById/get_book_by_id_state.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/comment/comment_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/comment/comment_state.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/book_item.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/book_speciality.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/comment_item.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/detail_bottom_bar.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_state.dart';
import 'package:new_kitap_chesmesi/common/utils/auth_guard.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:readmore/readmore.dart';

// ignore: must_be_immutable
@RoutePage(name: 'BookDetailRoute')
// ignore: must_be_immutable
class BookDetail extends StatefulWidget {
  int id;
  BookDetail({
    super.key,
    required this.id,
  });

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  int _currentImageIndex = 0;
  late PageController _pageController;

  // Her detay sayfası kendi cubit'lerine sahip. Global olduklarında
  // A → (yazarın diğer kitabı) B → geri dönüşte A sayfası B'nin verisini,
  // yorumlarını gösteriyor ve "sepete ekle" B'yi ekliyordu.
  late final GetBookByIdCubit _bookCubit = di<GetBookByIdCubit>();
  late final CommentCubit _commentCubit = di<CommentCubit>();
  late final BookByAuthorIdCubit _authorBooksCubit = di<BookByAuthorIdCubit>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: true);
    _loadBook(widget.id);
  }

  @override
  void didUpdateWidget(BookDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      _loadBook(widget.id);
    }
  }

  void _loadBook(int bookId) {
    _bookCubit.fetchBookById(bookId);
    _commentCubit.getCommentsByBookId(bookId);
  }

  void _loadAuthorBooks(int authorId) {
    _authorBooksCubit.fetchBookByAuthorId(authorId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bookCubit.close();
    _commentCubit.close();
    _authorBooksCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bookCubit),
        BlocProvider.value(value: _commentCubit),
        BlocProvider.value(value: _authorBooksCubit),
      ],
      child: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return BlocListener<GetBookByIdCubit, GetBookByIdState>(
      listener: (context, state) {
        if (state is BookDetailLoaded) {
          final authorId = state.book.authorId;
          if (authorId != null && authorId > 0) {
            _loadAuthorBooks(authorId);
          }
        }
      },
      child: Scaffold(
        body: BlocBuilder<GetBookByIdCubit, GetBookByIdState>(
          builder: (context, state) {
            if (state is BookDetailLoading) {
              return _buildShimmerLoading();
            } else if (state is BookDetailLoaded) {
              final bookDetail = state.book;

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 340,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            color: Colors.grey[50],
                            child: Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: PageView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  controller: _pageController,
                                  itemCount: bookDetail.images.length,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentImageIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    final imageItem = bookDetail.images[index];
                                    return SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${BaseUrl.baseUrl}${imageItem.path}',
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Page indicator - only show if there are multiple images
                          if (bookDetail.images.length > 1)
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      bookDetail.images.length,
                                      (index) => Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 2.w),
                                        width: _currentImageIndex == index
                                            ? 16.w
                                            : 8.w,
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: _currentImageIndex == index
                                              ? Colors.white
                                              : Colors.white
                                                  .withValues(alpha: 0.4),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    actions: [
                      BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          final favoriteCubit = context.read<FavoriteCubit>();
                          final isFavorite =
                              favoriteCubit.isBookFavorite(bookDetail.id);
                          return IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                            ),
                            onPressed: () async {
                              final ok = await ensureLoggedIn(context);
                              if (!ok) return;
                              // ignore: use_build_context_synchronously
                              favoriteCubit.toggleFavorite(bookDetail.id);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 16),
                          child: Text(
                            bookDetail.name,
                            maxLines: 2,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Text(
                            bookDetail.author!.name,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: Colors.black54,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Text(
                            context.l10n.description,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Poppins-regular',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.w),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: ReadMoreText(
                            bookDetail.desc ?? 'No desc',
                            trimLines: 8,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: ' ${context.l10n.readMore}',
                            trimExpandedText: ' ${context.l10n.showLess}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: Colors.black54,
                              fontSize: 12.sp,
                            ),
                            moreStyle: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.orangeColor,
                            ),
                            lessStyle: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.orangeColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: BookSpeciality(
                            book: bookDetail,
                          ),
                        ),
                        // Combined Rating and Comments Section
                        SizedBox(height: 20.h),
                        BlocBuilder<CommentCubit, CommentState>(
                          builder: (context, commentState) {
                            return _buildRatingAndCommentsSection(
                                bookDetail, commentState);
                          },
                        ),

                        SizedBox(height: 20.h),
                        BlocBuilder<BookByAuthorIdCubit, BookByAuthorIdState>(
                          builder: (context, state) {
                            if (state is BookByAuthorIdLoaded) {
                              final authorBooks = state.books;
                              final anotherBooks = authorBooks
                                  .where((e) =>
                                      e.id != bookDetail.id &&
                                      e.status.toLowerCase() == 'available')
                                  .toList();

                              if (anotherBooks.isEmpty) {
                                return SizedBox.shrink();
                              }

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          context.l10n.auhtorsOtherBook,
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>BooksPage(name: context.l10n.auhtorsOtherBook, categoryType: categoryType)))
                                        //   },
                                        //   child: Icon(Icons.chevron_right),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5.w),
                                  SizedBox(
                                    height: 220.w,
                                    child: ListView.builder(
                                      // shrinkWrap: true,
                                      itemExtent: 145.w,
                                      itemCount: anotherBooks.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return BookItem(
                                            margin: true,
                                            book: anotherBooks[index]);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
        bottomNavigationBar: BlocBuilder<GetBookByIdCubit, GetBookByIdState>(
          builder: (context, state) {
            if (state is BookDetailLoaded) {
              final bookDetail = state.book;
              return DetailBottomBar(book: bookDetail);
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildRatingAndCommentsSection(
      dynamic bookDetail, CommentState commentState) {
    // Calculate real rating data from comments
    double averageRating = 0.0;
    int totalRatings = 0;
    Map<int, int> ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    if (commentState is CommentLoaded && commentState.comments.isNotEmpty) {
      final comments = commentState.comments;
      totalRatings = comments.length;

      if (totalRatings > 0) {
        double totalRatingSum = 0;
        for (var comment in comments) {
          final rating = comment.ratingValue.round();
          if (rating >= 1 && rating <= 5) {
            totalRatingSum += comment.ratingValue;
            ratingCounts[rating] = ratingCounts[rating]! + 1;
          }
        }
        averageRating = totalRatingSum / totalRatings;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Combined title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.ratingsAndComments,
                // context.l10n.ratingsAndComments,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (commentState is CommentLoaded &&
                  commentState.comments.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => _showAllComments(bookDetail),
                      child: Text(
                        context.l10n.seeAll,
                        style: TextStyle(
                          color: CustomColors.orangeColor,
                          fontSize: 12.sp,
                          fontFamily: 'Poppins-regular',
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 5.h),
          // Rating Section
          if (totalRatings == 0)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.h),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      context.l10n.commentsEmpty,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Poppins-regular',
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      context.l10n.commentsEmptyHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Poppins-regular',
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Row(
              children: [
                // Average Rating Display
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins-regular',
                        ),
                      ),
                      RatingBarIndicator(
                        rating: averageRating,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 16,
                        direction: Axis.horizontal,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        totalRatings == 0
                            ? 'Reýting ýok'
                            : '$totalRatings ${context.l10n.rating}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey[600],
                          fontFamily: 'Poppins-regular',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                // Rating Breakdown
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(
                          5,
                          totalRatings > 0
                              ? ratingCounts[5]! / totalRatings
                              : 0.0),
                      _buildRatingBar(
                          4,
                          totalRatings > 0
                              ? ratingCounts[4]! / totalRatings
                              : 0.0),
                      _buildRatingBar(
                          3,
                          totalRatings > 0
                              ? ratingCounts[3]! / totalRatings
                              : 0.0),
                      _buildRatingBar(
                          2,
                          totalRatings > 0
                              ? ratingCounts[2]! / totalRatings
                              : 0.0),
                      _buildRatingBar(
                          1,
                          totalRatings > 0
                              ? ratingCounts[1]! / totalRatings
                              : 0.0),
                    ],
                  ),
                ),
              ],
            ),

          // Comments Section
          SizedBox(height: 10.h),
          // Comments List - Horizontal scroll
          if (commentState is CommentLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: CircularProgressIndicator(
                  color: CustomColors.orangeColor,
                ),
              ),
            )
          else if (commentState is CommentLoaded)
            commentState.comments.isNotEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 110.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: commentState.comments.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 12.w),
                          itemBuilder: (context, index) {
                            final comment = commentState.comments[index];
                            return CommentItem(
                              comment: comment,
                              isHorizontal: true,
                              width: 280.w,
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink()
          else if (commentState is CommentError)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.h),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[600],
                    size: 24.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    context.l10n.commentsError,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Poppins-regular',
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 5.h),
          CustomButton(
            width: double.infinity,
            onTap: () => _navigateToAddComment(bookDetail),
            backgroundColor: CustomColors.orangeColor,
            child: Text(
              context.l10n.addComment,
              style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppins-regular'),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[600],
              fontFamily: 'Poppins-regular',
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddComment(dynamic bookDetail) async {
    final ok = await ensureLoggedIn(context);
    if (!ok || !mounted) return;

    final result = await di<AppRouter>().push(
      AddCommentRoute(
        bookId: bookDetail.id,
        bookTitle: bookDetail.name,
      ),
    );

    // If comment was added successfully, refresh comments
    if (result == true && mounted) {
      _commentCubit.getCommentsByBookId(widget.id);
    }
  }

  void _showAllComments(dynamic bookDetail) {
    di<AppRouter>().push(
      AllCommentsRoute(
        bookId: bookDetail.id,
        bookTitle: bookDetail.name,
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 340,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.grey[300],
                margin: const EdgeInsets.only(top: 60),
              ),
            ),
          ),
          actions: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                margin: const EdgeInsets.all(12),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
                  child: Container(
                    height: 20.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Author shimmer
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Container(
                    height: 16.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Description title shimmer
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Container(
                    height: 16.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Description content shimmer
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    children: [
                      Container(
                        height: 14.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 14.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 14.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // Book speciality shimmer
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      3,
                      (index) => Column(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: 60.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            width: 40.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Rating section shimmer
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              children: List.generate(
                                5,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12.w,
                                        height: 12.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Container(
                                          height: 8.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        width: 30.w,
                                        height: 8.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // Comments shimmer
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: SizedBox(
                    height: 110.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        return Container(
                          width: 280.w,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 12.h,
                                          width: 80.w,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Container(
                                          height: 10.h,
                                          width: 60.w,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Container(
                                height: 12.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                height: 12.h,
                                width: 180.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Add comment button shimmer
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Other books section shimmer
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 220.w,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 12.w),
                          itemBuilder: (context, index) {
                            return Container(
                              width: 145.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100.h), // Bottom padding
              ],
            ),
          ),
        ),
      ],
    );
  }
}
