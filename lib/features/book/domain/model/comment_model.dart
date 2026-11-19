// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// POST için kullanılacak model
class CommentCreateModel {
  final String comment;
  final double rating;
  final int bookId;
  
  CommentCreateModel({
    required this.comment,
    required this.rating,
    required this.bookId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comment': comment,
      'rating': rating,
      'bookId': bookId,
    };
  }

  String toJson() => json.encode(toMap());
}

// User model for comment response
class CommentUser {
  final int id;
  final String name;
  final String surname;
  final String phoneNumber;
  
  CommentUser({
    required this.id,
    required this.name,
    required this.surname,
    required this.phoneNumber,
  });
  
  factory CommentUser.fromMap(Map<String, dynamic> map) {
    return CommentUser(
      id: map['id'] as int,
      name: map['name'] as String,
      surname: map['surname'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }
  
  String get fullName => '$name $surname';
  
  @override
  bool operator ==(covariant CommentUser other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.surname == surname &&
      other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode => 
      id.hashCode ^ 
      name.hashCode ^ 
      surname.hashCode ^ 
      phoneNumber.hashCode;
}

// GET response için kullanılacak model
class CommentModel {
  final int id;
  final String comment;
  final String rating;
  final String createdAt;
  final CommentUser user;
  
  CommentModel({
    required this.id,
    required this.comment,
    required this.rating,
    required this.createdAt,
    required this.user,
  });

  CommentModel copyWith({
    int? id,
    String? comment,
    String? rating,
    String? createdAt,
    CommentUser? user,
  }) {
    return CommentModel(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt,
      'user': {
        'id': user.id,
        'name': user.name,
        'surname': user.surname,
        'phoneNumber': user.phoneNumber,
      },
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as int,
      comment: map['comment'] as String,
      rating: map['rating'].toString(),
      createdAt: map['createdAt'] as String,
      user: CommentUser.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => 
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  double get ratingValue => double.tryParse(rating) ?? 0.0;

  // Convenience getters
  String get userName => user.fullName;
  
  @override
  String toString() => 'CommentModel(id: $id, comment: $comment, rating: $rating, createdAt: $createdAt, user: $user)';

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.comment == comment &&
      other.rating == rating &&
      other.createdAt == createdAt &&
      other.user == user;
  }

  @override
  int get hashCode => 
      id.hashCode ^ 
      comment.hashCode ^ 
      rating.hashCode ^ 
      createdAt.hashCode ^ 
      user.hashCode;
}
