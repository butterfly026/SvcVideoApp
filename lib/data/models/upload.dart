import 'package:flutter_video_community/utils/safe_convert.dart';

class UploadModel {
  const UploadModel({
    this.url = '',
    this.fileName = '',
    this.ossId = '',
  });

  factory UploadModel.fromJson(Map<String, dynamic>? json) {
    return UploadModel(
      url: asT<String>(json, 'url'),
      fileName: asT<String>(json, 'fileName'),
      ossId: asT<String>(json, 'ossId'),
    );
  }

  final String url;
  final String fileName;
  final String ossId;
}
