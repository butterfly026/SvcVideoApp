import 'package:flutter_video_community/utils/safe_convert.dart';

class GameModel {
  final String customerService;
  final String customerOpenWay;
  final String logo;
  final String announcement;
  final String exchange;
  List<GameClassify>? gameClassifyVos = [];

  GameModel({
    this.customerService = '',
    this.customerOpenWay = '',
    this.logo = '',
    this.announcement = '',
    this.exchange = '',
    this.gameClassifyVos,
  });

  factory GameModel.fromJson(Map<String, dynamic>? json) {
    final List<GameClassify> classifyList = [];
    if (null != json && null != json['gameClassifyVos']) {
      final jsonList = json['gameClassifyVos'] as List;
      for (final item in jsonList) {
        classifyList.add(
          GameClassify.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return GameModel(
      customerService: asT<String>(json, 'customerService'),
      customerOpenWay: asT<String>(json, 'customerOpenWay'),
      logo: asT<String>(json, 'logo'),
      announcement: asT<String>(json, 'announcement'),
      exchange: asT<String>(json, 'exchange'),
      gameClassifyVos: classifyList,
    );
  }

  Map<String, dynamic> toJson() => {
        'customerService': customerService,
        'customerOpenWay': customerOpenWay,
        'logo': logo,
        'announcement': announcement,
        'exchange': exchange,
      };
}

class GameClassify {
  final String id;
  final String name;
  final String pic;
  final String open;
  final String tenantId;
  final int number;
  List<GameClassifyItem>? items = [];

  GameClassify({
    this.id = '',
    this.name = '',
    this.pic = '',
    this.open = '',
    this.tenantId = '',
    this.number = 0,
    this.items,
  });

  factory GameClassify.fromJson(Map<String, dynamic>? json) {
    final List<GameClassifyItem> itemList = [];
    if (null != json && null != json['gameInfoVos']) {
      final jsonList = json['gameInfoVos'] as List;
      for (final item in jsonList) {
        itemList.add(
          GameClassifyItem.fromJson(item as Map<String, dynamic>),
        );
      }
    }
    return GameClassify(
      id: asT<String>(json, 'id'),
      name: asT<String>(json, 'name'),
      pic: asT<String>(json, 'pic'),
      open: asT<String>(json, 'open'),
      tenantId: asT<String>(json, 'tenantId'),
      number: asT<int>(json, 'number'),
      items: itemList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'pic': pic,
        'open': open,
        'tenantId': tenantId,
        'number': number,
      };
}

class GameClassifyItem {
  final String id;
  final String name;
  final String logo;
  final String code;
  final String tenantId;
  final String gameClassifyId;
  final int number;

  GameClassifyItem({
    this.id = '',
    this.name = '',
    this.logo = '',
    this.code = '',
    this.tenantId = '',
    this.gameClassifyId = '',
    this.number = 0,
  });

  factory GameClassifyItem.fromJson(Map<String, dynamic>? json) {
    return GameClassifyItem(
      id: asT<String>(json, 'id'),
      name: asT<String>(json, 'name'),
      logo: asT<String>(json, 'logo'),
      code: asT<String>(json, 'code'),
      tenantId: asT<String>(json, 'tenantId'),
      gameClassifyId: asT<String>(json, 'gameClassifyId'),
      number: asT<int>(json, 'number'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logo': logo,
        'code': code,
        'tenantId': tenantId,
        'gameClassifyId': gameClassifyId,
        'number': number,
      };
}

class GameActivityModel {
  final String id;
  final String name;
  final String pic;
  final String url;
  final String openType;
  final String type;

  GameActivityModel({
    this.id = '',
    this.name = '',
    this.pic = '',
    this.url = '',
    this.openType = '',
    this.type = '',
  });

  factory GameActivityModel.fromJson(Map<String, dynamic>? json) {
    return GameActivityModel(
      id: asT<String>(json, 'id'),
      name: asT<String>(json, 'name'),
      pic: asT<String>(json, 'pic'),
      url: asT<String>(json, 'url'),
      openType: asT<String>(json, 'openType'),
      type: asT<String>(json, 'type'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'pic': pic,
        'url': url,
        'openType': openType,
        'type': type,
      };
}
