import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class BookByLanguageIdDataSoruce {
  final DioClient dioSetting;

  BookByLanguageIdDataSoruce({required this.dioSetting});

  Future<List<BookModel>> getBooksByLang(int languageId) async {
    try {
      final response = await dioSetting.dio.get(
        "/book",
        // API yalnızca çoğul `languageIds` ile filtreliyor; tekil `languageId`
        // parametresi yok sayılıp tüm kitaplar dönüyor.
        queryParameters: {"languageIds": languageId},
      );

      if (response.statusCode == 200) {
        final List data = response.data["data"];
        return data.map((json) => BookModel.fromMap(json)).toList();
      } else {
        throw Exception("Kitapları getirme başarısız");
      }
    } catch (e) {
      throw Exception("API hatası: $e");
    }
  }
}
