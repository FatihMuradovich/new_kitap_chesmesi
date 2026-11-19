import 'package:new_kitap_chesmesi/features/special_order/data/data_source/delivery_method_data_source.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/model/delivery_method_model.dart';
import 'package:new_kitap_chesmesi/features/special_order/domain/repository/delivery_method_repository.dart';

class DeliveryMethodRepositoryImpl implements DeliveryMethodRepository {
  final DeliveryMethodDataSource deliveryMethodDataSource;

  DeliveryMethodRepositoryImpl({required this.deliveryMethodDataSource});

  @override
  Future<List<DeliveryMethodModel>> getDeliveryMethods() async =>
      await deliveryMethodDataSource.getDeliveryMethods();
}
