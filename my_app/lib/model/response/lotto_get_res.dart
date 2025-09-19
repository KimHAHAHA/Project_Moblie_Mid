// To parse this JSON data, do
//
//     final lottosGetResponse = lottosGetResponseFromJson(jsonString);

import 'dart:convert';

List<LottosGetResponse> lottosGetResponseFromJson(String str) =>
    List<LottosGetResponse>.from(
      json.decode(str).map((x) => LottosGetResponse.fromJson(x)),
    );

String lottosGetResponseToJson(List<LottosGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LottosGetResponse {
  int lid;
  String lottoStatus;
  String lottoNumber;
  String price;
  int? uid;

  LottosGetResponse({
    required this.lid,
    required this.lottoStatus,
    required this.lottoNumber,
    required this.price,
    required this.uid,
  });

  factory LottosGetResponse.fromJson(Map<String, dynamic> json) =>
      LottosGetResponse(
        lid: json["lid"],
        lottoStatus: json["lotto_status"],
        lottoNumber: json["lotto_number"],
        price: json["price"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
    "lid": lid,
    "lotto_status": lottoStatus,
    "lotto_number": lottoNumber,
    "price": price,
    "uid": uid,
  };
}
