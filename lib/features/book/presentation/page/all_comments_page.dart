import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/comment/comment_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/comment/comment_state.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/comment_item.dart';
import 'package:new_kitap_chesmesi/common/utils/auth_guard.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class AllCommentsPage extends StatefulWidget {
  final int bookId;
  final String bookTitle;

  const AllCommentsPage({
    super.key,
    required this.bookId,
    required this.bookTitle,
  });

  @override
  State<AllCommentsPage> createState() => _AllCommentsPageState();
}

class _AllCommentsPageState extends State<AllCommentsPage> {
  // Sayfaya özel: global olsaydı açık olan detay sayfasının yorumlarını ezerdi.
  late final CommentCubit _commentCubit = di<CommentCubit>();

  @override
  void initState() {
    super.initState();
    _commentCubit.getCommentsByBookId(widget.bookId);
  }

  @override
  void dispose() {
    _commentCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _commentCubit,
      child: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.ratingsAndComments,
        ),
      ),
      body: BlocBuilder<CommentCubit, CommentState>(
        builder: (context, state) {
          if (state is CommentLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: CustomColors.orangeColor,
              ),
            );
          } else if (state is CommentLoaded) {
            if (state.comments.isEmpty) {
              return _buildEmptyState();
            }

            // Calculate rating statistics
            final comments = state.comments;
            double averageRating = 0.0;
            int totalRatings = comments.length;
            Map<int, int> ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

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

            return Column(
              children: [
                // Rating Summary Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Average Rating Display
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Text(
                              averageRating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 32.sp,
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
                              itemSize: 20.sp,
                              direction: Axis.horizontal,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '$totalRatings ${context.l10n.rating}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20.w),
                      // Rating Breakdown
                      Expanded(
                        child: Column(
                          children: [
                            _buildRatingBar(
                                5,
                                totalRatings > 0
                                    ? ratingCounts[5]! / totalRatings
                                    : 0.0,
                                ratingCounts[5]!),
                            _buildRatingBar(
                                4,
                                totalRatings > 0
                                    ? ratingCounts[4]! / totalRatings
                                    : 0.0,
                                ratingCounts[4]!),
                            _buildRatingBar(
                                3,
                                totalRatings > 0
                                    ? ratingCounts[3]! / totalRatings
                                    : 0.0,
                                ratingCounts[3]!),
                            _buildRatingBar(
                                2,
                                totalRatings > 0
                                    ? ratingCounts[2]! / totalRatings
                                    : 0.0,
                                ratingCounts[2]!),
                            _buildRatingBar(
                                1,
                                totalRatings > 0
                                    ? ratingCounts[1]! / totalRatings
                                    : 0.0,
                                ratingCounts[1]!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Comments List
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: comments.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return CommentItem(
                        comment: comment,
                        isHorizontal: false,
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is CommentError) {
            return _buildErrorState(state.message);
          }
          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddComment(),
        backgroundColor: CustomColors.orangeColor,
        label: Text(
          context.l10n.addComment,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins-regular',
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(
          Icons.add_comment,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '$stars',
            style: TextStyle(fontSize: 14.sp, fontFamily: 'Poppins-regular'),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 6,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              fontFamily: 'Poppins-regular',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.comment_outlined,
              size: 80.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24.h),
            Text(
              context.l10n.commentsEmpty,
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'Poppins-regular',
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              context.l10n.writeFirstComment,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Poppins-regular',
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddComment(),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.orangeColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Icon(Icons.add_comment, color: Colors.white),
              label: Text(
                context.l10n.sendComment,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80.sp,
              color: Colors.red[400],
            ),
            SizedBox(height: 24.h),
            Text(
              context.l10n.commentsError,
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: 'Poppins-regular',
                color: Colors.red[600],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Poppins-regular',
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () {
                _commentCubit.getCommentsByBookId(widget.bookId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.orangeColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Icon(Icons.refresh, color: Colors.white),
              label: Text(
                context.l10n.tryAgain,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddComment() async {
    final ok = await ensureLoggedIn(context);
    if (!ok || !mounted) return;

    final result = await di<AppRouter>().push(
      AddCommentRoute(
        bookId: widget.bookId,
        bookTitle: widget.bookTitle,
      ),
    );

    // If comment was added successfully, refresh comments
    if (result == true && mounted) {
      _commentCubit.getCommentsByBookId(widget.bookId);
    }
  }
}
