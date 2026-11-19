import 'package:new_kitap_chesmesi/features/category/domain/model/category_model.dart';
import 'package:new_kitap_chesmesi/features/category/domain/model/subcategory_model.dart';

class BookModel {
  final int id;
  final String name;
  final String? desc;
  final String? productCode;
  final int? authorId;

  /// `Decimal` olduğu için string gelir.
  ///
  /// **`status == Finished` olan kitaplarda `null`** — stoku bitmiş kitabın
  /// fiyatı artık katalogdan değil, özel sipariş teklifinden belirleniyor
  /// (SPECIAL-ORDER-API.md §4). Doğrudan formatlamayın: [hasPrice] ile kontrol
  /// edip fiyat yerine "Ýörite sargyt" yazın.
  final String? price;
  final String? rating;

  /// `status == Finished` olan kitaplarda `discount`/`discountType` de `null` —
  /// indirim rozeti çizilmez ([hasDiscount]).
  final String? discountType;
  final String? discount;
  final String status;

  final int stock;
  final String? cover;
  final int? pageCount;
  final int? languageId;
  final int? publishYear;
  final int? publisherId;
  final int? categoryId;
  final int? subcategoryId;
  final List<int> categoryIds;
  final List<int> subcategoryIds;
  final DateTime? createdAt;
  final CategoryModel? category;
  final SubcategoryModel? subcategory;
  final Author? author;
  final Publisher? publisher;
  final Language? language;
  final List<ImageModel> images;

  BookModel({
    required this.id,
    required this.name,
    required this.price,
    this.rating,
    this.discountType,
    this.discount,
    required this.status,
    required this.createdAt,
    required this.stock,
    required this.images,
    this.desc,
    this.productCode,
    this.authorId,
    this.cover,
    this.pageCount,
    this.languageId,
    this.publishYear,
    this.publisherId,
    this.categoryId,
    this.subcategoryId,
    this.categoryIds = const [],
    this.subcategoryIds = const [],
    this.category,
    this.subcategory,
    this.author,
    this.publisher,
    this.language,
  });

  /// Kitabın gösterilebilir bir fiyatı var mı. `Finished` kitaplarda `false`;
  /// bu durumda fiyat yerine "Ýörite sargyt" yazılır (SPECIAL-ORDER-API.md §4).
  bool get hasPrice => price != null && price!.trim().isNotEmpty;

  /// Fiyatı olmayan kitapta `0` — hesaplarda güvenli olsun diye.
  /// **Ekrana basmadan önce [hasPrice] kontrol edin**, yoksa "0.00 m." gösterirsiniz.
  double get priceValue => double.tryParse(price ?? '') ?? 0;

  double get discountValue => double.tryParse(discount ?? '') ?? 0;

  /// İndirim rozeti çizilir mi. `Finished` kitaplarda `discount` da `null`
  /// geldiği için kendiliğinden `false`.
  bool get hasDiscount => hasPrice && discountValue > 0;

  double get ratingValue {
    final parsed = double.tryParse(rating?.trim() ?? '');
    if (parsed == null) return 0;
    return parsed.clamp(0.0, 5.0);
  }

  /// Backend'in kitap durumları (SPECIAL-ORDER-API.md §4):
  /// `Available` | `Upcoming` | `Finished`.
  bool get isFinished => status.toLowerCase() == 'finished';

  double get discountedPrice {
    if (discountType?.toLowerCase() == 'percent') {
      return priceValue - (priceValue * discountValue / 100);
    } else if (discountType?.toLowerCase() == 'amount') {
      return priceValue - discountValue;
    }
    return priceValue;
  }

  BookModel copyWith({
    int? id,
    String? name,
    String? price,
    String? rating,
    String? discountType,
    String? discount,
    String? status,
    DateTime? createdAt,
    int? stock,
    List<ImageModel>? images,
    String? desc,
    String? productCode,
    int? authorId,
    String? cover,
    int? pageCount,
    int? languageId,
    int? publishYear,
    int? publisherId,
    int? categoryId,
    int? subcategoryId,
    List<int>? categoryIds,
    List<int>? subcategoryIds,
    CategoryModel? category,
    SubcategoryModel? subcategory,
    Author? author,
    Publisher? publisher,
    Language? language,
  }) {
    return BookModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      discountType: discountType ?? this.discountType,
      discount: discount ?? this.discount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      desc: desc ?? this.desc,
      productCode: productCode ?? this.productCode,
      authorId: authorId ?? this.authorId,
      cover: cover ?? this.cover,
      pageCount: pageCount ?? this.pageCount,
      languageId: languageId ?? this.languageId,
      publishYear: publishYear ?? this.publishYear,
      publisherId: publisherId ?? this.publisherId,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      categoryIds: categoryIds ?? this.categoryIds,
      subcategoryIds: subcategoryIds ?? this.subcategoryIds,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      language: language ?? this.language,
    );
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] as int,
      name: map['name'] as String,
      desc: map['desc'] as String?,
      productCode: map['productCode'] as String?,
      authorId: map['authorId'] as int?,
      // `Finished` kitaplarda null gelir — cast etme (§4).
      price: map['price']?.toString(),
      rating: map['rating']?.toString(),
      discountType: map['discountType'] as String?,
      discount: map['discount'] as String?,
      status: map['status'] as String,
      stock: map['stock'] as int,
      cover: map['cover'] as String?,
      pageCount: map['pageCount'] as int?,
      languageId: map['languageId'] as int?,
      publishYear: map['publishYear'] as int?,
      publisherId: map['publisherId'] as int?,
      categoryId: map['categoryId'] as int?,
      subcategoryId: map['subcategoryId'] as int?,
      categoryIds: _parseIdList(map['categories']),
      subcategoryIds: _parseIdList(map['subcategories']),
      createdAt: (map['createdAt'] as String?) != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      images: List<ImageModel>.from(
        (map['images'] as List).map<ImageModel>(
          (x) => ImageModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
      // category: map['category'] != null
      //     ? CategoryModel.fromMap(map['category'] as Map<String, dynamic>)
      //     : null,
      // subcategory: map['subcategory'] != null
      //     ? SubcategoryModel.fromMap(map['subcategory'] as Map<String, dynamic>)
      //     : null,
      author: map['author'] != null
          ? Author.fromJson(map['author'] as Map<String, dynamic>)
          : null,
      publisher: map['publisher'] != null
          ? Publisher.fromJson(map['publisher'] as Map<String, dynamic>)
          : null,
      language: map['language'] != null
          ? Language.fromJson(map['language'] as Map<String, dynamic>)
          : null,
    );
  }

  static List<int> _parseIdList(dynamic value) {
    if (value is! List) return const [];
    return value
        .map((item) {
          if (item is Map<String, dynamic>) {
            return (item['id'] as num?)?.toInt();
          }
          return (item as num?)?.toInt();
        })
        .whereType<int>()
        .toList();
  }

  bool belongsToSubcategory(int id) => subcategoryIds.contains(id);
}

class Author {
  final int id;
  final String name;
  final String? image;
  final String? desc;

  Author({
    required this.id,
    required this.name,
    this.image,
    this.desc,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String?,
      desc: json['desc'] as String?,
    );
  }
}

class Publisher {
  final int id;
  final String name;

  Publisher({
    required this.id,
    required this.name,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class Language {
  final int id;
  final String name;

  Language({
    required this.id,
    required this.name,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class ImageModel {
  final int id;
  final String path;

  ImageModel({
    required this.id,
    required this.path,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as int,
      path: json['path'] as String,
    );
  }
}
