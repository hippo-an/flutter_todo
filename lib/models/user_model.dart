


class UserModel {
  final String userId;
  final String username;
  final String identity;
  final int colorCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.userId,
    required this.username,
    required this.identity,
    required this.colorCode,
    required this.createdAt,
    required this.updatedAt,
  });

  static UserModel fromJson(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      username: map['username'],
      identity: map['identity'],
      colorCode: map['colorCode'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'identity': identity,
      'colorCode': colorCode,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }

}
