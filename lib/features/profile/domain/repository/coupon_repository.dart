import 'package:new_kitap_chesmesi/features/profile/domain/model/coupon_model.dart';

abstract class CouponRepository {
  Future<List<CouponModel>> getUserCoupons();
}
