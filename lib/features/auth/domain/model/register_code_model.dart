class RegisterCodeModel {
  final String phoneNumber;
  final String type;
  final int? code;
  RegisterCodeModel({
    required this.phoneNumber,
    required this.type,
    this.code,
  });
 

  RegisterCodeModel copyWith({
    String? phoneNumber,
    String? type,
    int? code,
  }) {
    return RegisterCodeModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneNumber': phoneNumber,
      'type': type,
    };
  }

  factory RegisterCodeModel.fromMap(Map<String, dynamic> map) {
    return RegisterCodeModel(
      phoneNumber: map['phoneNumber'] as String,
      type: map['type'] as String,
      code: map['code'] != null ? map['code'] as int : null,
    );
  }


}
