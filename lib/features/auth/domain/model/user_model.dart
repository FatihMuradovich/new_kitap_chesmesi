class UserModel {
  final int id;
  final String name;
  final String surname;
  final String birthday;
  final String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.birthday,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'first_name': name,
        'last_name': surname,
        'birthday': birthday,
        'username': phone,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['first_name'],
        surname: json['last_name'],
        birthday: json['birthday'],
        phone: json['username'],
      );
  factory UserModel.fromJsonRegister(Map<String, dynamic> json) => UserModel(
        id: json['user']['id'],
        name: json['user']['first_name'],
        surname: json['user']['last_name'],
        birthday: json['user']['birthday'],
        phone: json['user']['username'],
      );
}
