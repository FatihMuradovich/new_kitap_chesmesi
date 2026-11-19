import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class CommentItem extends StatelessWidget {
  final dynamic comment;
  final bool isHorizontal;
  final double? width;

  const CommentItem({
    super.key,
    required this.comment,
    this.isHorizontal = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _buildHorizontalCommentItem(context);
    } else {
      return _buildVerticalCommentItem(context);
    }
  }

  Widget _buildHorizontalCommentItem(BuildContext context) {
    return Container(
      width: width ?? 280.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: CustomColors.blueColor,
                child: Text(
                  comment.userName?.isNotEmpty == true
                      ? comment.userName![0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Poppins-regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName ?? 'Ulanyjy',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-regular',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: comment.ratingValue,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 12,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            _formatDate(comment.createdAt, context),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                              fontFamily: 'Poppins-regular',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Comment Text
          Expanded(
            child: Text(
              comment.comment,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Poppins-regular',
                color: Colors.black87,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalCommentItem(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: CustomColors.blueColor,
                child: Text(
                  comment.userName?.isNotEmpty == true
                      ? comment.userName![0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins-regular',
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName ?? 'Ulanyjy',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: comment.ratingValue,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 14.sp,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _formatDate(comment.createdAt, context),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                            fontFamily: 'Poppins-regular',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Comment Text
          Text(
            comment.comment,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'Poppins-regular',
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString, BuildContext context) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} ${context.l10n.daysAgo}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${context.l10n.hoursAgo}';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${context.l10n.minutesAgo}';
      } else {
        return context.l10n.now;
      }
    } catch (e) {
      return dateString;
    }
  }
}
