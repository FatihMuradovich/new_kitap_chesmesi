class BookAuthorModel {
  final int id;
  final String name;

  const BookAuthorModel({
    required this.id,
    required this.name,
  });

  factory BookAuthorModel.fromMap(Map<String, dynamic> map) {
    return BookAuthorModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
