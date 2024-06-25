import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/widgets/loading_dialog.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/utils/channel/src/response.dart';
import 'package:flutter_video_community/utils/device.dart';
import 'package:flutter_video_community/utils/storage/index.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_video_community/utils/channel/channel.dart' as channel;

class ScanCredentialsController extends GetxController {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool _showLoading = false;

  IndexRepository get _repository => null == Get.context
      ? IndexRepository()
      : RepositoryProvider.of<IndexRepository>(Get.context!);

  @override
  void onInit() {
    super.onInit();
    channel.rhResponseEventHandler.listen((event) {
      if (event is QRCodeResponse) {
        final QRCodeResponse qrCodeResponse = event;
        if (event.isSuccessful) {
          if (qrCodeResponse.value.isNotEmpty) {
            final dataMap =
                jsonDecode(qrCodeResponse.value) as Map<String, dynamic>;
            _login(dataMap);
          }
        } else {
          showToast('二维码识别失败，请重试');
        }
      }
    });
  }

  Future<void> onGalleryButtonTapped() async {
    if (DeviceUtil.isAndroid) {
      await channel.parseQRCode();
    }
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        result = scanData;
        onQRScanSuccess(result);
      },
    );
  }

  onQRScanSuccess(Barcode? result) {
    if (null == result || result.code?.isEmpty == true) {
      return;
    }
    final dataMap = jsonDecode(result.code!) as Map<String, dynamic>;

    _login(dataMap);
  }

  onQRScanStringSuccess(String? result) {
    if (null == result) {
      return;
    }
    final dataMap = jsonDecode(result) as Map<String, dynamic>;

    _login(dataMap);
  }

  Future<void> _login(Map<String, dynamic> dataMap) async {
    if (_showLoading) {
      return;
    }
    _showLoading = true;
    if (null != Get.context) {
      LoadingDialog.show(Get.context!);
    }
    final oldUserId = dataMap['id'] as String;
    final deviceId = dataMap['deviceId'] as String;

    try {
      final dataMap = <String, dynamic>{
        'deviceId': deviceId,
        'userId': Cache.getInstance().userInfo?.userId,
      };

      final result = await _repository.changeDevice(dataMap);
      LoadingDialog.dismiss();

      if (!result) {
        _showLoading = false;

        /// 登录失败
        showToast('登录失败，请重试');
      } else {
        /// 登录成功
        showToast('您已成功切换账号');
        // eventBus.fire(
        //   SwitchAccountSuccess(result.userInfo),
        // );
        Get.until((route) => route.isFirst);
      }
    } catch (error) {
      LoadingDialog.dismiss();
      _showLoading = false;

      /// 登录失败
      showToast('登录失败，请重试');
    }
  }
}
