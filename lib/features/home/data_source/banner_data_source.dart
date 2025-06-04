import 'package:new_kitap_chesmesi/core/network/dio_client.dart';

class ImagesDataSource {
  final DioClient dioSetting;
  ImagesDataSource({required this.dioSetting});

  Future<List<String>> getImages() async {
    try {
      final response = await dioSetting.dio.get('banners/');
      if (response.statusCode == 200) {
        List<String> images =
            (response.data as List)
                .map((image) => image['background_image'] as String)
                .toList();
        // print('Category $categories');
        return images;
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching books: $e');
    }
  }
}
