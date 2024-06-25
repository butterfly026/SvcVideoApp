import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/data/models/main/app_config.dart';
import 'package:flutter_video_community/data/models/main/main_app.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/opennstall_util.dart';
import 'package:flutter_video_community/utils/permission.dart';
import 'package:flutter_video_community/utils/version.dart';
import 'package:flutter_video_community/widgets/dialog.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../utils/umeng_util.dart';
import 'widgets/update.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();

  Rx<AppConfigModel?> appConfigInfo = Rx(null);
  Rx<MainAppModel?> mainAppInfo = Rx(null);

  IndexRepository get _repository => Global.getIt<IndexRepository>();

  BuildContext? get context => Get.context;

  @override
  void onReady() async {
    super.onReady();
    checkDeviceSafety();
  }

  Future<void> checkDeviceSafety() async {
        //如果平台是 Android，请检查 root 权限。如果是，则退出 APP
    bool isSafeDevice = DeviceUtil.isMobile ? await PermissionUtil.isSafeDevice() : true;
    bool isVpnActive = (DeviceUtil.isMobile || DeviceUtil.isMacOS) ? await PermissionUtil.isVpnActive() : false;
    if (!isSafeDevice || isVpnActive) {
      showToast(
        '抱歉，无法在此设备上运行。',
        duration: const Duration(seconds: 3),
        position: ToastPosition.bottom
      );
      Future.delayed(const Duration(seconds: 3), () {
        exit(0);
      });
    } else {
      _login();
    }
  }

  Future<void> _login() async {
    if (!DeviceUtil.isWeb) {
      /// 如果有channelCode，优先取channelCode作为inviteCode。
      /// 如果channelCode为空，则判断bindData中是否含有inviteCode，如果有，则作为inviteCode。
      /// 否则，从剪贴板读取数据，判断规则：是否以vo开头。
      OpenInstallTool().openinstallFlutterPlugin.install((opData) async {
        try {
          String inviteCode = '';
          SpUtil.putString('op_data', jsonEncode(opData));
          debugPrint('op newest opData ====> $opData');
          final channelCode = opData['channelCode'] as String?;
          final bindData = opData['bindData'] as String?;
          // 先判断APP唤起的时候op有没有穿参数进来
          if (OpenInstallTool.evokeData['channelCode'] != null &&
              OpenInstallTool.evokeData['channelCode'] != '') {
            inviteCode = OpenInstallTool.evokeData['channelCode'];
          } else if (null != channelCode && channelCode.isNotEmpty) {
            inviteCode = channelCode;
          } else if (null != bindData && bindData.isNotEmpty) {
            final bindDataMap = jsonDecode(bindData) as Map<String, dynamic>?;
            if (null != bindDataMap && bindDataMap.containsKey('inviteCode')) {
              final inviteText = bindDataMap['inviteCode'] as String?;
              if (null != inviteText && inviteText.isNotEmpty) {
                inviteCode = inviteText;
              }
            } else {
              inviteCode = await parseInviteCode();
            }
          } else {
            inviteCode = await parseInviteCode();
          }
          _postInvitecode(inviteCode);
        } catch (error) {
          _postInvitecode('');
          debugPrint("err=${error.toString()}");
        }
      });
    } else {
      _postInvitecode('');
    }
  }

  Future<void> _postInvitecode(String inviteCode) async {
    try {
      final curVer = await CommonUtil().version();
      print("curVer=>${curVer}");
      final dataMap = <String, dynamic>{
        'inviteCode': inviteCode,
      };
      //配置最优baseUrl
      await AppUtil.setupTheBestBaseUrl();
      final loginResult = await _repository.login(dataMap);

      print('op newest login ====>');

      // 登录上报
      if (loginResult.register != 'N') {
        OpenInstallTool.reportRegister();
      }

      // LoadingDialog.dismiss();
      // loginResult.newUserEquityTime = 56000;
      GlobalController.to.newUserEquityTime.value =
          loginResult.newUserEquityTime;

      if (loginResult.newUserEquityTime > 0) {
        GlobalController.to.startCountdown(
          loginResult.newUserEquityTime,
        );
      }

      /// 主应用配置信息
      // await _repository.userInfo();
      final mainAppInfo = await _repository.mainAppInfo();
      // mainAppInfo?.freeTime = 20;
      this.mainAppInfo.value = mainAppInfo;

      await GlobalController.to.getAdsData();

      /// App配置信息
      final appConfigInfo = await _repository.appConfigInfo();
      this.appConfigInfo.value = appConfigInfo;
      if (null != appConfigInfo && null != Get.context) {
        String serverVer = appConfigInfo.version;
        String clientVer = curVer;
        bool hasNewVer = VersionUtil.isGt(serverVer, clientVer);
        print(
            "vv3=>${serverVer}  ${clientVer}  ${hasNewVer}  ${appConfigInfo.needUpdate}");

        if (!DeviceUtil.isWeb) {
          if (appConfigInfo.needUpdate) {
            //如果needUpdate字段为true，隐藏暂时更新按钮,强制更新。如果needUpdate字段不为true，服务端版本号大于客户端，显示更新弹窗，
            AppUpdateDialog.show(
              Get.context!,
              data: appConfigInfo.updateInfo,
              onCancel: null,
            );
          } else if (hasNewVer) {
            AppUpdateDialog.show(
              Get.context!,
              data: appConfigInfo.updateInfo,
              onCancel: () {
                UmengUtil.upPoint(UMengType.login,
                    {'name': UMengEvent.loginSuccess, 'desc': '登录成功'});
                Get.offAndToNamed(AppRouter.main);
              },
            );
          } else {
            UmengUtil.upPoint(UMengType.login,
                {'name': UMengEvent.loginSuccess, 'desc': '登录成功'});
            Get.offAndToNamed(AppRouter.main);
          }
        } else {
          UmengUtil.upPoint(UMengType.login,
              {'name': UMengEvent.loginSuccess, 'desc': '登录成功'});
          Get.offAndToNamed(AppRouter.main);
        }
      }
    } catch (error) {
      debugPrint("err1=${error.toString()}");
    }
  }

  //读取用户复制的邀请码
  Future<String> parseInviteCode() async {
    String result = "";
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    String inviteCode = data?.text ?? "";
    if (!AppTool.isEmpty(inviteCode) && inviteCode.contains("channelCode")) {
      Map<String, dynamic> data = jsonDecode(inviteCode);
      result = data['channelCode'];
    }
    // 判断剪切板内容是否是渠道码
    if (!AppTool.isEmpty(inviteCode) && inviteCode.startsWith('vo')) {
      result = inviteCode;
    }
    print("inviteCode=${result}");
    return result;
  }
}
