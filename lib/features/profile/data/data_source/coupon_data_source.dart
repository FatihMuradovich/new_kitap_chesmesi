import 'package:dio/dio.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/model/coupon_model.dart';

class CouponDataSource {
  final DioClient dioSetting;

  CouponDataSource({required this.dioSetting});

  Future<List<CouponModel>> getUserCoupons() async {
    try {
       final token =
          await dioSetting.getToken();// getToken() metodunu varsayalım
      final response = await dioSetting.dio.get(
        '/user/coupon',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> rawList = response.data['data'] as List<dynamic>;
        final List<CouponModel> coupons = rawList
            .map((e) => CouponModel.fromMap(e as Map<String, dynamic>))
            .toList();

        return coupons;
      } else {
        throw Exception('Failed to load coupons: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching coupons: $e');
    }
  }
}
