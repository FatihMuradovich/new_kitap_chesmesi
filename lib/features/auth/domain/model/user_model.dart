class UserModel {
  final String name;
  final String surname;
  final String birthday;
  final String phone;
  final String password;

  UserModel({
    required this.name,
    required this.surname,
    required this.birthday,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'first_name': name,
    'last_name': surname,
    'birthday': birthday,
    'phone_number': phone,
    'password': password,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['first_name'],
    surname: json['last_name'],
    birthday: json['birthday'],
    phone: json['phone_number'],
    password: json['password'],
  );
}
