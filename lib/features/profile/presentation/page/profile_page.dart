import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/common/widgets/guest_auth_prompt.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/session/end_user_session.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/features/profile/data/data_source/user_data_source.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/page/page_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/page/page_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_state.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_state.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/widget/language_dialog.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/widget/profile_item.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isGuest = false;
  bool _authChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncAuthAndUi());
  }

  /// Token + refresh ile oturumu okur; guest / kullanıcı UI'ını günceller.
  /// Login veya Register ekranı açıkken profil sekmesi arka planda kaldığı için
  /// initState yeniden çalışmaz; bu yüzden [LoginSuccess] / [RegisterSuccess]
  /// dinleyicilerinde de çağrılır.
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

    if (isLoggedIn && mounted) {
      context.read<UserCubit>().fetchUserProfile();
    }
  }

  Future<void> _clearStorageAndLogout() async {
    try {
      await endUserSession(context);

      if (mounted) {
        // Bildirimi göster
        NotificationHelper.showSuccess(
          context,
          context.l10n.signOut,
        );

        // Bildirimin görünmesi için kısa bir süre bekle
        await Future.delayed(const Duration(milliseconds: 500));

        // Login sayfasına yönlendir (Root Navigator kullanarak - NavBar'ı da kaldırır)
        if (mounted) {
          di<AppRouter>().replaceAll([const LoginRoute()]);
        }
      }
    } catch (e) {
      if (mounted) {
        NotificationHelper.showError(
          context,
          context.l10n.errorMessage,
        );
      }
    }
  }

  Future<void> _deleteAccountAndLogout() async {
    try {
      final userDataSource = di<UserDataSource>();
      await userDataSource.deleteAccount();

      if (!mounted) return;
      await endUserSession(context);

      if (mounted) {
        NotificationHelper.showSuccess(
          context,
          context.l10n.accountDeletedSuccessfully,
        );

        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          di<AppRouter>().replaceAll([const LoginRoute()]);
        }
      }
    } catch (e) {
      if (mounted) {
        NotificationHelper.showError(
          context,
          context.l10n.errorMessage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_authChecked) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (prev, curr) => curr is LoginSuccess,
          listener: (context, state) {
            _syncAuthAndUi();
          },
        ),
        BlocListener<RegisterCubit, RegisterState>(
          listenWhen: (prev, curr) => curr is RegisterSuccess,
          listener: (context, state) {
            _syncAuthAndUi();
          },
        ),
      ],
      child: Scaffold(
      appBar: AppBar(title: Text(context.l10n.profil)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_isGuest) const GuestAuthPrompt(),
              if (!_isGuest)
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            color: CustomColors.orangeColor,
                          ),
                        ),
                      );
                    } else if (state is UserLoaded) {
                      final user = state.user;
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.get_coupon,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    user.referral.toString(),
                                    style: TextStyle(
                                      color: CustomColors.orangeColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins-black',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is UserError) {
                      return Container(
                        margin: const EdgeInsets.all(16.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red[300]!),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[600],
                              size: 40,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              context.l10n.errorMessage,
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 14.sp,
                                fontFamily: 'Poppins-regular',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            ElevatedButton(
                              onPressed: () {
                                context.read<UserCubit>().fetchUserProfile();
                              },
                              child: Text(context.l10n.tryAgain),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              if (!_isGuest)
                SizedBox(
                  height: 10.h,
                ),
              if (!_isGuest)
                ProfileItem(
                  ontap: () async {
                    final currentState = context.read<UserCubit>().state;
                    if (currentState is UserLoaded) {
                      final result = await di<AppRouter>().push(
                        UserEditRoute(user: currentState.user),
                      );
                      if (result != null && context.mounted) {
                        context.read<UserCubit>().fetchUserProfile();
                      }
                    }
                  },
                  icon: 'assets/icons/person_light.png',
                  title: context.l10n.myProfile,
                ),
              if (!_isGuest)
                ProfileItem(
                  ontap: () {
                    di<AppRouter>().push(const MyOrdersRoute());
                  },
                  icon: 'assets/icons/rule_light.png',
                  title: context.l10n.myOrders,
                ),
              if (!_isGuest)
                ProfileItem(
                  ontap: () {
                    di<AppRouter>().push(const CouponRoute());
                  },
                  icon: 'assets/icons/coupon_light.png',
                  title: context.l10n.coupon,
                ),
              if (!_isGuest)
                ProfileItem(
                  ontap: () {
                    di<AppRouter>().push(const ContactRoute());
                  },
                  icon: 'assets/icons/comment_light.png',
                  title: context.l10n.contact,
                ),
              BlocBuilder<PageCubit, PageState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      ProfileItem(
                        ontap: () {
                          di<AppRouter>().push(const AboutUsRoute());
                        },
                        icon: 'assets/icons/info_light.png',
                        title: context.l10n.aboutUs,
                      ),
                      ProfileItem(
                        ontap: () {
                          di<AppRouter>().push(const TermsOfUseRoute());
                        },
                        icon: 'assets/icons/rule_light.png',
                        title: context.l10n.rules,
                      ),
                      ProfileItem(
                        ontap: () {
                          di<AppRouter>().push(const PrivacyPolicyRoute());
                        },
                        icon: 'assets/icons/insurance_light.png',
                        title: context.l10n.privacy,
                      ),
                    ],
                  );
                },
              ),
              ProfileItem(
                ontap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const LanguageDialog();
                    },
                  );
                },
                icon: 'assets/icons/globe_light.png',
                title: context.l10n.language,
              ),
              if (!_isGuest)
                ProfileItem(
                  ontap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        var alertDialog = AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            context.l10n.signOut,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            context.l10n.signOutDescription,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 14.sp,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: Text(
                                context.l10n.no,
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                _clearStorageAndLogout();
                              },
                              child: Text(
                                context.l10n.yes,
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 14.sp,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                        return alertDialog;
                      },
                    );
                  },
                  icon: 'assets/icons/sign_light.png',
                  title: context.l10n.signOut,
                ),
              if (!_isGuest)
                ProfileItem(
                  icon: 'assets/icons/delete.png',
                  title: context.l10n.deleteAccount,
                  ontap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          context.l10n.deleteAccount,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          context.l10n.deleteAccountDescription,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14.sp,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Text(
                              context.l10n.no,
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              _deleteAccountAndLogout();
                            },
                            child: Text(
                              context.l10n.yes,
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14.sp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
