import 'dart:convert';

class SubcategoryModel {
  final int id;
  final String name;
  final int categoryId;
  final String description;

  SubcategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'name': name,
      'category': categoryId,
    };
  }

  factory SubcategoryModel.fromMap(Map<String, dynamic> map) {
    return SubcategoryModel(
      id: map['id'] as int,
      description: map['description'] as String,
      name: map['name'] as String,
      categoryId: map['category'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubcategoryModel.fromJson(String source) =>
      SubcategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
