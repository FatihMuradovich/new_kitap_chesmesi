import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/user_repository.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}) : super(UserInitial());

  Future<void> fetchUserProfile() async {
    try {
      log('UserCubit: fetchUserProfile başlatıldı');
      emit(UserLoading());

      final user = await userRepository.getUserProfile();
      log('UserCubit: User profili başarıyla alındı: ${user.name} ${user.surname}');

      emit(UserLoaded(user));
    } catch (e) {
      log('UserCubit: Hata oluştu: $e');
      log('UserCubit: Hata tipi: ${e.runtimeType}');
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String surname,
    required String phoneNumber,
    required String birthday,
  }) async {
    try {
      log('UserCubit: updateUserProfile başlatıldı');
      emit(UserLoading());

      final updatedUser = await userRepository.updateUserProfile(
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        birthday: birthday,
      );

      log('UserCubit: User profili başarıyla güncellendi: ${updatedUser.name} ${updatedUser.surname}');
      emit(UserLoaded(updatedUser));
    } catch (e) {
      log('UserCubit: Güncelleme hatası: $e');
      log('UserCubit: Hata tipi: ${e.runtimeType}');
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateRecommendedCategories(
      List<int> recommendedCategoryIds) async {
    try {
      log('UserCubit: updateRecommendedCategories başlatıldı');
      emit(UserLoading());

      final updatedUser =
          await userRepository.updateRecommendedCategories(recommendedCategoryIds);

      log('UserCubit: Önerilen kategori başarıyla güncellendi');
      emit(UserLoaded(updatedUser));
    } catch (e) {
      log('UserCubit: Önerilen kategori güncelleme hatası: $e');
      log('UserCubit: Hata tipi: ${e.runtimeType}');
      emit(UserError(e.toString()));
    }
  }
}
