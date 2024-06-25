// To parse this JSON data, do
//
//     final accountModel = accountModelFromJson(jsonString);

import 'dart:convert';

AccountModel accountModelFromJson(String str) => AccountModel.fromJson(json.decode(str));

String accountModelToJson(AccountModel data) => json.encode(data.toJson());

//账户的通用model
class AccountModel {
  //type: 1.bank 2.alipay 3.ustd
  String type;
  //bank和alipay共用的字段
  String? accountHolder;
  //bank
  String? accountNumber;
  String? bankName;
  String? branch;
  //alipay
  String? alipayAccount;
  //ustd
  String? walletAddress;
  String? usdtChain;

  AccountModel({
    required this.type,
    required this.accountHolder,
    required this.accountNumber,
    required this.bankName,
    required this.branch,
    required this.alipayAccount,
    required this.walletAddress,
    required this.usdtChain,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    type: json["type"],
    accountHolder: json["accountHolder"],
    accountNumber: json["accountNumber"],
    bankName: json["bankName"],
    branch: json["branch"],
    alipayAccount: json["alipayAccount"],
    walletAddress: json["walletAddress"],
    usdtChain: json["usdtChain"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "accountHolder": accountHolder,
    "accountNumber": accountNumber,
    "bankName": bankName,
    "branch": branch,
    "alipayAccount": alipayAccount,
    "walletAddress": walletAddress,
    "usdtChain": usdtChain,
  };
}
