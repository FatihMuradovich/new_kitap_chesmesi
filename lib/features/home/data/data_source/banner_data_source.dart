import 'package:flutter/foundation.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/home/domain/model/banner_model.dart';

class BannerDataSource {
  final DioClient dioSetting;
  BannerDataSource({required this.dioSetting});


  

  Future<List<BannerModel>> getBannerImages() async {
    try {
      final response = await dioSetting.dio.get('/banner');
      if (response.statusCode == 200) {
        List<BannerModel> bannerImages =
           (response.data['data'] as List)
            .map((banner) => BannerModel.fromMap(banner))
            .toList();
        // print('Category $categories');
        return bannerImages;
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error fetching books: $e');
    }
  }
}
