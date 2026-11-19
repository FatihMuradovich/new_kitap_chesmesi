import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/coupon_repository.dart';
import 'coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  final CouponRepository couponRepository;

  CouponCubit({required this.couponRepository}) : super(CouponInitial());

  Future<void> loadUserCoupons() async {
    emit(CouponLoading());
    try {
      final coupons = await couponRepository.getUserCoupons();
      log('CouponCubit - Loaded ${coupons.length} coupons');
      emit(CouponLoaded(coupons));
    } catch (e) {
      log('CouponCubit - Error: $e');
      emit(CouponError(e.toString()));
    }
  }

  /// Oturum kapanınca çağrılır — önceki kullanıcının kuponları ekranda kalmasın.
  void reset() => emit(CouponInitial());
}
