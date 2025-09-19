// To parse this JSON data, do
//
//     final passPostReqest = passPostReqestFromJson(jsonString);

import 'dart:convert';

PassPostReqest passPostReqestFromJson(String str) =>
    PassPostReqest.fromJson(json.decode(str));

String passPostReqestToJson(PassPostReqest data) => json.encode(data.toJson());

class PassPostReqest {
  String oldPassword;
  String newPassword;

  PassPostReqest({required this.oldPassword, required this.newPassword});

  factory PassPostReqest.fromJson(Map<String, dynamic> json) => PassPostReqest(
    oldPassword: json["oldPassword"],
    newPassword: json["newPassword"],
  );

  Map<String, dynamic> toJson() => {
    "oldPassword": oldPassword,
    "newPassword": newPassword,
  };
}
