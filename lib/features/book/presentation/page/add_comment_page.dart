import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/comment/comment_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/comment/comment_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class AddCommentPage extends StatefulWidget {
  final int bookId;
  final String bookTitle;

  const AddCommentPage({
    super.key,
    required this.bookId,
    required this.bookTitle,
  });

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final TextEditingController _commentController = TextEditingController();
  double _selectedRating = 0;
  bool _isSubmitting = false;
  late final CommentCubit _commentCubit = di<CommentCubit>();

  @override
  void dispose() {
    _commentController.dispose();
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
          context.l10n.addComment,
        ),
      ),
      body: BlocListener<CommentCubit, CommentState>(
        listener: (context, state) {
          if (state is CommentCreateLoading) {
            _isSubmitting = true;
          } else if (state is CommentCreated) {
            _isSubmitting = false;

            NotificationHelper.showSuccess(
              context,
              context.l10n.commentAddedSuccessfully,
            );

            Navigator.of(context)
                .pop(true); // true döndürerek yenileme sinyali gönder
          } else if (state is CommentCreateError) {
            _isSubmitting = false;

            NotificationHelper.showError(
              context,
              context.l10n.errorMessage,
              duration: const Duration(seconds: 3),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.blueColor),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: _selectedRating,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 32.sp,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _selectedRating = rating;
                        });
                      },
                      tapOnlyMode: false,
                      glow: false,
                    ),
                    SizedBox(height: 8.h),
                    if (_selectedRating > 0) ...[
                      Text(
                        _selectedRating % 1 == 0
                            ? '${_selectedRating.toInt()} ${context.l10n.stars}'
                            : '${_selectedRating.toStringAsFixed(1)} ${context.l10n.stars}',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: CustomColors.orangeColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedRating = 0;
                          });
                        },
                        child: Text(
                          context.l10n.clearRating,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ] else
                      Text(
                        context.l10n.ratingNotSelected,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 15.h),

              // Comment Yazma
              Text(
                context.l10n.commentHint,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 5,
                  onChanged: (value) {
                    setState(() {
                      // TextField değiştiğinde butonu güncelle
                    });
                  },
                  decoration: InputDecoration(
                    hintText: context.l10n.comment,
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins-regular',
                      color: Colors.grey[500],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: CustomColors.blueColor),
                    ),
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14.sp,
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // Gönder Butonu
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  backgroundColor: CustomColors.orangeColor,
                  onTap: _isSubmitting || _commentController.text.trim().isEmpty
                      ? null
                      : _submitComment,
                  child: _isSubmitting
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          context.l10n.sendComment,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 16.h),

              // Bilgilendirme
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[600],
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        context.l10n.commentInfo,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Poppins-regular',
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) {
      NotificationHelper.showWarning(
        context,
        context.l10n.commentInfoHint,
      );
      return;
    }

    _commentCubit.createComment(
      comment: _commentController.text.trim(),
      rating: _selectedRating,
      bookId: widget.bookId,
    );
  }
}
