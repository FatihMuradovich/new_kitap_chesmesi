import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_author_model.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_authors_page_result.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_author_repository.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/filter/filter_checkbox_row.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class BooksAuthorFilterPage extends StatefulWidget {
  final List<int> initialAuthorIds;
  final Map<int, String> initialAuthorNames;

  const BooksAuthorFilterPage({
    super.key,
    this.initialAuthorIds = const [],
    this.initialAuthorNames = const {},
  });

  @override
  State<BooksAuthorFilterPage> createState() => _BooksAuthorFilterPageState();
}

class _BooksAuthorFilterPageState extends State<BooksAuthorFilterPage> {
  static const _pageSize = 20;

  final _repository = di<BookAuthorRepository>();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  late Set<int> _selectedIds;
  final Map<int, String> _selectedAuthorNames = {};

  List<BookAuthorModel> _authors = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  String _searchQuery = '';
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.initialAuthorIds.toSet();
    _selectedAuthorNames.addAll(widget.initialAuthorNames);
    _loadAuthors(reset: true);
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query == _searchQuery) return;
      _searchQuery = query;
      _loadAuthors(reset: true);
    });
  }

  void _onScroll() {
    if (!_hasMore || _isLoading || _isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 120) {
      _loadAuthors(reset: false);
    }
  }

  Future<void> _loadAuthors({required bool reset}) async {
    if (reset) {
      setState(() {
        _isLoading = true;
        _error = null;
        _currentPage = 1;
        _hasMore = true;
        _authors = [];
      });
    } else {
      if (!_hasMore || _isLoadingMore) return;
      setState(() => _isLoadingMore = true);
    }

    final pageToLoad = reset ? 1 : _currentPage + 1;

    try {
      final result = await _repository.getAuthors(
        page: pageToLoad,
        limit: _pageSize,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );

      if (!mounted) return;

      setState(() {
        if (reset) {
          _authors = result.authors;
        } else {
          _authors = [..._authors, ...result.authors];
        }
        _currentPage = pageToLoad;
        _hasMore = result.hasMore;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _toggleAuthor(BookAuthorModel author) {
    setState(() {
      if (_selectedIds.contains(author.id)) {
        _selectedIds.remove(author.id);
        _selectedAuthorNames.remove(author.id);
      } else {
        _selectedIds.add(author.id);
        _selectedAuthorNames[author.id] = author.name;
      }
    });
  }

  void _applyAndClose() {
    Navigator.of(context).pop(
      BooksAuthorFilterResult(
        authorIds: _selectedIds.toList()..sort(),
        authorNames: Map<int, String>.from(_selectedAuthorNames),
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
            context.l10n.author,
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 8.h),
          child: TextField(
            controller: _searchController,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: context.l10n.authorSearch,
              hintStyle: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14.sp,
                color: Colors.black38,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.black45),
              filled: true,
              fillColor: const Color(0xFFF8F8F8),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: CustomColors.orangeColor),
              ),
            ),
          ),
        ),
        if (_selectedIds.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_selectedIds.length} ${context.l10n.authorsSelected}',
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 12.sp,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        Expanded(child: _buildList()),
      ],
    );
  }

  Widget _buildList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _authors.isEmpty) {
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

    if (_authors.isEmpty) {
      return Center(
        child: Text(
          context.l10n.authorNotFound,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            fontSize: 13.sp,
            color: Colors.black54,
          ),
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: _authors.length + (_isLoadingMore ? 1 : 0),
      separatorBuilder: (_, index) {
        if (index >= _authors.length - 1) {
          return const SizedBox.shrink();
        }
        return filterCheckboxDivider();
      },
      itemBuilder: (context, index) {
        if (index >= _authors.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final author = _authors[index];
        final isSelected = _selectedIds.contains(author.id);

        return FilterCheckboxRow(
          label: author.name,
          isSelected: isSelected,
          onTap: () => _toggleAuthor(author),
        );
      },
    );
  }
}
