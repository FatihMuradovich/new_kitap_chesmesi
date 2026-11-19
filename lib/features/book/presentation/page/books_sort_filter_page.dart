import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_sort_option.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/filter/filter_checkbox_row.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class BooksSortFilterPage extends StatefulWidget {
  final BookSortOption? initialSort;

  const BooksSortFilterPage({
    super.key,
    this.initialSort,
  });

  @override
  State<BooksSortFilterPage> createState() => _BooksSortFilterPageState();
}

class _BooksSortFilterPageState extends State<BooksSortFilterPage> {
  BookSortOption? _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.initialSort;
  }

  void _selectSort(BookSortOption sort) {
    setState(() {
      _selectedSort = _selectedSort == sort ? null : sort;
    });
  }

  void _applyAndClose() {
    Navigator.of(context).pop(_selectedSort);
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
            context.l10n.sort,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: BookSortOption.values.length,
            separatorBuilder: (_, __) => filterCheckboxDivider(),
            itemBuilder: (context, index) {
              final sort = BookSortOption.values[index];
              final label = _sortLabel(context, sort);
              return FilterCheckboxRow(
                label: label,
                isSelected: _selectedSort == sort,
                onTap: () => _selectSort(sort),
              );
            },
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

  String _sortLabel(BuildContext context, BookSortOption sort) {
    switch (sort) {
      case BookSortOption.priceAsc:
        return context.l10n.priceAsc;
      case BookSortOption.priceDesc:
        return context.l10n.priceDesc;
      case BookSortOption.mostPurchased:
        return context.l10n.mostPurchased;
    }
  }
}

extension BookSortOptionLabel on BookSortOption {
  String get label {
    switch (this) {
      case BookSortOption.priceAsc:
        return 'Arzandan - Gymmada';
      case BookSortOption.priceDesc:
        return 'Gymmatdan - Arzana';
      case BookSortOption.mostPurchased:
        return 'Iň köp satylanlar';
    }
  }
}
