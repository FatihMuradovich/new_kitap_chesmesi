// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WelayatModel {
  final int id;
  final String name;
  WelayatModel({
    required this.id,
    required this.name,
  });

  WelayatModel copyWith({
    int? id,
    String? name,
  }) {
    return WelayatModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory WelayatModel.fromMap(Map<String, dynamic> map) {
    return WelayatModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WelayatModel.fromJson(String source) =>
      WelayatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WelayatModel(id: $id, name: $name)';

  @override
  bool operator ==(covariant WelayatModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
