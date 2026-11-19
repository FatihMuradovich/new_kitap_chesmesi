import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/gift_repository.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/gift/gift_state.dart';

class GiftCubit extends Cubit<GiftState> {
  final GiftRepository giftRepository;

  GiftCubit({required this.giftRepository}) : super(GiftInitial());

  Future<void> fetchGifts() async {
    try {
      log('GiftCubit: fetchGifts başlatıldı');
      emit(GiftLoading());
      
      final gifts = await giftRepository.getGifts();
      log('GiftCubit: ${gifts.length} adet gift başarıyla alındı');
      
      emit(GiftLoaded(gifts));
    } catch (e) {
      log('GiftCubit: Hata oluştu: $e');
      log('GiftCubit: Hata tipi: ${e.runtimeType}');
      emit(GiftError(e.toString()));
    }
  }

  void resetState() {
    emit(GiftInitial());
  }
}
