import 'dart:convert';

class SubcategoryModel {
  final int? id;
  final String image;
  final String name;
  final int? parentId;
  SubcategoryModel({
    required this.id,
    required this.image,
    required this.name,
    required this.parentId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'name': name,
      'parentId': parentId
    };
  }

  factory SubcategoryModel.fromMap(Map<String, dynamic> map) {
    return SubcategoryModel(
      id: map['id'],
      image: map['image'],
      name: map['name'],
      parentId: map['parentId'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubcategoryModel.fromJson(Map<String, dynamic> source) =>
      SubcategoryModel.fromMap(source);
}
