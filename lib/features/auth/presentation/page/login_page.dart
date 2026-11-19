import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/login_model.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_state.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/login_register_button.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/auth_error.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            di<AppRouter>().replaceAll([const CustomNavBarRoute()]);
          } else if (state is LoginError) {
            final message = authErrorMessage(context, state.reason);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.welcomeBack,
                        style: TextStyle(
                          color: CustomColors.orangeColor,
                          fontFamily: context.l10n.localeName == 'ru'
                              ? 'RobotoSlab-Black'
                              : 'Poppins-Black',
                          fontSize: 30.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        isCalendar: false,
                        controller: _phoneNumberController,
                        hintText: 'xx xxxxxxxx',
                        isPrefix: true,
                        isRequired: true,
                        inputType: TextInputType.phone,
                        validator: (value) {
                          // if (value!.isEmpty) {
                          //   return 'Telefon belgiňizi girizmegiňizi haýyş edýaris!';
                          // }
                          // if (!RegExp(
                          //   r'^\+993(61|62|63|64|65|71)\d{6}$',
                          // ).hasMatch(value)) {
                          //   return 'Nädogry telefon belgisi';
                          // }
                          return null;
                        },
                        isPassword: false,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        hintText: context.l10n.password,
                        isPrefix: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return context.l10n.passwordHint;
                          }
                          return null;
                        },
                        isCalendar: false,
                        isPassword: true,
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              di<AppRouter>().push(const ForgotPasswordRoute());
                            },
                            child: Text(
                              context.l10n.forgotPassword,
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          final isLoading = state is LoginLoading;
                          return LoginRegisterButton(
                            onTap: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<LoginCubit>().login(
                                          LoginModel(
                                              phoneNumber:
                                                  '+993${_phoneNumberController.text}',
                                              password:
                                                  _passwordController.text),
                                          context);
                                    }
                                  },
                            width: double.infinity,
                            backgroundColor: CustomColors.orangeColor,
                            child: Text(
                              context.l10n.login,
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.l10n.youDontHaveAnAccount,
                            style: TextStyle(
                              fontFamily: context.l10n.localeName == 'ru'
                                  ? 'Inter-Regular'
                                  : 'Poppins-Regular',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          GestureDetector(
                            onTap: () {
                              di<AppRouter>().replace(const RegisterRoute());
                            },
                            child: Text(
                              context.l10n.register,
                              style: TextStyle(
                                color: CustomColors.orangeColor,
                                decorationColor: CustomColors.orangeColor,
                                fontFamily: context.l10n.localeName == 'ru'
                                    ? 'Inter-Regular'
                                    : 'Poppins-Regular',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state is! LoginLoading) {
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
