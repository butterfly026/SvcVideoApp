enum RechargeType { vip, coin, gameCoin }

extension RechargeTypeExtension on RechargeType {
  String get value {
    switch (this) {
      case RechargeType.vip:
        return 'vip';
      case RechargeType.coin:
        return 'coin';
      case RechargeType.gameCoin:
        return 'gameCoin';
    }
  }

}