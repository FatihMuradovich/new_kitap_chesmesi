import 'dart:convert';

class CategoryModel {
  final int id;
  final String descriptionEn;
  final String nameEn;
  final String descriptionRu;
  final String nameRu;
  final String descriptionTm;
  final String nameTm;

  CategoryModel(
      {required this.id, required this.descriptionEn, required this.nameEn, required this.descriptionRu, required this.nameRu, required this.descriptionTm, required this.nameTm});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description_en': descriptionEn,
      'name_en': nameEn,
      'description_ru': descriptionRu,
      'name_ru': nameRu,
      'description_tm': descriptionTm,
      'name_tm': nameTm,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int,
      descriptionRu: map['description_ru'],
      nameRu: map['name_ru'],
      descriptionEn: map['description_en'] ,
      nameEn: map['name_en'] ,
      descriptionTm: map['description_tm'] ,
      nameTm: map['name_tm'] ,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(Map<String, dynamic> source) =>
      CategoryModel.fromMap(source);
}
