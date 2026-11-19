import 'dart:convert';

class CategoryModel {
  final int? id;
  final String image;
  final String name;
  CategoryModel({
    required this.id,
    required this.image,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'name': name,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      image: map['image'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(Map<String, dynamic> source) =>
      CategoryModel.fromMap(source);

}
