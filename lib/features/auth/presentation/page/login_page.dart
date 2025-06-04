import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/page/forgot_password_page.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/page/register_page.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/login_register_button.dart';
import 'package:new_kitap_chesmesi/features/navBar/custom_nav_bar.dart';

// ignore: must_be_immutable
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Täzeden hoş gördük!',
                  style: TextStyle(
                    color: CustomColors.orangeColor,
                    fontFamily: 'Poppins-black',
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
                    // return null;
                  },
                  isPassword: false,
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  hintText: 'Parolyňyz',
                  isPrefix: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ('Parolyňyzy giriziň!');
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Açar sözi unutdum',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                // Use BlocListener for side effects like navigation and showing Snackbars
                BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      // Perform navigation here
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CustomNavBar()),
                      );
                    } else if (state is AuthError) {
                      // Show SnackBar here. Corrected syntax for showing a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  // Keep BlocBuilder for UI updates (like showing a loading indicator)
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      // You might want to show a loading indicator or disable the button
                      // if (state is AuthLoading) {
                      //   return CircularProgressIndicator();
                      // }
                      return LoginRegisterButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                                  phone: '+993${_phoneNumberController.text}',
                                  password: _passwordController.text,
                                );
                          }
                        },
                        width: double.infinity,
                        backgroundColor: CustomColors.orangeColor,
                        child: Text(
                          'Içeri girmek',
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hasabyňyz ýokmy?',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Hasap dörediň',
                        style: TextStyle(
                          color: CustomColors.orangeColor,
                          fontFamily: 'Poppins-regular',
                          fontSize: 12.sp,
                          decorationColor: CustomColors.orangeColor,
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
    );
  }
}