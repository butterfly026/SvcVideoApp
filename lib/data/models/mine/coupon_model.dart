import 'package:flutter_video_community/utils/safe_convert.dart';

class CouponModel {
  final String cardId;
  final String userId;
  final String rechargePackageId;
  final String rechargePackageType;
  final String price;
  final String expiresDate;

  CouponModel({
    this.cardId = '',
    this.userId = '',
    this.rechargePackageId = '',
    this.rechargePackageType = '',
    this.price = '',
    this.expiresDate = '',
  });

  factory CouponModel.fromJson(Map<String, dynamic>? json) {
    return CouponModel(
      cardId: asT<String>(json, 'cardId'),
      userId: asT<String>(json, 'userId'),
      rechargePackageId: asT<String>(json, 'rechargePackageId'),
      rechargePackageType: asT<String>(json, 'rechargePackageType'),
      price: asT<String>(json, 'price'),
      expiresDate: asT<String>(json, 'expiresDate'),
    );
  }
}
