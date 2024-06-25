import 'package:flutter_video_community/utils/safe_convert.dart';

class ClassifyContentModel {
  final String id;
  final String appId;
  final String classifyId;
  final String title;
  final String type;
  final String pic;
  final String des;
  final String open;
  final String outId;
  final String isVip;
  final bool haveCollect;
  final num price;

  final String address;
  final String source;
  final List<ChapterModel>? chapters;

  List<ChapterModel> get chapterList => chapters ?? [];

  ChapterModel? get firstChapter =>
      chapterList.isNotEmpty ? chapterList.first : null;

  ClassifyContentModel({
    /// 作品ID
    this.id = '',
    this.appId = '',

    /// 分类ID
    this.classifyId = '',
    this.title = '',
    this.type = '',
    this.pic = '',
    this.des = '',

    /// 作品状态
    this.open = '',

    /// 外部ID
    this.outId = '',

    /// 是否为VIP专享
    this.isVip = '',
    this.address = '',
    this.source = '',
    this.chapters,
    this.haveCollect = false,
    this.price = -1,
  });

  bool get vip => isVip == 'Y';

  factory ClassifyContentModel.fromJson(
    Map<String, dynamic>? json, {
    bool live = false,
  }) {
    if (live) {
      return ClassifyContentModel(
        id: asT<String>(json, 'id'),
        address: asT<String>(json, 'address'),
        pic: asT<String>(json, 'img'),
        title: asT<String>(json, 'title'),
        open: asT<String>(json, 'open'),
        classifyId: asT<String>(json, 'classifyId'),
        source: asT<String>(json, 'source'),
        price: asT<num>(json, 'price'),
        haveCollect: asT<bool>(json, 'haveCollect'),
      );
    }

    final dataList = <ChapterModel>[];
    if (null != json && json['chapterList'] is List) {
      for (final item in json['chapterList']) {
        dataList.add(
          ChapterModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    return ClassifyContentModel(
      id: asT<String>(json, 'workId'),
      appId: asT<String>(json, 'appId'),
      classifyId: asT<String>(json, 'classifyId'),
      title: asT<String>(json, 'title'),
      type: asT<String>(json, 'type'),
      pic: asT<String>(json, 'pic'),
      des: asT<String>(json, 'des'),
      open: asT<String>(json, 'open'),
      outId: asT<String>(json, 'outId'),
      isVip: asT<String>(json, 'isVip'),
      price: asT<num>(json, 'price'),
      haveCollect: asT<bool>(json, 'haveCollect'),
      chapters: dataList,
    );
  }

  Map<String, dynamic> toJson() => {
        'workId': id,
        'appId': appId,
        'classifyId': classifyId,
        'title': title,
        'type': type,
        'pic': pic,
        'des': des,
        'open': open,
        'outId': outId,
        'isVip': isVip,
        'price': price,
        'haveCollect': haveCollect,
      };
}

class ChapterModel {
  ChapterModel({
    this.chapterId = '',
    this.workId = '',
    this.title = '',
    this.isVip = '',
    this.isPaid = '',
    this.number = '',
    this.price = 0,
    this.selected = false,
    this.content = '',
    this.auth = false,
  });

  final String chapterId;
  final String workId;
  final String title;
  final String isVip;
  String isPaid;
  num price;
  final String number;
  bool selected;
  final String content;
  bool auth;

  /// 是否是 vip专享
  bool get vip => isVip == 'Y';

  /// 是否是付费内容
  bool get paid => isPaid == 'Y';

  factory ChapterModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    return ChapterModel(
      chapterId: asT<String>(json, 'chapterId'),
      workId: asT<String>(json, 'workId'),
      title: asT<String>(json, 'title'),
      isVip: asT<String>(json, 'isVip'),
      isPaid: asT<String>(json, 'isPaid'),
      number: asT<String>(json, 'number'),
      price: asT<num>(json, 'price'),
      content: asT<String>(json, 'content'),
      auth: asT<bool>(json, 'auth'),
    );
  }
}
