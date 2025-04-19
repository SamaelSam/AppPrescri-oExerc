class UserModel {
  final String? id;
  final String username;
  final String email;
  final String? password;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      if (password != null) 'password': password,
    };
  }
}
