import 'package:auto_orientation/auto_orientation.dart';
import 'package:city_pickers/city_pickers.dart' hide Cache;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/akey.dart';
import 'package:flutter_video_community/config/aroute.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/event/city_changed_event.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/models/main/app_config.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/data/repository/main/main_repository.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/enum/launch.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/widgets/loading_chasing_dots.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/global/widgets/work_tag.dart';
import 'package:flutter_video_community/modules/main/widgets/tip_dialog.dart';
import 'package:flutter_video_community/modules/main/widgets/tip_dialog_2_btn.dart';
import 'package:flutter_video_community/modules/main/widgets/tip_dialog_3_btn.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/cache_util.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/http/http.dart';
import 'package:flutter_video_community/utils/umeng_util.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'api_test.dart';
import 'app_tool.dart';
import 'common_util.dart';

class AppUtil {
  static String getVipDate(String vipDate) {
    String? vipTimeStr = AppTool.isEmpty(vipDate)
        ? Cache.getInstance().userInfo?.vipTime
        : vipDate;
    debugPrint("getVipDate=$vipTimeStr");

    if (AppTool.isEmpty(vipTimeStr)) {
      return '会员已过期';
    }
    DateTime vipDateTime = DateTime.parse(vipTimeStr!);
    int vipTime = vipDateTime.millisecondsSinceEpoch;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime > vipTime) {
      return '会员已过期';
    } else {
      return '会员至${DateFormat('yyyy-MM-dd HH:mm').format(vipDateTime)}';
    }
  }

  /// 判断是否是 VIP
  static bool isVip() {
    String? vipTimeStr = Cache.getInstance().userInfo?.vipTime;
    if (AppTool.isEmpty(vipTimeStr)) {
      return false;
    }
    //int vipTimeMilliseconds = int.tryParse(vipTime) ?? 0;
    DateTime vipDateTime = DateTime.parse(vipTimeStr!);
    int vipTime = vipDateTime.millisecondsSinceEpoch;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    return vipTime > currentTime;
  }

  //根据不同的平台返回不同的clientId
  static String getClientByPlatform() {
    if (DeviceUtil.isAndroid) {
      return AppConfig.androidClientId;
    } else if (DeviceUtil.isIOS) {
      return AppConfig.iosClientId;
    } else if (DeviceUtil.isWeb) {
      return AppConfig.webClientId;
    }
    return 'unknownPlatform';
  }

  //获取设备名称
  static String getPlatform() {
    if (DeviceUtil.isIOS) {
      return 'ios';
    } else if (DeviceUtil.isAndroid) {
      return 'android';
    }
    return 'android';
  }

  //配置最优的baseUrl
  static Future<void> setupTheBestBaseUrl() async {
    String fastEndpoint = '';
    bool isWeb = DeviceUtil.isWeb;
    bool isDebug = DeviceUtil.isDebug;
    // if (isWeb && isDebug) {
    //   //fastEndpoint = 'http://43.139.52.190:100/api';
    //   fastEndpoint = 'http://localhost:8080/api'; //web调试本地代理，不能用在正式版
    // } else {
    //   fastEndpoint = await ApiTest().testApiSpeed();
    // }
    try {
      fastEndpoint = await ApiTest().testApiSpeed();
    } catch (error) {
      fastEndpoint = AppConfig.defaultBaseUrl;
    }

    if (!AppTool.isEmpty(fastEndpoint)) {
      AppConfig.baseUrl = fastEndpoint;
      DioUtils.getInstance().options.baseUrl = fastEndpoint;
    }
    //fastEndpoint = 'http://43.139.52.190:100/api';
    print(
        "isWeb=$isWeb isDebug=$isDebug testApiSpeed=>fastEndpoint = $fastEndpoint");
  }

  static String showPayName(String type) {
    switch (type) {
      case 'bank':
        return "银行卡";
      case 'alipay':
        return "支付宝";
      case 'usdt':
        return "USDT";
    }
    return '';
  }

  static String showUserId(String? userId) {
    String result = '';
    // if (!AppTool.isEmpty(userId) && userId.length > 4) {
    //   result = 'id: ${userId.substring(0, 4)}**';
    // }
    if (!AppTool.isEmpty(userId)) {
      result = 'id: $userId';
    }
    return result;
  }

  static void showCustomer(String? customerUrl) {
    AppConfigModel? config = CacheUtil.getAppConfigInfoFromCache();
    if (config == null) {
      return;
    }
    String openWay = config.customerOpenWay;
    String url = config.customerService ?? '';
    if (AppTool.isNotEmpty(customerUrl)) {
      url = customerUrl!;
    }
    if (AppTool.isEmpty(openWay) || AppTool.isEmpty(url)) {
      return;
    }
    openWay = openWay.trim();
    if (openWay != LaunchType.web.value && openWay != LaunchType.third.value) {
      return;
    }
    if (!url.contains("http")) {
      url = 'https://$url';
    }
    if (openWay.trim() == LaunchType.web.value) {
      //内置浏览器打开
      toAppWebPage(url);
    } else {
      //外置浏览器打开
      CommonUtil.launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  static Future<void> checkNeedUpdateUserInfo() async {
    if (CacheUtil.getNeedUpdateUserInfo()) {
      debugPrint("checkNeedUpdateUserInfo-> needUpdateUserInfo");
      IndexRepository indexRepository = Global.getIt<IndexRepository>();
      await indexRepository.userInfo();
      CacheUtil.setNeedUpdateUserInfo(false);
    }
  }

  static Future<Result?> selectCity(BuildContext context) async {
    Result? result = await CityPickers.showCitiesSelector(
      context: context,
      cityItemStyle: BaseStyle(fontSize: 20, color: Colors.black),
      sideBarStyle: BaseStyle(color: Colors.black54, fontSize: 20),
      topStickStyle: BaseStyle(color: Colors.black45, fontSize: 22),
      useSearchAppBar: true,
    );
    if (result != null && !AppTool.isEmpty(result.cityId)) {
      if (AppConfig.cityId != result.cityId) {
        //通过eventBus发送城市变更事件
        eventBus.fire(CityChangedEvent());
        debugPrint(
            "CityChangedEvent-fire-> AppConfig.cityId =${AppConfig.cityId} result.cityId=${result.cityId}");
      }
      AppConfig.cityId = result.cityId!;
    }
    debugPrint("selectCity->${result.toString()}");
    return result;
  }

  //去内置浏览器
  static void toAppWebPage(String url) {
    Get.toNamed(
      AppRouter.webPage,
      parameters: {'url': url},
    );
  }

  //通用的加载动画
  static Widget buildLoadingAnimation() {
    return const LoadingChasingDots(
        color: Color(0xFFFF0000), color2: Color(0xFFFF9900));
  }

  static Widget buildChapterTag(bool workVip, ChapterModel chapter) {
    bool workNeedVip = workVip; //作品是否设置了vip专享
    bool chapterNeedVip = chapter.vip; //作品章节是否设置了vip专享
    bool chapterNeedCoin = chapter.paid; //作品章节是否设置了金币付费
    if (!chapterNeedVip && !chapterNeedCoin) {
      return Gaps.empty;
    } else if (workNeedVip) {
      return const WorkTag(tag: "VIP");
    } else if (chapterNeedCoin) {
      return const WorkTag(tag: "金币");
    } else if (chapterNeedVip) {
      return const WorkTag(tag: "VIP");
    }
    return Gaps.empty;
  }

  static Future<void> consumeCoin(
      num coinsTobeConsumed, String type, String bizId, String bizTitle) async {
    if (coinsTobeConsumed < 0) {
      return;
    }
    IndexRepository indexRepository = Global.getIt<IndexRepository>();
    MainRepository mainRepository = Global.getIt<MainRepository>();
    UserModel? userInfo = await indexRepository.userInfo();
    num userCoins = userInfo?.coins ?? 0;
    debugPrint(
        "consumeCoin-> userCoins=$userCoins coinsTobeConsumed=$coinsTobeConsumed");
    if (userCoins >= coinsTobeConsumed) {
      //用户金币数大于解锁金币数时, 弹窗提示，用户点击立即解锁后 消费金币,并刷新界面
      TipDialog.show(Get.context!,
          title: "解锁需要花费$coinsTobeConsumed金币",
          btnTitle: "立即解锁", onOkBtn: () async {
        final dataMap = <String, dynamic>{
          'coins': coinsTobeConsumed,
          'busType': type,
          'busId': bizId,
          'busName': bizTitle,
        };
        await mainRepository.buy(dataMap).onError((error, stackTrace) => () {
              debugPrint('consumCoins error');
            });
        showToast("购买成功");
      });
    } else {
      //用户金币数小于解锁金币数时，弹窗提示，用户点击立即充值后去金币充值页面
      TipDialog.show(Get.context!,
          title: "金币余额不足,需要花费${coinsTobeConsumed}金币",
          btnTitle: "立即充值", onOkBtn: () {
        Get.toNamed(AppRouter.coinRecharge);
      });
    }
  }

  static void toChapterContentPage(ClassifyContentModel contentInfo) {
    debugPrint("toChapterContentPage-> type=${contentInfo.type}");
    String page = '';
    if (ContentEnum.novel.type == contentInfo.type) {
      page = AppRouter.novelRead;
    } else if (ContentEnum.comic.type == contentInfo.type) {
      page = AppRouter.comicsRead;
    }
    if (!AppTool.isEmpty(page)) {
      Get.toNamed(
        page,
        arguments: contentInfo,
      );
    }
  }

  //阅读权限验证
  static void verifyChapterContent(ClassifyContentModel? contentInfo,
      ChapterModel? chapter, Function canWatchCb) async {
    if (chapter == null || contentInfo == null) return;

    bool userCanRead = chapter.auth; //用户是vip会员或者用户已购买内容或者内容免费观看
    if (userCanRead) {
      canWatchCb();
      return;
    }
    await AppUtil.checkNeedUpdateUserInfo();

    bool userIsVip = AppUtil.isVip(); //用户是不是vip会员
    bool workNeedVip = contentInfo.vip; //作品是否设置了vip专享
    bool chapterNeedVip = chapter.vip; //作品章节是否设置了vip专享
    bool chapterNeedCoin = chapter.paid; //作品章节是否设置了金币付费
    num workCoins = contentInfo.price;
    num chapterCoins = chapter.price;

    String bizType = contentInfo.type;
    String bizTitle = contentInfo.title;
    String bizId = contentInfo.id;
    String chapterBizTitle = chapter.title;
    String chapterBizId = chapter.chapterId;

    debugPrint(
        "readContent->workNeedVip=$workNeedVip chapterNeedVip=$chapterNeedVip"
        " chapterNeedCoin=$chapterNeedCoin workCoins=$workCoins chapterCoins=$chapterCoins bizType=$bizType bizTitle=$bizTitle "
        "bizId=$bizId  chapterBizTitle=$chapterBizTitle  chapterBizId=$chapterBizId");

    //- 章节未设置付费和vip, 所以用户免费看
    if (!chapterNeedVip && !chapterNeedCoin) {
      canWatchCb();
    } else if (workNeedVip) {
      //作品设置了vip专享
      if (userIsVip) {
        canWatchCb();
      } else {
        //用户不是vip会员
        if (chapterNeedCoin) {
          // 单个章节设置付费：提示弹窗，三个按钮-[vip免费看，单章购买，整部购买]
          TipDialog3Buttons.show(Get.context!,
              t1: "开通VIP免费看",
              t2: "单章购买${chapter.price}金币",
              t3: "整部购买$workCoins金币", onBtn1: () {
            UmengUtil.upPoint(UMengType.vip,
                {'name': UMengEvent.toVipPage, 'desc': '开通VIP免费看进入VIP会员充值页面'});
            Get.toNamed(AppRouter.vipRecharge);
          }, onBtn2: () {
            UmengUtil.upPoint(UMengType.coin,
                {'name': UMengEvent.toCoinPage, 'desc': '单章节购买进入金币充值页面'});
            AppUtil.consumeCoin(
                chapterCoins, bizType, chapterBizId, chapterBizTitle);
          }, onBtn3: () {
            UmengUtil.upPoint(UMengType.coin,
                {'name': UMengEvent.toCoinPage, 'desc': '整部购买进入金币充值页面'});
            AppUtil.consumeCoin(workCoins, bizType, bizId, bizTitle);
          });
        } else {
          // 单个章节未设置付费：提示弹窗，一个按钮-[vip免费看]
          TipDialog.show(Get.context!, title: "VIP免费看", btnTitle: "开通VIP",
              onOkBtn: () async {
            Get.toNamed(AppRouter.vipRecharge);
          });
        }
      }
    } else {
      // 作品未设置vip专享
      if (chapterNeedCoin) {
        TipDialog2Buttons.show(Get.context!,
            title: "需要消耗金币购买",
            btnTitle1: "单章购买${chapter.price}金币",
            btnTitle2: "整部购买$workCoins金币", onBtn1: () {
          AppUtil.consumeCoin(
              chapterCoins, bizType, chapterBizId, chapterBizTitle);
        }, onBtn2: () {
          AppUtil.consumeCoin(workCoins, bizType, bizId, bizTitle);
        });
      } else {
        //- 章节未设置付费
        if (chapterNeedVip) {
          //- 章节设置了vip专享： vip会员才能看，如果不是vip会员，提示弹窗,一个按钮-[vip免费看]
          if (userIsVip) {
            canWatchCb();
          } else {
            TipDialog.show(Get.context!, title: "VIP免费看", btnTitle: "开通VIP",
                onOkBtn: () async {
              Get.toNamed(AppRouter.vipRecharge);
            });
          }
        } else {
          //- 章节未设置vip专享：所有用户都可以看
          canWatchCb();
        }
      }
    }
  }

  static String formatPlayerDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(0, '2');
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  //跳转总入口
  static void to(String route, String openWay) async {
    debugPrint("AppTo->route=$route open=$openWay");
    if (AppTool.isEmpty(route)) {
      return;
    }
    int open = int.parse(openWay);
    if (LaunchType.route.intV == open) {
      //路由协议
      Uri uri = Uri.parse(route);
      debugPrint("AppTo->route-uri=$uri");
      if (!uri.hasScheme) {
        debugPrint("AppTo->route-uri--hasNoScheme=$uri");
        return;
      }
      if (uri.isScheme(ARoute.schemeCmd)) {
        debugPrint("AppTo->route-uri--scheme=${uri.scheme}");

        if (uri.host == ARoute.cmdNone) {
          debugPrint("AppTo->route-uri--cmd=${uri.host}");
          return;
        }
      }
    } else if (LaunchType.app.intV == open) {
      //打开页面
      Get.toNamed(route);
    } else if (LaunchType.web.intV == open) {
      //打开内置浏览器
      String? url = await wrapUrlWithParam(route);
      if (AppTool.isNotEmpty(url)) {
        AppUtil.toAppWebPage(url!);
      }
    } else if (LaunchType.third.intV == open) {
      String? url = await wrapUrlWithParam(route);
      if (AppTool.isNotEmpty(url)) {
        CommonUtil.launchUrl(
          route,
          mode: LaunchMode.externalApplication,
        );
      }
    }
    // Get.toNamed(page)
  }

  //https://www.baidu.com?token=''"&tenantId=''"&userId=""
  //uri协议的query parameters需要客户端提供,此方法全局用所请求的参数来包装url
  static Future<String?> wrapUrlWithParam(String url) async {
    debugPrint('wrapUrlWithParam-> start=$url');
    if (AppTool.isEmpty(url)) {
      return null;
    }
    // if (!url.isURL) {
    //   return null;
    // }
    Uri uri = Uri.parse(url);
    Map<String, String?> queryMap = Map.of(uri.queryParameters);
    if (queryMap.isEmpty) {
      debugPrint('wrapUrlWithParam-> parameters=$queryMap');
      return uri.toString();
    }
    UserModel? userInfo = CacheUtil.getUserInfoFromCache();
    if (queryMap.containsKey(AKey.tenantId)) {
      queryMap[AKey.tenantId] = AppConfig.tenantId;
    }
    if (queryMap.containsKey(AKey.deviceType)) {
      queryMap[AKey.deviceType] = getPlatform();
    }
    if (queryMap.containsKey(AKey.clientId)) {
      queryMap[AKey.clientId] = AppUtil.getClientByPlatform();
    }
    if (queryMap.containsKey(AKey.deviceId)) {
      queryMap[AKey.deviceId] = await CommonUtil().deviceId();
    }
    if (queryMap.containsKey(AKey.token)) {
      queryMap[AKey.token] = Cache.getInstance().token;
    }
    if (queryMap.containsKey(AKey.userId)) {
      queryMap[AKey.userId] = userInfo?.userId;
    }
    if (queryMap.containsKey(AKey.userName)) {
      queryMap[AKey.userName] = userInfo?.userName;
    }
    if (queryMap.containsKey(AKey.nickName)) {
      queryMap[AKey.nickName] = userInfo?.nickName;
    }
    if (queryMap.containsKey(AKey.avatar)) {
      queryMap[AKey.avatar] = userInfo?.avatar;
    }
    if (queryMap.containsKey(AKey.userCoin)) {
      queryMap[AKey.userCoin] = userInfo?.coins.toString();
    }
    if (queryMap.containsKey(AKey.vipTime)) {
      queryMap[AKey.vipTime] = userInfo?.vipTime;
    }
    if (queryMap.containsKey(AKey.inviteCode)) {
      queryMap[AKey.inviteCode] = userInfo?.inviteCode;
    }
    uri = uri.replace(queryParameters: queryMap);
    debugPrint('wrapUrlWithParam-> end=${uri.toString()}');

    return uri.toString();
  }

  static void setFullScreen() {
    bool isAndroid = DeviceUtil.isAndroid;
    bool isIos = DeviceUtil.isIOS;
    if (isAndroid) {
      AutoOrientation.landscapeAutoMode();
    } else if (isIos) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
  }

  //设置竖屏
  static void setPortraitScreen() {
    bool isAndroid = DeviceUtil.isAndroid;
    bool isIos = DeviceUtil.isIOS;
    if (isAndroid) {
      AutoOrientation.portraitAutoMode();
    } else if (isIos) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
  }
}
