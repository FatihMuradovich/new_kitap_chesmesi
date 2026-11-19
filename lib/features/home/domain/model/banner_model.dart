class BannerModel {
  int id;
  String title;
  String link;
  String image;
  String createdAt;
  String updatedAt;
  BannerModel({
    required this.id,
    required this.title,
    required this.link,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  BannerModel copyWith({
    int? id,
    String? title,
    String? link,
    String? image,
    String? createdAt,
    String? updatedAt,
  }) {
    return BannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      id: map['id'] as int,
      title: map['title'] as String,
      link: map['link'] as String,
      image: map['image'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }
}
