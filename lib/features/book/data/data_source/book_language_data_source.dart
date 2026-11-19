import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_language_model.dart';

class BookLanguageDataSource {
  final DioClient dioSetting;

  BookLanguageDataSource({required this.dioSetting});

  Future<List<BookLanguageModel>> getLanguages() async {
    final response = await dioSetting.dio.get('/language');

    if (response.statusCode == 200) {
      final data = response.data['data'] as List;
      return data
          .map((item) => BookLanguageModel.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load languages');
  }
}
