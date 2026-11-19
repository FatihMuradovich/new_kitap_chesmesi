class LoginModel {
  final String? phoneNumber;
  final String? password;
  LoginModel({
    this.phoneNumber,
    this.password,
  });

  LoginModel copyWith({
    String? phoneNumber,
    String? password,
  }) {
    return LoginModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }
}
