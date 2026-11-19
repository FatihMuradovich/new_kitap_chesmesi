
import 'package:new_kitap_chesmesi/features/category/domain/model/subcategory_model.dart';

abstract class SubcateogryRepository {
  Future<List<SubcategoryModel>> fetchSubcategory(String id);
}
