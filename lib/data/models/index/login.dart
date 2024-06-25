import 'package:flutter_video_community/utils/safe_convert.dart';

class LoginModel {
  final String register;
  String accessToken;
  final String clientId;
  int newUserEquityTime;
  final int expireIn;

  LoginModel({
    this.register = '',
    this.accessToken = '',
    this.clientId = '',

    /// 新用户权益时间
    /// 可通过该字段值判定是否为新用户，
    /// 适用于新用户活动等场景，
    /// 例如新用户充值活动倒计时等
    this.newUserEquityTime = 0,
    this.expireIn = 0,
  });

  /// 是否是新用户
  bool get isRegister => register == 'Y';

  factory LoginModel.fromJson(Map<String, dynamic>? json) {
    return LoginModel(
      register: asT<String>(json, 'register'),
      accessToken: asT<String>(json, 'access_token'),
      clientId: asT<String>(json, 'client_id'),
      newUserEquityTime: asT<int>(json, 'newUserEquityTime'),
      expireIn: asT<int>(json, 'expire_in'),
    );
  }

  Map<String, dynamic> toJson() => {
        'register': register,
        'access_token': accessToken,
        'client_id': clientId,
        'newUserEquityTime': newUserEquityTime,
        'expireIn': expireIn,
      };
}
