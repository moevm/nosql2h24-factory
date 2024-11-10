import '../../../../shared/data/models/user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String requestToken;
  final String username;

  AuthResponseModel({
    required this.accessToken,
    required this.requestToken,
    required this.username,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'],
      requestToken: json['request_token'],
      username: json['username'],
    );
  }
}