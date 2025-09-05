// To parse this JSON data, do
//
//     final userPostResponse = userPostResponseFromJson(jsonString);

import 'dart:convert';

UserPostResponse userPostResponseFromJson(String str) => UserPostResponse.fromJson(json.decode(str));

String userPostResponseToJson(UserPostResponse data) => json.encode(data.toJson());

class UserPostResponse {
    int uid;
    String role;
    String username;
    String phone;
    String walletBalance;

    UserPostResponse({
        required this.uid,
        required this.role,
        required this.username,
        required this.phone,
        required this.walletBalance,
    });

    factory UserPostResponse.fromJson(Map<String, dynamic> json) => UserPostResponse(
        uid: json["uid"],
        role: json["role"],
        username: json["username"],
        phone: json["phone"],
        walletBalance: json["wallet_balance"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "role": role,
        "username": username,
        "phone": phone,
        "wallet_balance": walletBalance,
    };
}
