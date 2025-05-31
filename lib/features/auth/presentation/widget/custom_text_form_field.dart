// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:country_code_picker/country_code_picker.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';

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
  final VoidCallback? onTap;
  final VoidCallback? onPressed;
  List<TextInputFormatter>? formatters;
  Function(String)? onChanged;
  TextAlign? align;
  int maxLines;
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
    this.onTap,
    this.onPressed,
    this.formatters,
    this.onChanged,
    this.align,
    this.maxLines = 1, required bool isPassword,
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
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      textAlign: widget.align ?? TextAlign.start,
      controller: widget.controller,
      keyboardType: widget.inputType,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      inputFormatters: widget.formatters,
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Boş bolup bilmez!';
            }
            return null;
          },
      decoration: InputDecoration(
        suffixIcon:
            widget.obscureText
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
                  icon: Icon(FluentSystemIcons.ic_fluent_calendar_month_filled),
                )
                : null,

        prefixIcon:
            widget.isPrefix
                ? CountryCodePicker(
                  initialSelection: 'TM',
                  textStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
                  enabled: false,
                  showFlag: false,
                )
                : null,

        border: OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Color(0xFF979797)),
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
