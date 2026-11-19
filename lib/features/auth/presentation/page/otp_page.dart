import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';

import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import 'package:pinput/pinput.dart';

import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register_code/register_code_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register_code/register_code_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/auth_error.dart';

// ignore: must_be_immutable
@RoutePage()
// ignore: must_be_immutable
class OtpPage extends StatefulWidget {
  String type;
  String? name;
  String? surname;
  String? password;
  String phoneNumber;
  String? birthday;
  String? referralCode;
  OtpPage({
    super.key,
    required this.type,
    this.name,
    this.surname,
    this.password,
    required this.phoneNumber,
    this.birthday,
    this.referralCode,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _pinController = TextEditingController();
  static const int _initialSeconds = 60;
  int _remainingSeconds = _initialSeconds;
  Timer? _timer;

  bool get _canResend => _remainingSeconds == 0;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _initialSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remainingSeconds == 0) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });
    });
  }

  Future<void> _resendCode() async {
    final requestType = widget.type == 'Forgot' ? 'ForgotPassword' : 'Register';
    await context
        .read<RegisterCodeCubit>()
        .sendCode(widget.phoneNumber, requestType, context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                di<AppRouter>().replace(const OnboardingCategoryRoute());
              } else if (state is RegisterError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(authErrorMessage(context, state.reason))),
                );
              }
            },
          ),
          BlocListener<RegisterCodeCubit, RegisterCodeState>(
            listener: (context, state) {
              if (state is RegisterCodeSuccess) {
                _pinController.clear();
                _startResendTimer();
                NotificationHelper.showSuccess(
                  context,
                  context.l10n.newCodeSent,
                );
              } else if (state is RegisterCodeError) {
                NotificationHelper.showError(
                  context,
                  authErrorMessage(context, state.reason),
                );
              }
            },
          ),
        ],
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      context.l10n.verificationCode,
                      style: TextStyle(
                        fontFamily: context.l10n.localeName == 'ru'
                            ? 'RobotoSlab-Black'
                            : 'Poppins-Black',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.orangeColor,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Text(
                      textAlign: TextAlign.center,
                      context.l10n.localeName == 'ru'
                          ? 'Введите OTP-код подтверждения, отправленный на номер ${widget.phoneNumber}'
                          : '${widget.phoneNumber} belgä ugradylan Otp tassyklama koduny giriziň',
                      style: TextStyle(
                          fontFamily: context.l10n.localeName == 'ru'
                              ? 'RobotoSlab-Regular'
                              : 'Poppins-Regular',
                          fontSize: 14.sp),
                    ),
                    SizedBox(height: 25.h),
                    Align(
                      alignment: Alignment.center,
                      child: Pinput(
                        keyboardType: TextInputType.number,
                        animationCurve: Curves.easeInOut,
                        controller: _pinController,
                        autofocus: true,
                        showCursor: true,
                        textInputAction: TextInputAction.next,
                        length: 6,
                        obscuringCharacter: '*',
                        onCompleted: (value) {
                          if (value == _pinController.text) {
                            if (widget.type == 'Register') {
                              context.read<RegisterCubit>().register(
                                  RegisterModel(
                                    userDetailModel: UserDetailModel(
                                      name: widget.name,
                                      surname: widget.surname,
                                      phoneNumber: widget.phoneNumber,
                                      password: widget.password,
                                      birthday: widget.birthday,
                                      referralCode: widget.referralCode,
                                      code: value,
                                    ),
                                  ),
                                  context);
                            } else if (widget.type == 'Forgot') {
                              di<AppRouter>().replace(
                                NewPasswordRoute(
                                  phoneNumber: widget.phoneNumber,
                                  code: value,
                                ),
                              );
                            }
                          } else {
                            NotificationHelper.showError(
                              context,
                              context.l10n.invalidCodeEntered,
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.dontReceiveCode,
                          style: TextStyle(
                            fontFamily: context.l10n.localeName == 'ru'
                                ? 'RobotoSlab-Regular'
                                : 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        BlocBuilder<RegisterCodeCubit, RegisterCodeState>(
                          builder: (context, state) {
                            final isLoading = state is RegisterCodeLoading;
                            final isEnabled = _canResend && !isLoading;
                            final resendText = _canResend
                                ? context.l10n.resendCode
                                : '${context.l10n.resendCode} (00:${_remainingSeconds.toString().padLeft(2, '0')})';

                            return TextButton(
                              onPressed: isEnabled ? _resendCode : null,
                              style: TextButton.styleFrom(
                                foregroundColor: isEnabled
                                    ? CustomColors.orangeColor
                                    : Colors.grey,
                                disabledForegroundColor: Colors.grey,
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      height: 18.h,
                                      width: 18.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      resendText,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            context.l10n.localeName == 'ru'
                                                ? 'RobotoSlab-Regular'
                                                : 'Poppins-Regular',
                                        fontSize: 12.sp,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // BlocBuilder<RegisterCubit, RegisterState>(
                    //   builder: (context, state) {
                    //     if (state is RegisterLoading) {
                    //       return Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     }
                    //     if (state is RegisterSuccess) {
                    //       Navigator.push(context,
                    //           MaterialPageRoute(builder: (context) => CustomNavBar()));
                    //     }
                    //     return LoginRegisterButton(
                    //       onTap: () {},
                    //       width: double.infinity,
                    //       backgroundColor: CustomColors.orangeColor,
                    //       child: Text(
                    //         'Register',
                    //         style: TextStyle(
                    //           fontFamily: 'Poppins-regular',
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 16.sp,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // )
                  ],
                ),
              ),
            ),
            BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                if (state is! RegisterLoading) {
                  return const SizedBox.shrink();
                }
                return Positioned.fill(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.35),
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 150.h,
                        width: 150.w,
                        child: Lottie.asset(
                          'assets/animations/Open book.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
