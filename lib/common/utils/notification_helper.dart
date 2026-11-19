import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationHelper {
  /// Shows a top notification with custom message and background color
  /// 
  /// [context] - BuildContext for accessing overlay
  /// [message] - Message to display
  /// [backgroundColor] - Optional background color (defaults to red for error)
  /// [duration] - Optional duration (defaults to 2 seconds)
  /// [icon] - Optional icon (defaults to error_outline for red, check_circle for others)
  static void showTopNotification(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
    IconData? icon,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.red,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    icon ??
                        (backgroundColor == Colors.red
                            ? Icons.error_outline
                            : Icons.check_circle),
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  /// Shows a success notification (green background with check icon)
  static void showSuccess(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2)}) {
    showTopNotification(
      context,
      message,
      backgroundColor: Colors.green,
      duration: duration,
      icon: Icons.check_circle,
    );
  }

  /// Shows an error notification (red background with error icon)
  static void showError(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2)}) {
    showTopNotification(
      context,
      message,
      backgroundColor: Colors.red,
      duration: duration,
      icon: Icons.error_outline,
    );
  }

  /// Shows a warning notification (orange background with warning icon)
  static void showWarning(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2)}) {
    showTopNotification(
      context,
      message,
      backgroundColor: Colors.red,
      duration: duration,
      icon: Icons.warning_amber_rounded,
    );
  }

  /// Shows an info notification (blue background with info icon)
  static void showInfo(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2)}) {
    showTopNotification(
      context,
      message,
      backgroundColor: Colors.blue,
      duration: duration,
      icon: Icons.info_outline,
    );
  }
}

