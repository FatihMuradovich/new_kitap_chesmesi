class RegisterModel {
  final UserDetailModel userDetailModel;
  final String? accessToken;
  final String? refreshToken;
  RegisterModel({
    required this.userDetailModel,
    this.accessToken,
    this.refreshToken,
  });

  RegisterModel copyWith({
    UserDetailModel? userDetailModel,
    String? accessToken,
    String? refreshToken,
  }) {
    return RegisterModel(
      userDetailModel: userDetailModel ?? this.userDetailModel,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'accessToken': accessToken,
      // 'refreshToken': refreshToken,
    }..addAll(
        userDetailModel.toMap(),
      );
  }

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    final access = map['accessToken'] ?? map['access_token'];
    final refresh = map['refreshToken'] ?? map['refresh_token'];
    return RegisterModel(
      userDetailModel: UserDetailModel.fromMap(
        map['user'] as Map<String, dynamic>,
      ),
      accessToken: access is String ? access : access?.toString(),
      refreshToken: refresh is String ? refresh : refresh?.toString(),
    );
  }
}

class UserDetailModel {
  final int? id;
  final String? name;
  final String? surname;
  final String? phoneNumber;
  final String? birthday;
  final String? password;
  final String? code;
  final String? referralCode;
  final String? referral;
  UserDetailModel({
    this.id,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.birthday,
    this.password,
    this.code,
    this.referralCode,
    this.referral,
  });

  UserDetailModel copyWith({
    int? id,
    String? name,
    String? surname,
    String? phoneNumber,
    String? birthday,
    String? password,
    String? code,
    String? referralCode,
    String? referral,
  }) {
    return UserDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthday: birthday ?? this.birthday,
      password: password ?? this.password,
      code: code ?? this.code,
      referralCode: referralCode ?? this.referralCode,
      referral: referral ?? this.referral,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'birthday': birthday,
      'password': password,
      'code': code,
    };
    
    // referralCode sadece dolu ise backend'e gönder
    if (referralCode != null && referralCode!.isNotEmpty) {
      map['referralCode'] = referralCode;
    }
    
    return map;
  }

  factory UserDetailModel.fromMap(Map<String, dynamic> map) {
    return UserDetailModel(
      id: map['id'] != null ? (map['id'] is int ? map['id'] : int.tryParse(map['id'].toString())) : null,
      name: map['name']?.toString(),
      surname: map['surname']?.toString(),
      phoneNumber: map['phoneNumber']?.toString(),
      birthday: map['birthday']?.toString(),
      referral: map['referral']?.toString(),
    );
  }
}
