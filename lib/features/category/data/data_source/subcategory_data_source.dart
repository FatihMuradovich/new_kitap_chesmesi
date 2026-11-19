import 'package:flutter/foundation.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/category/domain/model/subcategory_model.dart';

class SubcategoryDataSource {
  final DioClient dioSetting;
  SubcategoryDataSource({required this.dioSetting});

  static const int _pageLimit = 100;

  Future<List<SubcategoryModel>> getSubcategory(String id) async {
    try {
      final subcategories = <SubcategoryModel>[];
      int page = 1;

      while (true) {
        final response = await dioSetting.dio.get(
          '/category/sub/$id',
          queryParameters: {
            'page': page,
            'limit': _pageLimit,
          },
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to load categories');
        }

        final data = response.data['data'] as List;
        if (data.isEmpty) break;

        subcategories.addAll(
          data.map((category) => SubcategoryModel.fromJson(category)),
        );

        if (data.length < _pageLimit) break;
        page++;
      }

      return subcategories;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error fetching categories: $e');
    }
  }
}
