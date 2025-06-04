import 'package:equatable/equatable.dart';


// ignore: must_be_immutable
class BookModel extends Equatable {
  int id;
  String code;
  String name;
  String author;
  String description;
  int categoryId;
  int subcategoryId;
  int discountId;
  double? priceHardcover;
  double? priceSoftcover;
  int? stockHardcover;
  int? stockSoftcover;
  String language;
  String publisher;
  int publishYear;
  int page;
  String? backgroundImageHard;
  String? backgroundImageSoft;
  bool isFavorite;
  bool new_added;
  bool hot;

  BookModel({
    required this.id,
    required this.code,
    required this.name,
    required this.author,
    required this.description,
    required this.categoryId,
    required this.subcategoryId,
    required this.discountId,
    required this.priceHardcover,
    required this.priceSoftcover,
    required this.stockHardcover,
    required this.stockSoftcover,
    required this.language,
    required this.publisher,
    required this.publishYear,
    required this.page,
    required this.backgroundImageHard,
    required this.backgroundImageSoft,
    required this.hot,
    required this.new_added,
    this.isFavorite = false,
  });

  // Factory method to create a BookModel from JSON
  factory BookModel.fromJson(Map<String, dynamic> json) {
    
    return BookModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      author: json['author'],
      description: json['description'],
      categoryId: json['category'],
      subcategoryId: json['subcategory'],
      discountId: json['discount'],
      priceHardcover: _parseDouble(json['price_hardcover']),
      priceSoftcover: _parseDouble(json['price_softcover']),
      stockHardcover: json['stock_hardcover'],
      stockSoftcover: json['stock_softcover'],
      language: json['language'],
      publisher: json['publisher'],
      publishYear: json['publish_year'],
      page: json['page'],
      new_added: json['newly_added'],
      hot: json['hot'],
      backgroundImageHard: json['background_image_hard'],
      backgroundImageSoft: json['background_image_soft'],
   // Default value if not provided
    );
  }

  // Helper method to parse price fields as double
  static double _parseDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0; // Fallback to 0.0 if parsing fails
    }
    if (value is int) {
      return value.toDouble();
    }
    return value?.toDouble() ?? 0.0; // Default to 0.0 if value is null
  }

  // Method to convert BookModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'author': author,
      'description': description,
      'category': categoryId,
      'subcategory': subcategoryId,
      'discount': discountId,
      'price_hardcover': priceHardcover,
      'price_softcover': priceSoftcover,
      'stock_hardcover': stockHardcover,
      'stock_softcover': stockSoftcover,
      'language': language,
      'publisher': publisher,
      'publish_year': publishYear,
      'page': page,
      'background_image_hard': backgroundImageHard,
      'background_image_soft': backgroundImageSoft,
      'newly_added': new_added,
      'hot': hot
    };
  }

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        author,
        description,
        categoryId,
        subcategoryId,
        discountId,
        priceHardcover,
        priceSoftcover,
        stockHardcover,
        stockSoftcover,
        language,
        publisher,
        publishYear,
        page,
        backgroundImageHard,
        backgroundImageSoft,
        isFavorite,
        new_added,
        hot
      ];
}
