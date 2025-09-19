// To parse this JSON data, do
//
//     final userProfilePostRequest = userProfilePostRequestFromJson(jsonString);

import 'dart:convert';

UserProfilePostRequest userProfilePostRequestFromJson(String str) =>
    UserProfilePostRequest.fromJson(json.decode(str));

String userProfilePostRequestToJson(UserProfilePostRequest data) =>
    json.encode(data.toJson());

class UserProfilePostRequest {
  String username;
  String phone;

  UserProfilePostRequest({required this.username, required this.phone});

  factory UserProfilePostRequest.fromJson(Map<String, dynamic> json) =>
      UserProfilePostRequest(username: json["username"], phone: json["phone"]);

  Map<String, dynamic> toJson() => {"username": username, "phone": phone};
}
