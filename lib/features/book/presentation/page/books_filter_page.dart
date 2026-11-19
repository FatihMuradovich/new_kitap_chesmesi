import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_authors_page_result.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_language_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_publishers_page_result.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_sort_option.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/books_filter_criteria.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_language_repository.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/books_author_filter_page.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/books_language_filter_page.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/books_price_filter_page.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/books_publisher_filter_page.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/books_sort_filter_page.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/filter/filter_footer.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/filter/filter_menu_row.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class BooksFilterPage extends StatefulWidget {
  final BooksFilterCriteria initialFilters;
  final ValueChanged<BooksFilterCriteria> onFiltersApplied;
  final VoidCallback onClearFilters;

  const BooksFilterPage({
    super.key,
    this.initialFilters = const BooksFilterCriteria(),
    required this.onFiltersApplied,
    required this.onClearFilters,
  });

  @override
  State<BooksFilterPage> createState() => _BooksFilterPageState();
}

class _BooksFilterPageState extends State<BooksFilterPage> {
  late BooksFilterCriteria _filters;
  List<BookLanguageModel> _languages = [];
  Map<int, String> _authorNameById = {};
  Map<int, String> _publisherNameById = {};

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    try {
      final languages = await di<BookLanguageRepository>().getLanguages();
      if (!mounted) return;
      setState(() => _languages = languages);
    } catch (_) {}
  }

  Future<void> _openSortFilter() async {
    final result = await Navigator.of(context).push<BookSortOption?>(
      MaterialPageRoute(
        builder: (_) => BooksSortFilterPage(initialSort: _filters.sortOption),
      ),
    );

    if (!mounted) return;

    setState(() {
      _filters = _filters.copyWith(
        sortOption: result,
        clearSortOption: result == null,
      );
    });
  }

  Future<void> _openPriceFilter() async {
    final result = await Navigator.of(context).push<BooksPriceFilterResult>(
      MaterialPageRoute(
        builder: (_) => BooksPriceFilterPage(
          initialMinPrice: _filters.minPrice,
          initialMaxPrice: _filters.maxPrice,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _filters = _filters.copyWith(
        minPrice: result.minPrice,
        maxPrice: result.maxPrice,
      );
    });
  }

  Future<void> _openLanguageFilter() async {
    final result = await Navigator.of(context).push<List<int>>(
      MaterialPageRoute(
        builder: (_) => BooksLanguageFilterPage(
          initialLanguageIds: _filters.languageIds,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _filters = _filters.copyWith(languageIds: result);
    });
  }

  Future<void> _openAuthorFilter() async {
    final result = await Navigator.of(context).push<BooksAuthorFilterResult>(
      MaterialPageRoute(
        builder: (_) => BooksAuthorFilterPage(
          initialAuthorIds: _filters.authorIds,
          initialAuthorNames: _authorNameById,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _filters = _filters.copyWith(authorIds: result.authorIds);
      _authorNameById = result.authorNames;
    });
  }

  Future<void> _openPublisherFilter() async {
    final result = await Navigator.of(context).push<BooksPublisherFilterResult>(
      MaterialPageRoute(
        builder: (_) => BooksPublisherFilterPage(
          initialPublisherIds: _filters.publisherIds,
          initialPublisherNames: _publisherNameById,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _filters = _filters.copyWith(publisherIds: result.publisherIds);
      _publisherNameById = result.publisherNames;
    });
  }

  void _clearFilters() {
    setState(() {
      _filters = const BooksFilterCriteria();
      _authorNameById = {};
      _publisherNameById = {};
    });
    widget.onClearFilters();
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.of(context).pop();
  }

  String? _sortSubtitle() {
    return _filters.sortOption?.label;
  }

  String? _priceSubtitle() {
    final min = _filters.minPrice;
    final max = _filters.maxPrice;
    if (min == null && max == null) return null;

    String format(double value) {
      if (value == value.roundToDouble()) {
        return value.toInt().toString();
      }
      return value.toString();
    }

    if (min != null && max != null) {
      return '${format(min)} m. - ${format(max)} m.';
    }
    if (min != null) {
      return '${format(min)} m. -';
    }
    return '- ${format(max!)} m.';
  }

  String? _languageSubtitle() {
    if (_filters.languageIds.isEmpty) return null;

    final names = _languages
        .where((language) => _filters.languageIds.contains(language.id))
        .map((language) => language.name)
        .toList();

    if (names.isNotEmpty) {
      return names.join(', ');
    }

    return '${_filters.languageIds.length} ${context.l10n.languagesSelected}';
  }

  String? _authorSubtitle() {
    if (_filters.authorIds.isEmpty) return null;

    final names = _filters.authorIds
        .map((id) => _authorNameById[id])
        .whereType<String>()
        .toList();

    if (names.isNotEmpty) {
      return names.join(', ');
    }

    return '${_filters.authorIds.length} ${context.l10n.authorsSelected}';
  }

  String? _publisherSubtitle() {
    if (_filters.publisherIds.isEmpty) return null;

    final names = _filters.publisherIds
        .map((id) => _publisherNameById[id])
        .whereType<String>()
        .toList();

    if (names.isNotEmpty) {
      return names.join(', ');
    }

    return '${_filters.publisherIds.length} ${context.l10n.publishersSelected}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Colors.black),
        ),
        shadowColor: Colors.white,
        centerTitle: false,
        title: Text(
          context.l10n.filter,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            FilterMenuRow(
              title: context.l10n.sort, 
              subtitle: _sortSubtitle(),
              onTap: _openSortFilter,
            ),
            FilterMenuRow(
              title: context.l10n.priceRange,
              subtitle: _priceSubtitle(),
              onTap: _openPriceFilter,
            ),
            FilterMenuRow(
              title: context.l10n.language,
              subtitle: _languageSubtitle(),
              onTap: _openLanguageFilter,
            ),
            FilterMenuRow(
              title: context.l10n.author,
              subtitle: _authorSubtitle(),
              onTap: _openAuthorFilter,
            ),
            FilterMenuRow(
              title: context.l10n.publisher,
              subtitle: _publisherSubtitle(),
              onTap: _openPublisherFilter,
            ),
            // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
            // // Kapsam anahtarı — açıkken liste getirtilebilir kitaplara daralır.
            // SwitchListTile.adaptive(
            // value: _filters.specialOrderable,
            // activeTrackColor: CustomColors.orangeColor,
            // contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            // title: Text(
            // context.l10n.specialOrderBadge,
            // style: TextStyle(
            // fontFamily: 'Poppins-regular',
            // fontSize: 14.sp,
            // color: Colors.black,
            // ),
            // ),
            // subtitle: Text(
            // context.l10n.emptyRequestsHint,
            // style: TextStyle(
            // fontFamily: 'Poppins-regular',
            // fontSize: 11.sp,
            // color: Colors.grey[600],
            // ),
            // ),
            // onChanged: (value) => setState(
            // () => _filters = _filters.copyWith(specialOrderable: value),
            // ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: FilterFooter(
        onClear: _clearFilters,
        onApply: _applyFilters,
      ),
    );
  }
}
