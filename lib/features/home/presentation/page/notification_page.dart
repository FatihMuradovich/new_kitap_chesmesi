import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/common/widgets/guest_auth_prompt.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_state.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/notification/notification_cubit.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/notification/notification_state.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/widget/notification_item.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isGuest = false;
  bool _authChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncAuthAndUi());
  }

  Future<void> _syncAuthAndUi() async {
    final dioClient = di<DioClient>();
    final token = await dioClient.getToken();
    final refreshToken =
        await dioClient.secureStorage.read(key: Keys.REFRESH_TOKEN);

    final isLoggedIn = token != null &&
        token.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;

    if (!mounted) return;

    setState(() {
      _isGuest = !isLoggedIn;
      _authChecked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (p, c) => c is LoginSuccess,
          listener: (context, state) => _syncAuthAndUi(),
        ),
        BlocListener<RegisterCubit, RegisterState>(
          listenWhen: (p, c) => c is RegisterSuccess,
          listener: (context, state) => _syncAuthAndUi(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            context.l10n.notification,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 18.sp,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: !_authChecked
            ? Center(
                child: CircularProgressIndicator(
                  color: CustomColors.orangeColor,
                ),
              )
            : _isGuest
                ? const GuestAuthPrompt()
                : BlocProvider(
                    create: (context) =>
                        di<NotificationCubit>()..fetchNotifications(),
                    child: BlocConsumer<NotificationCubit, NotificationState>(
                      listener: (context, state) {
                        if (state is NotificationError) {
                          NotificationHelper.showError(
                            context,
                            context.l10n.errorMessage,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is NotificationLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: CustomColors.orangeColor,
                              strokeWidth: 3,
                            ),
                          );
                        } else if (state is NotificationLoaded) {
                          if (state.notifications.isEmpty) {
                            return _buildEmptyState(context);
                          }
                          return RefreshIndicator(
                            onRefresh: () => context
                                .read<NotificationCubit>()
                                .fetchNotifications(),
                            color: CustomColors.orangeColor,
                            child: ListView.separated(
                              padding: EdgeInsets.all(16.w),
                              itemCount: state.notifications.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 12.h),
                              itemBuilder: (context, index) {
                                final notification = state.notifications[index];
                                return NotificationItem(
                                    notification: notification);
                              },
                            ),
                          );
                        } else if (state is NotificationError) {
                          return _buildErrorState(context, state.message);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 64.sp,
              color: CustomColors.orangeColor,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            context.l10n.notificationIsEmpty,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48.w),
            child: Text(
              context.l10n.notificationIsEmptyDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64.sp,
                color: Colors.red[400],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              context.l10n.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 12.sp,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                context.read<NotificationCubit>().fetchNotifications();
              },
              icon: Icon(Icons.refresh, size: 20.sp),
              label: Text(
                context.l10n.tryAgain,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.orangeColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 32.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
