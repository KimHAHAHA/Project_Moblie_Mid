// To parse this JSON data, do
//
//     final userRegisterPostRequest = userRegisterPostRequestFromJson(jsonString);

import 'dart:convert';

UserRegisterPostRequest userRegisterPostRequestFromJson(String str) => UserRegisterPostRequest.fromJson(json.decode(str));

String userRegisterPostRequestToJson(UserRegisterPostRequest data) => json.encode(data.toJson());

class UserRegisterPostRequest {
    String username;
    String password;
    String phone;
    int walletBalance;

    UserRegisterPostRequest({
        required this.username,
        required this.password,
        required this.phone,
        required this.walletBalance,
    });

    factory UserRegisterPostRequest.fromJson(Map<String, dynamic> json) => UserRegisterPostRequest(
        username: json["username"],
        password: json["password"],
        phone: json["phone"],
        walletBalance: json["wallet_balance"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "phone": phone,
        "wallet_balance": walletBalance,
    };
}
