
// To parse this JSON data, do
//
//     final gameWithdrawalRecordModel = gameWithdrawalRecordModelFromJson(jsonString);

import 'dart:convert';

import 'account.dart';
import 'withdraw.dart';

GameWithdrawalRecordModel gameWithdrawalRecordModelFromJson(String str) => GameWithdrawalRecordModel.fromJson(json.decode(str));

String gameWithdrawalRecordModelToJson(GameWithdrawalRecordModel data) => json.encode(data.toJson());

class GameWithdrawalRecordModel {
  final String id;
  final String gameUserId;
  final String gameUsername;
  final String userId;
  final String balance;
  final String exchangeTime;
  final String status;
  final String tenantId;
  AccountModel exchangeAccount;

  GameWithdrawalRecordModel({
    required this.id,
    required this.gameUserId,
    required this.gameUsername,
    required this.userId,
    required this.balance,
    required this.exchangeTime,
    required this.status,
    required this.tenantId,
    required this.exchangeAccount,
  });

  factory GameWithdrawalRecordModel.fromJson(Map<String, dynamic> jsonMap) => GameWithdrawalRecordModel(
    id: jsonMap["id"],
    gameUserId: jsonMap["gameUserId"],
    gameUsername: jsonMap["gameUsername"],
    userId: jsonMap["userId"],
    balance: jsonMap["balance"],
    exchangeTime: jsonMap["exchangeTime"],
    status: jsonMap["status"],
    tenantId: jsonMap["tenantId"],
      exchangeAccount: AccountModel.fromJson(json.decode(jsonMap['exchangeAccount']))
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "gameUserId": gameUserId,
    "gameUsername": gameUsername,
    "userId": userId,
    "balance": balance,
    "exchangeTime": exchangeTime,
    "exchangeAccount": exchangeAccount.toString(),
    "status": status,
    "tenantId": tenantId,
  };
}
