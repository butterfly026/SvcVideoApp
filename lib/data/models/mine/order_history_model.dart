import 'package:flutter_video_community/utils/safe_convert.dart';

class OrderHistoryModel {
  final String id;
  final String userId;
  final String orderNo;
  final String rechargePackageId;
  final String rechargePackageType;
  final String totalPrice;
  final int amount;
  final int orderStatue;
  final String createTime;

  OrderHistoryModel({
    this.id = '',
    this.userId = '',
    this.orderNo = '',
    this.rechargePackageId = '',
    this.rechargePackageType = '',
    this.totalPrice = '',
    this.amount = 0,
    this.orderStatue = 0,
    this.createTime = ''
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic>? json) {
    return OrderHistoryModel(
      id: asT<String>(json, 'id'),
      userId: asT<String>(json, 'userId'),
      orderNo: asT<String>(json, 'orderNo'),
      rechargePackageId: asT<String>(json, 'rechargePackageId'),
      rechargePackageType: asT<String>(json, 'rechargePackageType'),
      totalPrice: asT<String>(json, 'totalPrice'),
      amount: asT<int>(json, 'amount'),
      orderStatue: asT<int>(json, 'orderStatue'),
      createTime: asT<String>(json, 'createTime'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'orderNo': orderNo,
        'rechargePackageId': rechargePackageId,
        'rechargePackageType': rechargePackageType,
        'totalPrice': totalPrice,
        'orderStatue': orderStatue,
        'amount': amount,
        'createTime': createTime,
      };
}
