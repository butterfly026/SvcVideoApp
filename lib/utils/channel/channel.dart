import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'src/response.dart';

MethodChannel _platform = const MethodChannel('com.video.community')
  ..setMethodCallHandler(_methodHandler);

StreamController<RhChannelResponse> _rhResponseEventHandlerController =
    StreamController.broadcast();

Stream<RhChannelResponse> get rhResponseEventHandler =>
    _rhResponseEventHandlerController.stream;

Future<dynamic> _methodHandler(MethodCall methodCall) {
  debugPrint('method: ${methodCall.method} arguments: ${methodCall.arguments}');
  final response = RhChannelResponse.create(
    methodCall.method,
    methodCall.arguments as Map<dynamic, dynamic>,
  );

  _rhResponseEventHandlerController.add(response);
  return Future.value();
}

Future<dynamic> parseQRCode() async {
  await _platform.invokeMethod('parseQRCode');
}

Future<dynamic> installApk(String path) async {
  await _platform.invokeMethod('installApk', path);
}
