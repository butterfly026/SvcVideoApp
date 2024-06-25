import 'package:flutter_video_community/utils/device.dart';
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class UmengUtil {
  static const String appKey = '65c316ae95b14f599d24b346';
  static const String iosKey = '65c3310395b14f599d24bd4a';
  static const String channel = 'Umeng';

  static void init() {
    if (!DeviceUtil.isWeb) {
      UmengCommonSdk.initCommon(appKey, iosKey, channel);
      UmengCommonSdk.setPageCollectionModeManual();
    }
  }

  static void upPoint(String type, Map<String, dynamic> data) {
    if (!DeviceUtil.isWeb) {
      UmengCommonSdk.onEvent(type, data);
    }
  }
}

// 友盟埋点事件
class UMengEvent {
  static const loginSuccess = 'loginSuccess'; // 登录成功
  static const gameRechargeBuy = 'game_recharge_buy'; // 游戏充值-购买

  static const advPv = "advPv"; // 查看广告
  static const toVipPage = 'toVipPage'; // 进入会员充值页面
  static const vipRechargeBtn = 'vipRechargeBtn'; // 会员充值页面立即充值按钮点击
  static const toCoinPage = 'toCoinPage'; // 进入金币充值页面
  static const coinRechargeBtn = 'coinRechargeBtn'; // 金币充值页面确认充值按钮点击
  static const gameRechargeBtn = 'gameRechargeBtn'; // 游戏充值页面购买充值按钮点击
  static const payBtn = 'payBtn'; // 立即支付按钮点击 会员和金币、游戏共用
  static const paySuccess = 'paySuccess'; // 支付成功点击 会员和金币、游戏共用
}

// 友盟埋点事件类型
class UMengType {
  static const buttonClick = "button_click"; // 点击事件
  static const login = "login"; // 登录
  static const vip = "VIP"; // vip相关埋点
  static const coin = "COIN"; // 金币相关埋点
  static const game = "GAME"; // 游戏相关埋点
}
