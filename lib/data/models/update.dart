import 'package:flutter_video_community/utils/safe_convert.dart';

class UpdateModel {
  UpdateModel({
    this.content = '',
    this.downloadUrl = '',
  });

  factory UpdateModel.fromJson(Map<String, dynamic>? json) {
    return UpdateModel(
      content: asT<String>(json, 'content'),
    );
  }

  String content;
  String downloadUrl;
}
