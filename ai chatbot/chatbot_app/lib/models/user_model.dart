class UserModel {
  final String userId;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? activeOrderId;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.activeOrderId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json['userId'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        avatarUrl: json['avatarUrl'] as String?,
        activeOrderId: json['activeOrderId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'activeOrderId': activeOrderId,
      };
}
