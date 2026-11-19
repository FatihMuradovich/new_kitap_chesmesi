import 'package:new_kitap_chesmesi/features/order/domain/model/gift_model.dart';

abstract class GiftRepository {
  Future<List<GiftModel>> getGifts();
}
