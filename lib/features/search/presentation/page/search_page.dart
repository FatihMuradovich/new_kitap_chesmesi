import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

import '../../../auth/presentation/widget/custom_text_form_field.dart';

class SearchPage extends StatefulWidget {
  final List<BookModel> books;
  const SearchPage({super.key, required this.books});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<BookModel> availableItems = [];
  @override
  void initState() {
    super.initState();
    availableItems = widget.books;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<BookModel> filteredItems = availableItems.where((book) {
      return book.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 15),
              child: CustomTextFormField(
                hintText: context.l10n.bookAuthorSearch,
                isPrefix: false,
                controller: _searchController,
                isCalendar: false,
                isPassword: false,
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('books'),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
