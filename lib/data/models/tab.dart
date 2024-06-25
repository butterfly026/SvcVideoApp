import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/utils/safe_convert.dart';

import 'main/web.dart';

class TabModel {
  final String id;
  final int parentId;
  final String name;
  final String type;
  final String outId;
  final String appId;

  final String address;
  final String url;
  final String img;
  final String open;
  final String openWay;
  final String source;

  List<ClassifyContentModel>? workList;
  List<TabModel>? children;

  TabModel({
    this.id = '',
    this.parentId = 0,
    this.name = '',
    this.type = '',
    this.outId = '',
    this.appId = '',
    this.address = '',
    this.url = '',
    this.img = '',
    this.open = '',
    this.openWay = '',
    this.source = '',
    this.workList,
    this.children, //二级分类
  });

  /// 分类子标签
  List<TabModel> get childrenList => children ?? [];

  /// 分类内容
  List<ClassifyContentModel> get dataList => workList ?? [];

  WebModel toWebData() {
    return WebModel(url: url);
  }

  factory TabModel.fromJson(
    Map<String, dynamic>? json, {
    bool live = false,
  }) {
    if (live) {
      return TabModel(
        id: asT<String>(json, 'id'),
        name: asT<String>(json, 'title'),
        url: asT<String>(json, 'url'),
        img: asT<String>(json, 'img'),
        source: asT<String>(json, 'source'),
        appId: asT<String>(json, 'appId'),
        parentId: asT<int>(json, 'parentId'),
        open: asT<String>(json, 'open'),
        openWay: asT<String>(json, 'openWay'),
        address: asT<String>(json, 'address'),
      );
    }
    final dataList = <ClassifyContentModel>[];
    if (null != json && null != json['workList']) {
      for (final item in json['workList'] as List) {
        dataList.add(
          ClassifyContentModel.fromJson(
            item as Map<String, dynamic>,
          ),
        );
      }
    }

    final childrenList = <TabModel>[];
    if (null != json && null != json['children']) {
      for (final item in json['children'] as List) {
        childrenList.add(
          TabModel.fromJson(
            item as Map<String, dynamic>,
          ),
        );
      }
    }
    String addr = asT<String>(json, 'address');
    String? type = '';
    if (addr.isNotEmpty) {
      final uri =  Uri.dataFromString(addr);
      type = uri.queryParameters['type'] ?? '';
    }
    return TabModel(
      id: asT<String>(json, 'classifyId'),
      name: asT<String>(json, 'classifyName'),
      type: type,
      outId: asT<String>(json, 'outId'),
      appId: asT<String>(json, 'appId'),
      parentId: asT<int>(json, 'parentId'),
      open: asT<String>(json, 'open'),
      openWay: asT<String>(json, 'openWay'),
      address: asT<String>(json, 'address'),
      workList: dataList,
      children: childrenList,
    );
  }

  Map<String, dynamic> toJson() => {
        'classifyId': id,
        'classifyName': name,
        'moduleType': type,
        'outId': outId,
        'appId': appId,
      };
}
