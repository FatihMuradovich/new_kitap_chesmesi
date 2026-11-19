import 'package:new_kitap_chesmesi/features/special_order/domain/model/delivery_method_model.dart';

abstract class DeliveryMethodRepository {
  Future<List<DeliveryMethodModel>> getDeliveryMethods();
}
