import 'package:new_kitap_chesmesi/features/profile/data/data_source/coupon_data_source.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/model/coupon_model.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/coupon_repository.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponDataSource couponDataSource;

  CouponRepositoryImpl({required this.couponDataSource});

  @override
  Future<List<CouponModel>> getUserCoupons() async {
    return await couponDataSource.getUserCoupons();
  }
}
