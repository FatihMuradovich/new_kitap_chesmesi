import 'package:equatable/equatable.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';

class OrderModel extends Equatable {
  final BookModel book;
  final int quantity;

  const OrderModel({
    required this.book,
    required this.quantity,
  });

  // Factory constructor to create an OrderModel from a JSON map.
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      book: BookModel.fromJson(json['book'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  // Converts an OrderModel object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'book': book.toJson(),
      'quantity': quantity,
    };
  }

  // Creates a copy of the OrderModel with updated quantity.
  OrderModel copyWith({
    BookModel? book,
    int? quantity,
  }) {
    return OrderModel(
      book: book ?? this.book,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [book, quantity];
}
