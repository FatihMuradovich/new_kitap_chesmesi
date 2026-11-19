
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';
import 'package:new_kitap_chesmesi/features/profile/data/data_source/user_data_source.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource userDataSource;

  UserRepositoryImpl({required this.userDataSource});

  @override
  Future<UserDetailModel> getUserProfile() async {
    return await userDataSource.getProfile();
  }

  @override
  Future<UserDetailModel> updateUserProfile({
    required String name,
    required String surname,
    required String phoneNumber,
    required String birthday,
  }) async {
    return await userDataSource.updateProfile(
      name: name,
      surname: surname,
      phoneNumber: phoneNumber,
      birthday: birthday,
    );
  }

  @override
  Future<UserDetailModel> updateRecommendedCategories(
      List<int> recommendedCategoryIds) async {
    return await userDataSource.updateRecommendedCategories(
      recommendedCategoryIds,
    );
  }
}
