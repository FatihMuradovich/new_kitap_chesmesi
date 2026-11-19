import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_language_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_language_repository.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/filter/filter_checkbox_row.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class BooksLanguageFilterPage extends StatefulWidget {
  final List<int> initialLanguageIds;

  const BooksLanguageFilterPage({
    super.key,
    this.initialLanguageIds = const [],
  });

  @override
  State<BooksLanguageFilterPage> createState() =>
      _BooksLanguageFilterPageState();
}

class _BooksLanguageFilterPageState extends State<BooksLanguageFilterPage> {
  final _repository = di<BookLanguageRepository>();
  late Set<int> _selectedIds;
  List<BookLanguageModel> _languages = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.initialLanguageIds.toSet();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    try {
      final languages = await _repository.getLanguages();
      if (!mounted) return;
      setState(() {
        _languages = languages;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleLanguage(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _applyAndClose() {
    Navigator.of(context).pop(_selectedIds.toList()..sort());
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
            context.l10n.language,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(child: _buildBody()),
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 13.sp,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _languages.length,
      separatorBuilder: (_, __) => filterCheckboxDivider(),
      itemBuilder: (context, index) {
        final language = _languages[index];
        final isSelected = _selectedIds.contains(language.id);

        return FilterCheckboxRow(
          label: language.name,
          isSelected: isSelected,
          onTap: () => _toggleLanguage(language.id),
        );
      },
    );
  }
}
