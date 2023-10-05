import 'dart:convert';


class UserModel {
  final String userId;
  final String identity;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.identity,
    required this.createdAt,
  });

  static UserModel fromJson(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      identity: map['identity'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'identity': identity,
      'createdAt': createdAt.toString(),
    };
  }

  UserModel copyWith({
    String? userId,
    String? identity,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      identity: identity ?? this.identity,
      createdAt: createdAt,
    );
  }
}
