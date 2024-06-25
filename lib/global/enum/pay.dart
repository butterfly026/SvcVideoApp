enum PayType { bank, alipay, usdt }

class PayTypeMatcher {
  static PayType match(String value) {
    return PayType.values.firstWhere(
      (element) => value == element.value,
    );
  }
}

extension PayTypeExtension on PayType {
  String get value {
    switch (this) {
      case PayType.bank:
        return '银行卡';
      case PayType.alipay:
        return '支付宝';
      case PayType.usdt:
        return 'USDT';
    }
  }

  String get type {
    switch (this) {
      case PayType.bank:
        return 'bank';
      case PayType.alipay:
        return 'alipay';
      case PayType.usdt:
        return 'usdt';
    }
  }
}

enum UsdtType {
  trc20,
  erc20,
}

class UsdtTypeMatcher {
  static UsdtType match(String value) {
    return UsdtType.values.firstWhere(
      (element) => value == element.value,
    );
  }
}

extension UsdtTypeExtension on UsdtType {
  String get value {
    switch (this) {
      case UsdtType.trc20:
        return 'TRC-20';
      case UsdtType.erc20:
        return 'ERC-20';
    }
  }
}
