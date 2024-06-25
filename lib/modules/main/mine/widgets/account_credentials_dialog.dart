import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/permission.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class _AccountCredentialsController extends GetxController {
  final RxString _qrCode = ''.obs;

  RxString get qrCode => _qrCode;

  GlobalKey<ScaffoldState> qrCodeWidgetKey = GlobalKey<ScaffoldState>();

  @override
  void onReady() async {
    super.onReady();
    final userInfo = Cache.getInstance().userInfo;
    final dataMap = <String, dynamic>{
      'id': userInfo?.userId,
      'deviceId': await CommonUtil().deviceId(),
    };
    _qrCode.value = jsonEncode(dataMap);
  }

  /// 截屏
  Future<bool> capturePng() async {
    try {
      /// 检查是否有存储权限
      bool hasPermission = await PermissionUtil().requestPhotoPermission();
      BuildContext? buildContext = qrCodeWidgetKey.currentContext;

      if (null != buildContext) {
        if (hasPermission) {
          // ignore: use_build_context_synchronously
          final RenderRepaintBoundary boundary = qrCodeWidgetKey.currentContext!
              .findRenderObject()! as RenderRepaintBoundary;
          final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData = await image.toByteData(
            format: ui.ImageByteFormat.png,
          );
          if (DeviceUtil.isWeb) {
            await WebImageDownloader.downloadImageFromUInt8List(
              uInt8List: byteData!.buffer.asUint8List(),
              name: 'revover-qrcode',
            );
          } else {
            await ImageGallerySaver.saveImage(
              byteData!.buffer.asUint8List(),
            );
          }
          showToast('保存成功，请在相册中查看');
          // Storage.instance.setBool(
          //   StorageKey.accountCredentials,
          //   true,
          // );
          return true;
        } else {
          showToast("权限申请不通过");
          return false;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

class AccountCredentialsDialog extends StatelessWidget {
  AccountCredentialsDialog({super.key});

  final controller = Get.put(_AccountCredentialsController());

  static Future<void> show(BuildContext context) async {
    SmartDialog.show(
      tag: 'accountCredentials',
      builder: (_) {
        return AccountCredentialsDialog();
      },
      alignment: Alignment.center,
      backDismiss: false,
      clickMaskDismiss: false,
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'accountCredentials');
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Cache.getInstance().userInfo;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: Dimens.gap_dp48,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: Dimens.gap_dp36,
                  child: RHExtendedImage.asset(
                    Images.imgBgAccountCredentialsHeader.assetName,
                    width: double.infinity,
                    height: Dimens.gap_dp36,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: Dimens.gap_dp20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0x00FFFFFF),
                        Color(0xFFFFFFFF),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  // height: Dimens.gap_dp10 * 380,
                  margin: EdgeInsets.only(top: Dimens.gap_dp30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(Dimens.gap_dp8),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RepaintBoundary(
                        key: controller.qrCodeWidgetKey,
                        child: Container(
                          color: Theme.of(context).colorScheme.surface,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '账号防丢失\n请保管好账号凭证！',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Dimens.font_sp16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                ),
                              ),
                              Container(
                                width: Dimens.gap_dp1 * 180,
                                height: Dimens.gap_dp1 * 180,
                                margin: EdgeInsets.symmetric(
                                  vertical: Dimens.gap_dp10,
                                ),
                                alignment: Alignment.center,
                                child: Obx(
                                  () {
                                    debugPrint(
                                        'qrCode value =====> ${controller.qrCode.value}');
                                    return QrImageView(
                                      data: controller.qrCode.value,
                                      version: QrVersions.auto,
                                      size: Dimens.gap_dp10 * 18,
                                      padding: EdgeInsets.all(Dimens.gap_dp12),
                                      backgroundColor: Colors.white,
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.gap_dp10 * 7,
                                ),
                                child: Text(
                                  '社区ID：${userInfo?.userId}\n用户名：${userInfo?.userName}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimens.font_sp12,
                                    fontWeight: FontWeight.bold,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.gap_dp20,
                                ).copyWith(top: Dimens.gap_dp10),
                                child: Text(
                                  '身份卡是除手机号/账号外，唯一可用于恢复/切换账号的凭证，请及时保存并妥善保管，切勿丢失或泄露给他人',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimens.font_sp11,
                                    height: 1.5,
                                    color: const Color(0xFF626773),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.gap_dp20,
                                ).copyWith(
                                  top: Dimens.gap_dp10,
                                  bottom: Dimens.gap_dp20,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '使用方法：',
                                        style: TextStyle(
                                          fontSize: Dimens.font_sp11,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFF0E01),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n登录/切换账号时，选择身份卡扫码该二维码即可登录',
                                        style: TextStyle(
                                          fontSize: Dimens.font_sp11,
                                          color: const Color(0xFFFF0E01),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GradientButton(
                        width: double.infinity,
                        height: Dimens.gap_dp40,
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimens.gap_dp30,
                        ),
                        text: '保存',
                        onTap: () async {
                          final result = await controller.capturePng();
                          if (result) {
                            dismiss();
                          }
                        },
                      ),
                      Gaps.vGap32,
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gaps.vGap12,
          GestureDetector(
            onTap: () {
              dismiss();
            },
            child: RHExtendedImage.asset(
              Images.iconCloseCircle.assetName,
              width: Dimens.gap_dp30,
              height: Dimens.gap_dp30,
            ),
          ),
        ],
      ),
    );
  }
}
