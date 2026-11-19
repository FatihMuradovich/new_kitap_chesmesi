
import 'package:new_kitap_chesmesi/features/category/data/data_source/subcategory_data_source.dart';
import 'package:new_kitap_chesmesi/features/category/domain/model/subcategory_model.dart';
import 'package:new_kitap_chesmesi/features/category/domain/repository/subcateogry_repository.dart';

class SubcategoryRepositoryImpl implements SubcateogryRepository {
  final SubcategoryDataSource dataSource;
  final String id;
  SubcategoryRepositoryImpl({required this.dataSource, required this.id});

  @override
  Future<List<SubcategoryModel>> fetchSubcategory(
      id) async {
    try {
      return await dataSource.getSubcategory(id);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
