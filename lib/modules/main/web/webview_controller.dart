import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/event/update_download_progress.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/modules/main/web/widgets/download_dialog.dart';
import 'package:flutter_video_community/utils/http/http.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class WebViewController extends GetxController {
  static WebViewController get to => Get.find();

  final ReceivePort _port = ReceivePort();

  Rx<UpdateDownloadProgress?> downloadEvent = Rx(null);

  @override
  void onReady() {
    super.onReady();
    _bindBackgroundIsolate();
  }

  Future<void> startDownload(
    BuildContext context,
    String downloadUrl,
  ) async {
    final appDir = await getApplicationDocumentsDirectory();
    final apkFile = await File(
      '${appDir.path}/apk/${DateTime.now().millisecond}.apk',
    ).create(recursive: true);
    bool downloadCompleted = false;
    http.download(
      downloadUrl,
      apkFile.path,
      deleteOnError: true,
      onReceiveProgress: (count, total) async {
        if (total != -1) {
          final double ratio = count / total;
          debugPrint('${(ratio * 100).toStringAsFixed(0)}%');

          final event = UpdateDownloadProgress(
            progress: ratio,
            path: apkFile.path,
            web: true,
          );
          eventBus.fire(event);

          if (downloadCompleted) {
            return;
          }

          if (ratio >= 1.0 && !downloadCompleted) {
            downloadCompleted = true;
            event.downloadCompleted = true;
            // final installSuccess = await RUpgrade.installByPath(apkFile.path);
            // debugPrint('installSuccess ========> $installSuccess');
          } else {
            event.downloadCompleted = false;
          }
          downloadEvent.value = event;
        }
      },
      options: Options(
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );
    if (context.mounted) {
      DownloadDialog.show(context);
    }
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'web_downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final appId = (data as List<dynamic>)[0] as String;
      final progress = data[1] as int;

      debugPrint(
        'Callback on UI isolate: '
        'appId ($appId) download process ($progress)',
      );
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('web_downloader_send_port');
  }
}
