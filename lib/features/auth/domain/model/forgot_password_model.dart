import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart';

class ForgotPasswordModel {
  final UserDetailModel? userDetailModel;
  final String? phoneNumber;
  final int? code;
  final String? newPassword;
  final String? confirmPassword;
  ForgotPasswordModel({
    this.userDetailModel,
    this.phoneNumber,
    this.code,
    this.newPassword,
    this.confirmPassword,
  });

  ForgotPasswordModel copyWith({
    UserDetailModel? userDetailModel,
    String? phoneNumber,
    int? code,
    String? newPassword,
    String? confirmPassword,
  }) {
    return ForgotPasswordModel(
      userDetailModel: userDetailModel ?? this.userDetailModel,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      code: code ?? this.code,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneNumber': phoneNumber,
      'code': code,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }

  factory ForgotPasswordModel.fromMap(Map<String, dynamic> map) {
    return ForgotPasswordModel(
      userDetailModel: map['data'],
    );
  }
}
