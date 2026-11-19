// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/forgot_password_model.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/forgot/forgot_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/forgot/forgot_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

import '../../../../common/constants/custom_colors.dart';
import '../../../../common/widgets/custom_button.dart';
import '../widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/auth_error.dart';

// ignore: must_be_immutable
@RoutePage()
// ignore: must_be_immutable
class NewPasswordPage extends StatefulWidget {
  String phoneNumber;
  String code;
  NewPasswordPage({
    super.key,
    required this.phoneNumber,
    required this.code,
  });

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _obscureNewPassword = true;
  final bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Future<void> _changePassword() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() {
  //   });

  //   try {
  //     // TODO: Implement API call to change password
  //     await Future.delayed(const Duration(seconds: 2)); // Simulate API call

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Parolyňyz üstünlikli üýtgedildi!'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );

  //       // Navigate back to login page
  //       Navigator.popUntil(context, (route) => route.isFirst);
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Xäta ýüze çykdy: $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //       });
  //     }
  //   }
  // }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.enterPassword;
    }
    if (value.length < 8) {
      return context.l10n.passwordHintHint;
    }
    // if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
    //   return 'Parol kiçi harf, uly harf we sanamalydyr';
    // }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.confirmPassword;
    }
    if (value != _newPasswordController.text) {
      return context.l10n.confirmPasswordHint;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: CustomColors.blueColor),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),

                // Header Text
                Text(
                  context.l10n.newPasswordHint,
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: CustomColors.orangeColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: context.l10n.localeName == 'ru'
                        ? 'RobotoSlab-Black'
                        : 'Poppins-Black',
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  context.l10n.newPasswordHintHint,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontFamily: context.l10n.localeName == 'ru'
                        ? 'RobotoSlab-Regular'
                        : 'Poppins-Regular',
                  ),
                ),

                SizedBox(height: 40.h),

                // New Password Input
                CustomTextFormField(
                  isCalendar: false,
                  controller: _newPasswordController,
                  hintText: context.l10n.newPasswordHint,
                  isPrefix: false,
                  isRequired: true,
                  isPassword: true,
                  obscureText: _obscureNewPassword,
                  validator: _validatePassword,
                ),

                SizedBox(height: 10.h),

                // Confirm Password Input
                CustomTextFormField(
                  isCalendar: false,
                  controller: _confirmPasswordController,
                  hintText: context.l10n.confirmPassword,
                  isPrefix: false,
                  isRequired: true,
                  isPassword: true,
                  obscureText: _obscureConfirmPassword,
                  validator: _validateConfirmPassword,
                ),

                SizedBox(height: 15.h),

                BlocListener<ForgotCubit, ForgotState>(
                  listener: (context, state) {
                    if (state is ForgotSuccess) {
                      di<AppRouter>().maybePop();
                    } else if (state is ForgotError) {
                      NotificationHelper.showError(
                        context,
                        authErrorMessage(context, state.reason),
                      );
                    }
                  },
                  child: CustomButton(
                    width: double.infinity,
                    backgroundColor: CustomColors.orangeColor,
                    onTap: () {
                      context.read<ForgotCubit>().forgotPasswword(
                          ForgotPasswordModel(
                            phoneNumber: widget.phoneNumber,
                            newPassword: _newPasswordController.text,
                            confirmPassword: _confirmPasswordController.text,
                            code: int.tryParse(widget.code),
                          ),
                          context);
                    },
                    child: Text(
                      context.l10n.continue_button,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: context.l10n.localeName == 'ru'
                            ? 'RobotoSlab-Regular'
                            : 'Poppins-Regular',
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
