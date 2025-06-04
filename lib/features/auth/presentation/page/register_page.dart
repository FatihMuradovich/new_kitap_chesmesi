import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/page/login_page.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/login_register_button.dart';
import 'package:new_kitap_chesmesi/features/navBar/custom_nav_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate() async {
    // Platform kontrolü
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // iOS için Cupertino Style
      await _showCupertinoDatePicker();
    } else {
      // Android/Material Design
      await _showMaterialDatePicker();
    }
  }

  Future<void> _showMaterialDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurpleAccent,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      _updateSelectedDate(picked);
    }
  }

  Future<void> _showCupertinoDatePicker() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 320.w,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 250.w,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate ?? DateTime.now(),
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    _updateSelectedDate(newDate);
                  },
                ),
              ),
              CupertinoButton(
                child: Text('Saýla'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _dateController.text = DateFormat('yyyy-MM-dd', 'en').format(date);
    });
  }
  // DateTime? _selectedDate;

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     locale: Locale('en'),
  //     context: context,
  //     // cancelText: 'Ýok',
  //     // confirmText: 'Hawa',
  //     initialDate: DateTime.now().subtract(
  //       Duration(days: 365 * 18),
  //     ), // 18 yıl önce
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           colorScheme: ColorScheme.light(surface: Colors.white),
  //           dialogTheme: DialogThemeData(backgroundColor: Colors.white),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );

  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //       _birthDateController.text = DateFormat('dd-MM-yyyy').format(picked);
  //     });
  //   }
  // }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hasap açmak!',
                  style: TextStyle(
                    // color: Colors.white,
                    color: CustomColors.orangeColor,
                    fontFamily: 'Poppins-black',
                    fontSize: 28.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  isCalendar: false,
                  controller: _nameController,
                  hintText: 'Adyňyz',
                  inputType: TextInputType.name,
                  isPrefix: false,
                  isRequired: true,
                  isPassword: false,
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  isCalendar: false,
                  controller: _surnameController,
                  hintText: 'Familiýaňyz',
                  inputType: TextInputType.name,
                  isPrefix: false,
                  isRequired: true,
                  isPassword: false,
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  isCalendar: false,
                  controller: _phoneController,
                  hintText: 'Telefon belgiňiz',
                  isPrefix: true,
                  isRequired: true,
                  inputType: TextInputType.phone,
                  isPassword: false,
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  controller: _dateController,
                  isPrefix: false,
                  isCalendar: true,
                  hintText: 'Doglan senäniz',
                  onTap: _selectDate,
                  readOnly: true,
                  isPassword: false,
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  isCalendar: false,
                  obscureText: true,
                  controller: _passwordController,
                  hintText: 'Parolyňyz',
                  isPrefix: false,
                  isRequired: true,
                  isPassword: true,
                ),
                SizedBox(height: 10.h),
                BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    print(state);
                    if (state is AuthSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CustomNavBar()),
                      );
                    }
                    if (state is AuthError) {
                      ScaffoldMessenger(
                        child: SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  child: LoginRegisterButton(
                    onTap: () {
                      
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().register(
                              name: _nameController.text,
                              surname: _surnameController.text,
                              birthday: _dateController.text,
                              phone: "+993${_phoneController.text}",
                              password: _passwordController.text,
                            );
                      }
                    },
                    width: double.infinity,
                    backgroundColor: CustomColors.orangeColor,
                    child: Text(
                      'Hasap dörediň',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Häzirki wagtda hasabyňyz barmy?',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Içeri girmek',
                        style: TextStyle(
                          color: CustomColors.orangeColor,
                          fontFamily: 'Poppins-regular',
                          fontSize: 13.sp,
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
