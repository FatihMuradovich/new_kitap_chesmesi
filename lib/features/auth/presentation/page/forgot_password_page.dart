import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register_code/register_code_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register_code/register_code_state.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/login_register_button.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import '../../../../common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/auth_error.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocListener<RegisterCodeCubit, RegisterCodeState>(
          listener: (context, state) {
            if (state is RegisterCodeSuccess) {
              // Kod başarıyla gönderildiyse OTP sayfasına git
              di<AppRouter>().replace(
                OtpRoute(
                  type: 'Forgot',
                  phoneNumber: '+993${_phoneController.text}',
                ),
              );
            } else if (state is RegisterCodeError) {
              // Hata varsa mesaj göster
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authErrorMessage(context, state.reason)),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Header Text
                  Text(
                    context.l10n.forgotPasswordDescription,
                    style: TextStyle(
                      color: CustomColors.orangeColor,
                      fontFamily: context.l10n.localeName == 'ru'
                          ? 'RobotoSlab-Black'
                          : 'Poppins-Black',
                      fontSize: 24.sp,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    context.l10n.forgotPasswordDescriptionHint,
                    style: TextStyle(
                      fontFamily: context.l10n.localeName == 'ru'
                          ? 'RobotoSlab-Regular'
                          : 'Poppins-Regular',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Phone Number Input
                  CustomTextFormField(
                    isCalendar: false,
                    controller: _phoneController,
                    hintText: "xx xxxxxx",
                    isPrefix: true,
                    isRequired: true,
                    inputType: TextInputType.phone,
                    isPassword: false,
                  ),

                  SizedBox(height: 15.h),

                  // Send OTP Button
                  BlocBuilder<RegisterCodeCubit, RegisterCodeState>(
                    builder: (context, state) {
                      if (state is RegisterCodeLoading) {
                        return Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: CustomColors.orangeColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                      return LoginRegisterButton(
                        width: double.infinity,
                        backgroundColor: CustomColors.orangeColor,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // Önce kod gönder, başarılıysa OTP sayfasına git (listener'da yapılıyor)
                            context.read<RegisterCodeCubit>().sendCode(
                                  '+993${_phoneController.text}',
                                  'ForgotPassword',
                                  context,
                                );
                          }
                        },
                        child: Text(
                          context.l10n.sendVerificationCode,
                          style: TextStyle(
                            fontFamily: context.l10n.localeName == 'ru'
                                ? 'RobotoSlab-Regular'
                                : 'Poppins-Regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),

                  // const Spacer(),

                  // Help Text
                  // Center(
                  //   child: Text(
                  //     'Kömek gerekmi? Biz bilen habarlaşyň',
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       color: Colors.grey[600],
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
