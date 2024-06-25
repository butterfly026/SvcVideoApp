import 'package:flutter_video_community/data/models/main/web.dart';
import 'package:flutter_video_community/utils/safe_convert.dart';

class BottomTabModel {
  final String id;
  final String name;
  final String icon;
  final String unselectedIcon;
  final String content;
  final int number;
  final String openType;
  final String tenantId;
  bool lock;
  bool auth;
  final num unlockPrice;

  BottomTabModel({
    this.id = '',
    this.name = '',
    this.icon = '',
    this.unselectedIcon = '',
    this.content = '',
    this.number = 0,
    this.openType = '',
    this.tenantId = '',
    this.lock = false,
    this.auth = false,
    this.unlockPrice = 0.0,
  });

  String get url => content;

  String get action => openType;

  WebModel toWebData() {
    return WebModel(url: url);
  }

  factory BottomTabModel.fromJson(Map<String, dynamic>? json) {
    final unlockPriceValue = asT<num>(json, 'unlockPrice');
    return BottomTabModel(
      id: asT<String>(json, 'id'),
      name: asT<String>(json, 'name'),
      icon: asT<String>(json, 'icon'),
      unselectedIcon: asT<String>(json, 'unselectIcon'),
      content: asT<String>(json, 'content'),
      number: asT<int>(json, 'number'),
      openType: asT<String>(json, 'openType'),
      tenantId: asT<String>(json, 'tenantId'),
      unlockPrice: unlockPriceValue,
      auth: asT<bool>(json, 'auth'),
      lock: unlockPriceValue > 0,
    );
  }

  @override
  String toString() {
    return 'BottomTabModel{id: $id, name: $name, icon: $icon, unselectedIcon: $unselectedIcon, content: $content, number: $number, openType: $openType, tenantId: $tenantId, lock: $lock, auth: $auth, unlockPrice: $unlockPrice}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'unselectedIcon': unselectedIcon,
        'content': content,
        'number': number,
        'openType': openType,
        'tenantId': tenantId,
        'unlockPrice': unlockPrice,
      };
}

enum TabAction { app, inside, external }

extension TabActionExtension on TabAction {
  String get value {
    switch (this) {
      /// 打开内部页面
      case TabAction.app:
        return '1';

      /// 内部浏览器打开
      case TabAction.inside:
        return '2';

      /// 外部浏览器打开
      case TabAction.external:
        return '3';
    }
  }
}
