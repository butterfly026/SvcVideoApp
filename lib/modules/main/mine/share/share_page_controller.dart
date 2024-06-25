import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/permission.dart';
import 'package:get/get.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:ui' as ui;

class SharePageController extends GetxController {
  GlobalKey<ScaffoldState> rootWidgetKey = GlobalKey<ScaffoldState>();

  RxString qrCodeContent = RxString('');
  Rx<UserModel?> userInfo = Rx(null);

  @override
  void onReady() {
    super.onReady();
    final appConfigInfo = Cache.getInstance().appConfig;
    if (null != appConfigInfo) {
      qrCodeContent.value = appConfigInfo.shareUrl;
    }
    userInfo.value = Cache.getInstance().userInfo;
  }

  Future capturePng() async {
    try {
      /// 检查是否有存储权限
      bool hasPermission = await PermissionUtil().requestPhotoPermission();
      BuildContext? buildContext = rootWidgetKey.currentContext;

      if (null != buildContext) {
        if (hasPermission) {
          final RenderRepaintBoundary boundary = rootWidgetKey.currentContext!
              .findRenderObject()! as RenderRepaintBoundary;
          final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);

          if (DeviceUtil.isWeb) {
            await WebImageDownloader.downloadImageFromUInt8List(
                uInt8List: byteData!.buffer.asUint8List(),
                name: 'share-qrcode');
          } else {
            await ImageGallerySaver.saveImage(
              byteData!.buffer.asUint8List(),
            );
          }
          showToast('保存成功，请在相册中查看');
        } else {
          showToast("权限申请不通过");
        }
      }
    } catch (error) {
      /// void
    }
  }
}
