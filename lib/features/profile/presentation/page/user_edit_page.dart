import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_state.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class UserEditPage extends StatefulWidget {
  final UserDetailModel? user;

  const UserEditPage({super.key, this.user});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  bool _isInitialized = false;

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

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;

    if (_selectedDate != null) {
      _birthDateController.text = _formatDateToLocalized(_selectedDate!);
    } else {
      // Doğum günü null ise text'i temizle ki hintText gözüksün.
      _birthDateController.text = '';
    }

    _isInitialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _initializeUserData() {
    if (widget.user == null) return;

    _nameController.text = widget.user!.name ?? '';
    _surnameController.text = widget.user!.surname ?? '';
    _phoneController.text = widget.user!.phoneNumber ?? '';

    if (widget.user!.birthday?.isNotEmpty ?? false) {
      try {
        _selectedDate = DateTime.parse(widget.user!.birthday!);
      } catch (e) {
        _selectedDate = null;
      }
    }
  }

  String _formatDateToLocalized(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = _localizedMonths[date.month - 1];
    final year = date.year.toString();
    return '$day $month $year';
  }

  String _formatDateToApi(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  String? _validateRequired(String? value, String fieldName) {
    if (value?.trim().isEmpty ?? true) {
      return '$fieldName boş olamaz';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return context.l10n.phoneNumberCannotBeEmpty;
    }
    if (!RegExp(r'^\+?[0-9]+$').hasMatch(value!.trim())) {
      return context.l10n.invalidPhoneNumber;
    }
    return null;
  }

  void _updateProfile() {
    if (!_formKey.currentState!.validate()) return;

    context.read<UserCubit>().updateUserProfile(
          name: _nameController.text.trim(),
          surname: _surnameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          birthday:
              _selectedDate != null ? _formatDateToApi(_selectedDate!) : '',
        );
  }

  Future<void> _showDatePicker() async {
    DateTime tempDate = _selectedDate ??
        DateTime.now().subtract(const Duration(days: 365 * 25));

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.r),
                ),
              ),
              child: Column(
                children: [
                  _buildDatePickerHeader(tempDate),
                  Expanded(
                    child: _buildDatePickerBody(tempDate, setModalState),
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

  Widget _buildDatePickerHeader(DateTime tempDate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: CustomColors.orangeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
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
              setState(() {
                _selectedDate = tempDate;
                _birthDateController.text = _formatDateToLocalized(tempDate);
              });
              Navigator.pop(context);
            },
            child: Text(
              context.l10n.select,
              style: TextStyle(
                color: CustomColors.orangeColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins-regular',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerBody(DateTime tempDate, StateSetter setModalState) {
    return Row(
      children: [
        _buildDayPicker(tempDate, setModalState),
        _buildMonthPicker(tempDate, setModalState),
        _buildYearPicker(tempDate, setModalState),
      ],
    );
  }

  Widget _buildDayPicker(DateTime tempDate, StateSetter setModalState) {
    return Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: tempDate.day - 1,
        ),
        itemExtent: 40.h,
        onSelectedItemChanged: (index) {
          setModalState(() {
            tempDate = DateTime(tempDate.year, tempDate.month, index + 1);
          });
        },
        children: List.generate(
          31,
          (index) => Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins-regular'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthPicker(DateTime tempDate, StateSetter setModalState) {
    return Expanded(
      flex: 2,
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: tempDate.month - 1,
        ),
        itemExtent: 40.h,
        onSelectedItemChanged: (index) {
          setModalState(() {
            tempDate = DateTime(tempDate.year, index + 1, tempDate.day);
          });
        },
        children: _localizedMonths
            .map(
              (month) => Center(
                child: Text(
                  month,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: 'Poppins-regular',
                    color: CustomColors.orangeColor,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildYearPicker(DateTime tempDate, StateSetter setModalState) {
    final currentYear = DateTime.now().year;
    return Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: currentYear - tempDate.year,
        ),
        itemExtent: 40.h,
        onSelectedItemChanged: (index) {
          setModalState(() {
            tempDate =
                DateTime(currentYear - index, tempDate.month, tempDate.day);
          });
        },
        children: List.generate(
          124,
          (index) {
            final year = currentYear - index;
            return Center(
              child: Text(
                '$year',
                style:
                    TextStyle(fontSize: 16.sp, fontFamily: 'Poppins-regular'),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myProfile),
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.profileUpdatedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _nameController,
                      hintText: context.l10n.name,
                      isPrefix: false,
                      isCalendar: false,
                      isPassword: false,
                      validator: (value) =>
                          _validateRequired(value, context.l10n.name),
                    ),
                    SizedBox(height: 16.h),
                    CustomTextFormField(
                      controller: _surnameController,
                      hintText: context.l10n.surname,
                      isPrefix: false,
                      isCalendar: false,
                      isPassword: false,
                      validator: (value) =>
                          _validateRequired(value, context.l10n.surname),
                    ),
                    SizedBox(height: 16.h),
                    CustomTextFormField(
                      controller: _phoneController,
                      hintText: context.l10n.your_phone_number,
                      isPrefix: false,
                      isCalendar: false,
                      isPassword: false,
                      validator: _validatePhone,
                    ),
                    SizedBox(height: 16.h),
                    CustomTextFormField(
                      controller: _birthDateController,
                      hintText: context.l10n.birthday,
                      isPrefix: false,
                      isCalendar: true,
                      isPassword: false,
                      readOnly: true,
                      onTap: _showDatePicker,
                      // Doğum günü optional: boş bırakılırsa hata vermesin.
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomButton(
                      onTap: state is UserLoading ? null : _updateProfile,
                      width: double.infinity,
                      backgroundColor: state is UserLoading
                          ? Colors.grey
                          : CustomColors.orangeColor,
                      child: state is UserLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              context.l10n.save,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
