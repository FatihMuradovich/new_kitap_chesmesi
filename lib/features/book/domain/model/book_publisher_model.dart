class BookPublisherModel {
  final int id;
  final String name;

  const BookPublisherModel({
    required this.id,
    required this.name,
  });

  factory BookPublisherModel.fromMap(Map<String, dynamic> map) {
    return BookPublisherModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
