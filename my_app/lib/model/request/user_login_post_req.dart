// To parse this JSON data, do
//
//     final userPostRequest = userPostRequestFromJson(jsonString);

import 'dart:convert';

UserPostRequest userPostRequestFromJson(String str) => UserPostRequest.fromJson(json.decode(str));

String userPostRequestToJson(UserPostRequest data) => json.encode(data.toJson());

class UserPostRequest {
    String username;
    String password;

    UserPostRequest({
        required this.username,
        required this.password,
    });

    factory UserPostRequest.fromJson(Map<String, dynamic> json) => UserPostRequest(
        username: json["username"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
    };
}
