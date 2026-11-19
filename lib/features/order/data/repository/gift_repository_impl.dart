import 'package:new_kitap_chesmesi/features/order/data/data_source/gift_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/domain/model/gift_model.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/gift_repository.dart';

class GiftRepositoryImpl implements GiftRepository {
  final GiftDataSource giftDataSource;

  GiftRepositoryImpl({required this.giftDataSource});

  @override
  Future<List<GiftModel>> getGifts() async {
    return await giftDataSource.getGifts();
  }
}
