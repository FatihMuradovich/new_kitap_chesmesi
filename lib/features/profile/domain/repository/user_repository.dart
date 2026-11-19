
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';

abstract class UserRepository {
  Future<UserDetailModel> getUserProfile();
  Future<UserDetailModel> updateUserProfile({
    required String name,
    required String surname,
    required String phoneNumber,
    required String birthday,
  });

  Future<UserDetailModel> updateRecommendedCategories(
      List<int> recommendedCategoryIds);
}