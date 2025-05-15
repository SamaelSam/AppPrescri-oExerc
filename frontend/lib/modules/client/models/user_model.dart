class UserModel {
  final String id;
  final String username;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] is Map
          ? json['_id']['\$oid'] // MongoDB padrão
          : json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'role': role,
    };
  }
}
