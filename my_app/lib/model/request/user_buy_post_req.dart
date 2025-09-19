// To parse this JSON data, do
//
//     final userBuyPostRequest = userBuyPostRequestFromJson(jsonString);

import 'dart:convert';

UserBuyPostRequest userBuyPostRequestFromJson(String str) =>
    UserBuyPostRequest.fromJson(json.decode(str));

String userBuyPostRequestToJson(UserBuyPostRequest data) =>
    json.encode(data.toJson());

class UserBuyPostRequest {
  int uid;
  int lid;

  UserBuyPostRequest({required this.uid, required this.lid});

  factory UserBuyPostRequest.fromJson(Map<String, dynamic> json) =>
      UserBuyPostRequest(uid: json["uid"], lid: json["lid"]);

  Map<String, dynamic> toJson() => {"uid": uid, "lid": lid};
}
