class BookLanguageModel {
  final int id;
  final String name;

  const BookLanguageModel({
    required this.id,
    required this.name,
  });

  factory BookLanguageModel.fromMap(Map<String, dynamic> map) {
    return BookLanguageModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
