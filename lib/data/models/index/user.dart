import 'package:flutter_video_community/utils/safe_convert.dart';

class UserInfoRsp {
  const UserInfoRsp({
    this.user,
  });

  factory UserInfoRsp.fromJson(Map<String, dynamic>? json) {
    return UserInfoRsp(
      user: null == json
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  final UserModel? user;
}

class UserModel {
  final String userId;
  final String tenantId;
  final String userName;
  final String nickName;
  final String avatar;
  final String inviteCode;
  final String vipTime;
  final String deviceId;
  final String loginIp;

  /// 帐号状态（0正常 1停用）
  final String status;
  final num coins;

  UserModel({
    this.userId = '',
    this.tenantId = '',
    this.userName = '',
    this.nickName = '',
    this.avatar = '',
    this.inviteCode = '',
    this.vipTime = '',
    this.deviceId = '',
    this.status = '',
    this.loginIp = '',
    this.coins = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
      userId: asT<String>(json, 'userId'),
      tenantId: asT<String>(json, 'tenantId'),
      userName: asT<String>(json, 'userName'),
      nickName: asT<String>(json, 'nickName'),
      avatar: asT<String>(json, 'avatar'),
      inviteCode: asT<String>(json, 'inviteCode'),
      vipTime: asT<String>(json, 'vipTime'),
      deviceId: asT<String>(json, 'deviceId'),
      status: asT<String>(json, 'status'),
      loginIp: asT<String>(json, 'loginIp'),
      coins: asT<num>(json, 'coins'),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'tenantId': tenantId,
        'userName': userName,
        'nickName': nickName,
        'avatar': avatar,
        'inviteCode': inviteCode,
        'vipTime': vipTime,
        'deviceId': deviceId,
        'status': status,
        'coins': coins,
        'loginIp': loginIp,
      };
}
