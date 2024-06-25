import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/utils/safe_convert.dart';

class VideoSearchResult {
  VideoSearchResult({
    this.total = 0,
    this.code = 0,
    this.list,
  });

  bool get success => code == 200 || code == 0;

  factory VideoSearchResult.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (null == json) {
      return VideoSearchResult(
        total: 0,
        code: 200,
        list: [],
      );
    }
    final dataList = <ClassifyContentModel>[];
    if (json['rows'] is List) {
      for (final item in json['rows']) {
        dataList.add(
          ClassifyContentModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return VideoSearchResult(
      list: dataList,
      code: asT<int>(json, 'code'),
      total: asT<int>(json, 'total'),
    );
  }

  int total;
  int code;
  List<ClassifyContentModel>? list;
}
