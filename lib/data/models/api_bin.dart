import 'package:flutter_video_community/utils/safe_convert.dart';

class ApiBinData {
  ApiBinData({
    this.apiList,
    this.headerFlag = '',
    this.publicKey = '',
    this.privateKey = '',
  });

  factory ApiBinData.fromJson(Map<String, dynamic>? json) {
    final apis = <String>[];
    if (null != json && json['api'] is List) {
      for (final value in json['api'] as List) {
        apis.add(value as String);
      }
    }
    return ApiBinData(
      headerFlag: asT<String>(json, 'headerFlag'),
      publicKey: asT<String>(json, 'publicKey'),
      privateKey: asT<String>(json, 'privateKey'),
    );
  }

  @override
  String toString() {
    return 'ApiBinData{apiList: $apiList, headerFlag: $headerFlag, publicKey: $publicKey, privateKey: $privateKey}';
  }

  List<String>? apiList;
  String headerFlag;
  String publicKey;
  String privateKey;
}
