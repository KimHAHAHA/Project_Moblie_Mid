// To parse this JSON data, do
//
//     final rewardGetResponse = rewardGetResponseFromJson(jsonString);

import 'dart:convert';

List<RewardGetResponse> rewardGetResponseFromJson(String str) =>
    List<RewardGetResponse>.from(
      json.decode(str).map((x) => RewardGetResponse.fromJson(x)),
    );

String rewardGetResponseToJson(List<RewardGetResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RewardGetResponse {
  int rid;
  int lid;
  dynamic uid;
  int rewardRank;
  String prizeAmount;
  int claimStatus;
  String lottoNumber;

  RewardGetResponse({
    required this.rid,
    required this.lid,
    required this.uid,
    required this.rewardRank,
    required this.prizeAmount,
    required this.claimStatus,
    required this.lottoNumber,
  });

  factory RewardGetResponse.fromJson(Map<String, dynamic> json) =>
      RewardGetResponse(
        rid: json["rid"],
        lid: json["lid"],
        uid: json["uid"],
        rewardRank: json["reward_rank"],
        prizeAmount: json["prize_amount"],
        claimStatus: json["claim_status"],
        lottoNumber: json["lotto_number"],
      );

  Map<String, dynamic> toJson() => {
    "rid": rid,
    "lid": lid,
    "uid": uid,
    "reward_rank": rewardRank,
    "prize_amount": prizeAmount,
    "claim_status": claimStatus,
    "lotto_number": lottoNumber,
  };

  @override
  String toString() {
    return 'RewardGetResponse('
        'rid: $rid, '
        'lid: $lid, '
        'uid: $uid, '
        'rewardRank: $rewardRank, '
        'prizeAmount: $prizeAmount, '
        'claimStatus: $claimStatus, '
        'lottoNumber: $lottoNumber'
        ')';
  }
}
