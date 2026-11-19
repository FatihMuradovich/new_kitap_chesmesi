import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class BooksPriceFilterResult {
  final double? minPrice;
  final double? maxPrice;

  const BooksPriceFilterResult({
    this.minPrice,
    this.maxPrice,
  });
}

class BooksPriceFilterPage extends StatefulWidget {
  final double? initialMinPrice;
  final double? initialMaxPrice;

  const BooksPriceFilterPage({
    super.key,
    this.initialMinPrice,
    this.initialMaxPrice,
  });

  @override
  State<BooksPriceFilterPage> createState() => _BooksPriceFilterPageState();
}

class _BooksPriceFilterPageState extends State<BooksPriceFilterPage> {
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(
      text: _formatPrice(widget.initialMinPrice),
    );
    _maxPriceController = TextEditingController(
      text: _formatPrice(widget.initialMaxPrice),
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  String _formatPrice(double? price) {
    if (price == null) return '';
    if (price == price.roundToDouble()) {
      return price.toInt().toString();
    }
    return price.toString();
  }

  double? _parsePrice(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed.replaceAll(',', '.'));
  }

  void _applyAndClose() {
    Navigator.of(context).pop(
      BooksPriceFilterResult(
        minPrice: _parsePrice(_minPriceController.text),
        maxPrice: _parsePrice(_maxPriceController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _applyAndClose();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: _applyAndClose,
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          shadowColor: Colors.white,
          centerTitle: false,
          title: Text(
            context.l10n.priceRange,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.priceRangeHint,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 13.sp,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildPriceField(
                        controller: _minPriceController,
                        hint: context.l10n.minPrice,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        '-',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 16.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildPriceField(
                        controller: _maxPriceController,
                        hint: context.l10n.maxPrice,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 16.h),
            child: ElevatedButton(
              onPressed: _applyAndClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.orangeColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                context.l10n.apply,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      style: TextStyle(
        fontFamily: 'Poppins-regular',
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 14.sp,
          color: Colors.black38,
        ),
        suffixText: 'm.',
        suffixStyle: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 14.sp,
          color: Colors.black54,
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
