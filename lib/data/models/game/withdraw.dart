class BankModel {
  BankModel({
    this.type = 'bank',
    this.accountHolder = '',
    this.accountNumber = '',
    this.bankName = '',
    this.branch = '',
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'accountHolder': accountHolder,
        'accountNumber': accountNumber,
        'bankName': bankName,
        'branch': branch,
      };

  String type;
  String accountHolder;
  String accountNumber;
  String bankName;
  String branch;
}

class AlipayModel {
  AlipayModel({
    this.type = 'alipay',
    this.accountHolder = '',
    this.alipayAccount = '',
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'accountHolder': accountHolder,
        'alipayAccount': alipayAccount,
      };

  String type;
  String accountHolder;
  String alipayAccount;
}

class UsdtModel {
  UsdtModel({
    this.type = 'usdt',
    this.walletAddress = '',
    this.usdtChain = '',
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'walletAddress': walletAddress,
        'usdtChain': usdtChain,
      };

  String type;
  String walletAddress;
  String usdtChain;
}
