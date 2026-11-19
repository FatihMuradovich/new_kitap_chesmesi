class ContactModel {
  final int id;
  final String message;
  final int userId;
  final String createdAt;
  final String updatedAt;

  ContactModel({
    required this.id,
    required this.message,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  ContactModel copyWith({
    int? id,
    String? message,
    int? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return ContactModel(
      id: id ?? this.id,
      message: message ?? this.message,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] as int,
      message: map['message'] as String,
      userId: map['userId'] as int,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }
}
