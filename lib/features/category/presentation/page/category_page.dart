import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/category_cubit.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/widget/category_item.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.categories)),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
         
          if (state is CategoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final categoryItem = state.categories[index];
                return CategoryItem(categoryModel: categoryItem,);
              },
            );
          } else if (state is CategoryError) {
            return Text('Error: ${state.message}');
          }
          return Container();
        },
      ),
    );
  }
}
