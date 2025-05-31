import 'package:new_kitap_chesmesi/features/category/domain/model/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> fetchCategories();
}
