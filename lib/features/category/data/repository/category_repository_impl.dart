
import 'package:new_kitap_chesmesi/features/category/data/data_source/category_data_source.dart';
import 'package:new_kitap_chesmesi/features/category/domain/model/category_model.dart';
import 'package:new_kitap_chesmesi/features/category/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource dataSource;

  CategoryRepositoryImpl({required this.dataSource});

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      return await dataSource.getCategories();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}