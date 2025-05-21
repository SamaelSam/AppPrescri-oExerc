import 'package:frontend/modules/client/models/user_model.dart';

class AuthToken {
  final String accessToken;
  final String tokenType;
  final UserModel user;

  AuthToken({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) => AuthToken(
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        user: UserModel.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'token_type': tokenType,
        'user': user.toJson(),
      };
}