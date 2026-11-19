// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatefulWidget {
  TextEditingController? controller;
  final ValidatorFunction? validator;
  final String? hintText;
  final TextInputType? inputType;
  final bool obscureText;
  final bool isRequired;
  final bool isPrefix;
  final bool isCalendar;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final VoidCallback? onPressed;
  List<TextInputFormatter>? formatters;
  Function(String)? onChanged;
  Function(String)? onFieldSubmitted;
  TextAlign? align;
  int maxLines;
  String? initialValue;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction textInputAction;
  CustomTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
    this.inputType,
    this.obscureText = false,
    this.isRequired = false,
    required this.isPrefix,
    required this.isCalendar,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.onPressed,
    this.formatters,
    this.onChanged,
    this.align,
    this.maxLines = 1,
    required bool isPassword,
    this.onFieldSubmitted,
    this.initialValue,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: widget.textInputAction,
      initialValue: widget.initialValue,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      textAlign: widget.align ?? TextAlign.start,
      controller: widget.controller,
      keyboardType: widget.inputType,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onFieldSubmitted,
      inputFormatters: widget.formatters,
      style: TextStyle(
        fontFamily: 'Poppins-regular',
      ),
      validator: widget.validator ??
          (value) {
            // isRequired false ise ve boşsa hata gösterme
            if (!widget.isRequired && (value == null || value.isEmpty)) {
              return null;
            }
            // isRequired true ise ve boşsa hata göster
            if (widget.isRequired && (value == null || value.isEmpty)) {
              return context.l10n.emptyFieldError;
            }
            return null;
          },
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon ??
            (widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.isCalendar
                    ? IconButton(
                        onPressed: widget.onPressed,
                        icon: Icon(
                            Icons.calendar_month),
                      )
                    : null),
        prefixIcon: widget.prefixIcon ??
            (widget.isPrefix
                ? CountryCodePicker(
                    initialSelection: 'TM',
                    textStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
                    enabled: false,
                    showFlag: false,
                  )
                : null),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
            color: Color(0xFF979797), fontFamily: 'Poppins-regular'),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 0.2, color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.blueColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

typedef ValidatorFunction = String? Function(String?)?;
