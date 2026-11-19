// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:new_kitap_chesmesi/features/order/domain/model/welayat_model.dart';

class EtrapModel {
  final int id;
  final String name;
  final String price;
  final int welayatId;
  final WelayatModel welayat;
  EtrapModel({
    required this.id,
    required this.name,
    required this.price,
    required this.welayatId,
    required this.welayat,
  });

  EtrapModel copyWith({
    int? id,
    String? name,
    String? price,
    int? welayatId,
    WelayatModel? welayat,
  }) {
    return EtrapModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      welayatId: welayatId ?? this.welayatId,
      welayat: welayat ?? this.welayat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'welayatId': welayatId,
      'welayat': welayat.toMap(),
    };
  }

  factory EtrapModel.fromMap(Map<String, dynamic> map) {
    return EtrapModel(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as String,
      welayatId: map['welayatId'] as int,
      welayat: WelayatModel.fromMap(map['welayat'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory EtrapModel.fromJson(String source) => EtrapModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EtrapModel(id: $id, name: $name, price: $price, welayatId: $welayatId, welayat: $welayat)';
  }

  @override
  bool operator ==(covariant EtrapModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.price == price &&
      other.welayatId == welayatId &&
      other.welayat == welayat;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      welayatId.hashCode ^
      welayat.hashCode;
  }
}
