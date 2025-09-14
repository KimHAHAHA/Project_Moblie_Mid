// To parse this JSON data, do
//
//     final userGetResponse = userGetResponseFromJson(jsonString);

import 'dart:convert';

UserGetResponse userGetResponseFromJson(String str) =>
    UserGetResponse.fromJson(json.decode(str));

String userGetResponseToJson(UserGetResponse data) =>
    json.encode(data.toJson());

class UserGetResponse {
  String username;
  String phone;

  UserGetResponse({required this.username, required this.phone});

  factory UserGetResponse.fromJson(Map<String, dynamic> json) =>
      UserGetResponse(
        username: json["username"] ?? "",
        phone: json["phone"] ?? "",
      );

  Map<String, dynamic> toJson() => {"username": username, "phone": phone};
}
