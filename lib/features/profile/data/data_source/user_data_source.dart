// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';

class UserDataSource {
  final DioClient dioSetting;
  String? accessToken;
  UserDataSource({
    required this.dioSetting,
    this.accessToken,
  });

  
  Future<UserDetailModel> getProfile() async {
    // DioClient interceptor zaten token'ı ekliyor, manuel eklemeye gerek yok
     
    final response = await dioSetting.dio.get('/user/me');
    log('UserDataSource - Full response: ${response.data}');
    log('UserDataSource - Response status: ${response.statusCode}');
    log('UserDataSource - Response data type: ${response.data.runtimeType}');

    if (response.statusCode == 200) {
      try {
        final responseData = response.data;
        log('UserDataSource - Response data: $responseData');

        // Eğer data nested ise onu al
        final userData = responseData['data'] ?? responseData;
        log('UserDataSource - User data to parse: $userData');

        return UserDetailModel.fromMap(userData);
      } catch (e, trace) {
        debugPrint(e.toString());
        debugPrint(trace.toString());
      }
      final responseData = response.data;
      log('UserDataSource - Response data: $responseData');

      // Eğer data nested ise onu al
      final userData = responseData['data'] ?? responseData;
      log('UserDataSource - User data to parse: $userData');

      return UserDetailModel.fromMap(userData);
    } else {
      throw Exception('Profile fetch failed: ${response.statusCode}');
    }
  }

  Future<UserDetailModel> updateProfile({
    required String name,
    required String surname,
    required String phoneNumber,
    required String birthday,
  }) async {
    final requestData = {
      "name": name,
      "surname": surname,
      "phoneNumber": phoneNumber,
      "birthday": birthday,
    };

    log('UserDataSource - Update request data: $requestData');
    final token = await dioSetting.getToken();
    final response = await dioSetting.dio.patch('/user',
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ));

    log('UserDataSource - Update response: ${response.data}');
    log('UserDataSource - Update status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final responseData = response.data;
      final userData = responseData['data'] ?? responseData;

      return UserDetailModel.fromMap(userData);
    } else {
      throw Exception('Profile update failed: ${response.statusCode}');
    }
  }

  Future<UserDetailModel> updateRecommendedCategories(
      List<int> recommendedCategoryIds) async {
    final requestData = {
      'recommendedCategoryIds': recommendedCategoryIds,
    };

    log('UserDataSource - Update recommended categories: $requestData');

    final token = await dioSetting.getToken();
    final response = await dioSetting.dio.patch(
      '/user',
      data: requestData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    log('UserDataSource - Recommended categories response: ${response.data}');
    log('UserDataSource - Recommended categories status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final responseData = response.data;
      final userData = responseData['data'] ?? responseData;
      return UserDetailModel.fromMap(userData);
    } else {
      throw Exception(
          'Recommended categories update failed: ${response.statusCode}');
    }
  }

  Future<bool> deleteAccount() async {
    final token = await dioSetting.getToken();
    log('UserDataSource - Deleting account...');
    
    final response = await dioSetting.dio.delete(
      '/user/account',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    log('UserDataSource - Delete response: ${response.data}');
    log('UserDataSource - Delete status: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Account deletion failed: ${response.statusCode}');
    }
  }
}
