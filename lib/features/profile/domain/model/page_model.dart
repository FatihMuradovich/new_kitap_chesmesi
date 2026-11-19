// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PageModel {
  final int id;
  final String aboutUs;
  final String termsOfUse;
  final String privacyPolicy;
  final String createdAt;
  final String updatedAt;

  PageModel({
    required this.id,
    required this.aboutUs,
    required this.termsOfUse,
    required this.privacyPolicy,
    required this.createdAt,
    required this.updatedAt,
  });

  PageModel copyWith({
    int? id,
    String? aboutUs,
    String? termsOfUse,
    String? privacyPolicy,
    String? createdAt,
    String? updatedAt,
  }) {
    return PageModel(
      id: id ?? this.id,
      aboutUs: aboutUs ?? this.aboutUs,
      termsOfUse: termsOfUse ?? this.termsOfUse,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'aboutUs': aboutUs,
      'termsOfUse': termsOfUse,
      'privacyPolicy': privacyPolicy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory PageModel.fromMap(Map<String, dynamic> map) {
    return PageModel(
      id: map['id'] as int,
      aboutUs: map['aboutUs'] as String,
      termsOfUse: map['termsOfUse'] as String,
      privacyPolicy: map['privacyPolicy'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PageModel.fromJson(String source) =>
      PageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PageModel(id: $id, aboutUs: $aboutUs, termsOfUse: $termsOfUse, privacyPolicy: $privacyPolicy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant PageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.aboutUs == aboutUs &&
        other.termsOfUse == termsOfUse &&
        other.privacyPolicy == privacyPolicy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        aboutUs.hashCode ^
        termsOfUse.hashCode ^
        privacyPolicy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
