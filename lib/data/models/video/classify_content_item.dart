import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/models/tab.dart';

class ClassifyContentItem {
  ClassifyContentItem({
    this.time,
    this.label,
    this.content,
    this.banner,
    this.miniBanner,
    this.newUserEquityTime = 0,
    this.announcement,
    this.empty = false,
    this.equityBanner = false,
    this.contentHorizontal,
    this.sectionData,
  });

  int? time;
  String? label;
  ClassifyContentModel? content;
  List<AdsModel>? banner = [];
  List<AdsModel>? miniBanner = [];
  int newUserEquityTime;
  String? announcement;
  bool empty;
  bool equityBanner;
  ClassifyContentModel? contentHorizontal;
  TabModel? sectionData;
}
