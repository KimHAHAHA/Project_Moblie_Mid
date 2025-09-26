// To parse this JSON data, do
//
//     final rewardTailGetResponse = rewardTailGetResponseFromJson(jsonString);

import 'dart:convert';

List<RewardTailGetResponse> rewardTailGetResponseFromJson(String str) =>
    List<RewardTailGetResponse>.from(
      json.decode(str).map((x) => RewardTailGetResponse.fromJson(x)),
    );

String rewardTailGetResponseToJson(List<RewardTailGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RewardTailGetResponse {
  int trid;
  int rid;
  int lid;
  int uid;
  String rewardType;
  int claimStatus;

  RewardTailGetResponse({
    required this.trid,
    required this.rid,
    required this.lid,
    required this.uid,
    required this.rewardType,
    required this.claimStatus,
  });

  factory RewardTailGetResponse.fromJson(Map<String, dynamic> json) =>
      RewardTailGetResponse(
        trid: json["trid"],
        rid: json["rid"],
        lid: json["lid"],
        uid: json["uid"],
        rewardType: json["reward_type"],
        claimStatus: json["claim_status"],
      );

  Map<String, dynamic> toJson() => {
    "trid": trid,
    "rid": rid,
    "lid": lid,
    "uid": uid,
    "reward_type": rewardType,
    "claim_status": claimStatus,
  };
}
