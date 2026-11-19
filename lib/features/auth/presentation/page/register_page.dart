import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register_code/register_code_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register_code/register_code_state.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.gr.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/login_register_button.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/auth_error.dart';

@RoutePage()
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
  final _referralCodeController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  /// Uygulama diline göre ay isimleri (Türkmençe, Rusça, İngilizce)
  List<String> get _localizedMonths => [
        context.l10n.january,
        context.l10n.february,
        context.l10n.march,
        context.l10n.april,
        context.l10n.may,
        context.l10n.june,
        context.l10n.july,
        context.l10n.august,
        context.l10n.september,
        context.l10n.october,
        context.l10n.november,
        context.l10n.december,
      ];

  Future<void> _selectDate() async {
    // Platform kontrolü
    if (Platform.isIOS) {
      // iOS için Cupertino Style
      await _showCupertinoDatePicker();
    } else {
      // Android/Material Design
      await _showMaterialDatePicker();
    }
  }

  Future<void> _showMaterialDatePicker() async {
    await _showTurkmenDatePicker();
  }

  Future<void> _showTurkmenDatePicker() async {
    DateTime tempDate =
        _selectedDate ?? DateTime.now().subtract(Duration(days: 365 * 18));

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 280.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      color: CustomColors.orangeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            context.l10n.close,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
                              fontFamily: 'Poppins-regular',
                            ),
                          ),
                        ),
                        Text(
                          context.l10n.birthday,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins-regular',
                            color: CustomColors.orangeColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _updateSelectedDate(tempDate);
                            Navigator.pop(context);
                          },
                          child: Text(
                            context.l10n.select,
                            style: TextStyle(
                              color: CustomColors.orangeColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins-regular',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Custom Date Picker
                  Expanded(
                    child: Row(
                      children: [
                        // Day picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: tempDate.day - 1,
                            ),
                            itemExtent: 40.h,
                            onSelectedItemChanged: (int index) {
                              setModalState(() {
                                tempDate = DateTime(
                                    tempDate.year, tempDate.month, index + 1);
                              });
                            },
                            children: List.generate(31, (index) {
                              return Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontFamily: 'Poppins-regular',
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        // Month picker (Türkmençe)
                        Expanded(
                          flex: 2,
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: tempDate.month - 1,
                            ),
                            itemExtent: 40.h,
                            onSelectedItemChanged: (int index) {
                              setModalState(() {
                                tempDate = DateTime(
                                    tempDate.year, index + 1, tempDate.day);
                              });
                            },
                            children: _localizedMonths.map((month) {
                              return Center(
                                child: Text(
                                  month,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontFamily: 'Poppins-regular',
                                    color: CustomColors.orangeColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        // Year picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: DateTime.now().year - tempDate.year,
                            ),
                            itemExtent: 40.h,
                            onSelectedItemChanged: (int index) {
                              setModalState(() {
                                tempDate = DateTime(DateTime.now().year - index,
                                    tempDate.month, tempDate.day);
                              });
                            },
                            children: List.generate(124, (index) {
                              int year = DateTime.now().year - index;
                              return Center(
                                child: Text(
                                  '$year',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontFamily: 'Poppins-regular',
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showCupertinoDatePicker() async {
    await _showTurkmenDatePicker();
  }

  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      final day = date.day.toString().padLeft(2, '0');
      final month = _localizedMonths[date.month - 1];
      final year = date.year.toString();
      _dateController.text = '$day $month $year';
    });
  }

  String _getFormattedDateForApi() {
    if (_selectedDate == null) return '';
    return DateFormat('yyyy-MM-dd').format(_selectedDate!);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _passwordController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<RegisterCodeCubit, RegisterCodeState>(
        listener: (context, state) {
          if (state is RegisterCodeSuccess) {
            final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? false;
            if (!isCurrentRoute) {
              return;
            }
            di<AppRouter>().push(
              OtpRoute(
                type: 'Register',
                name: _nameController.text,
                surname: _surnameController.text,
                password: _passwordController.text,
                referralCode: _referralCodeController.text.isEmpty
                    ? null
                    : 'REF-${_referralCodeController.text}',
                phoneNumber: '+993${_phoneController.text}',
                birthday: _getFormattedDateForApi(),
              ),
            );
          } else if (state is RegisterCodeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authErrorMessage(context, state.reason)),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60.h),
                      Text(
                        context.l10n.register,
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
                        controller: _nameController,
                        hintText: context.l10n.name,
                        inputType: TextInputType.name,
                        isPrefix: false,
                        isRequired: true,
                        isPassword: false,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        isCalendar: false,
                        controller: _surnameController,
                        hintText: context.l10n.surname,
                        inputType: TextInputType.name,
                        isPrefix: false,
                        isRequired: true,
                        isPassword: false,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        isCalendar: false,
                        controller: _phoneController,
                        hintText: "xx xxxxxx",
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
                        hintText:
                            "${context.l10n.birthday} ${context.l10n.optional}",
                        onTap: _selectDate,
                        readOnly: true,
                        isPassword: false,
                        isRequired: false,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        isCalendar: false,
                        obscureText: true,
                        controller: _passwordController,
                        hintText: context.l10n.password,
                        isPrefix: false,
                        isRequired: true,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.passwordHint;
                          }
                          if (value.length < 8) {
                            return context.l10n.passwordHintHint;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        isCalendar: false,
                        obscureText: false,
                        controller: _referralCodeController,
                        hintText:
                            "${context.l10n.referralCode} ${context.l10n.optional}",
                        isPrefix: false,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Center(
                            widthFactor: 1,
                            child: Text(
                              'REF-',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        formatters: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          if (value.length != 6) {
                            return context.l10n.referralCodeHintHint;
                          }
                          return null;
                        },
                        isRequired: false,
                        isPassword: false,
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14.sp,
                            color: CustomColors.orangeColor,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              context.l10n.referralCodeHint,
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 12.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      BlocBuilder<RegisterCodeCubit, RegisterCodeState>(
                        builder: (context, state) {
                          final isLoading = state is RegisterCodeLoading;
                          return LoginRegisterButton(
                              height: 30.h,
                              onTap: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context
                                            .read<RegisterCodeCubit>()
                                            .sendCode(
                                              '+993${_phoneController.text}',
                                              'Register',
                                              context,
                                            );
                                      }
                                    },
                              width: double.infinity,
                              backgroundColor: CustomColors.orangeColor,
                              child: Text(
                                context.l10n.continue_button,
                                style: TextStyle(
                                  fontFamily: context.l10n.localeName == 'ru'
                                      ? 'RobotoSlab-Regular'
                                      : 'Poppins-Regular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ));
                        },
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.l10n.doYouHaveAccount,
                            style: TextStyle(
                              fontFamily: context.l10n.localeName == 'ru'
                                  ? 'RobotoSlab-Regular'
                                  : 'Poppins-Regular',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          GestureDetector(
                            onTap: () {
                              di<AppRouter>().replace(const LoginRoute());
                            },
                            child: Text(
                              context.l10n.login,
                              style: TextStyle(
                                color: CustomColors.orangeColor,
                                decorationColor: CustomColors.orangeColor,
                                fontFamily: context.l10n.localeName == 'ru'
                                    ? 'RobotoSlab-Regular'
                                    : 'Poppins-Regular',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<RegisterCodeCubit, RegisterCodeState>(
              builder: (context, state) {
                if (state is! RegisterCodeLoading) {
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
