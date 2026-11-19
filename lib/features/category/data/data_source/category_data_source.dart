
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/category/domain/model/category_model.dart';

class CategoryDataSource {
  final DioClient dioSetting;
  CategoryDataSource({required this.dioSetting});



  Future<List<CategoryModel>> getCategories() async {
    try {

      final response = await dioSetting.dio.get('/category/');
      if (response.statusCode == 200) {
        List<CategoryModel> categories = (response.data['data'] as List)
            .map((category) => CategoryModel.fromJson(category))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}
