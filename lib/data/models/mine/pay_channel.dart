import 'package:flutter_video_community/utils/safe_convert.dart';

class PayChannelModel {
  final String id;
  final String tenantId;
  final String name;
  final String type;
  final String icon;
  final String jumpType;
  final String minPrice;
  final String maxPrice;
  final String code;
  final String open;
  final String processorClass;
  final String content;
  bool selected;

  num get minPriceValue => minPrice.isEmpty ? 0.0 : num.parse(minPrice);

  num get maxPriceValue => maxPrice.isEmpty ? 0.0 : num.parse(maxPrice);

  PayChannelModel({
    this.id = '',
    this.tenantId = '',
    this.name = '',
    this.type = '',
    this.icon = '',
    this.jumpType = '',
    this.minPrice = '',
    this.maxPrice = '',
    this.code = '',
    this.open = '',
    this.processorClass = '',
    this.content = '',
    this.selected = false,
  });

  factory PayChannelModel.fromJson(Map<String, dynamic>? json) {
    return PayChannelModel(
      id: asT<String>(json, 'id'),
      tenantId: asT<String>(json, 'tenantId'),
      name: asT<String>(json, 'name'),
      type: asT<String>(json, 'busType'),
      icon: asT<String>(json, 'icon'),
      jumpType: asT<String>(json, 'jumpType'),
      minPrice: asT<String>(json, 'minPrice'),
      maxPrice: asT<String>(json, 'maxPrice'),
      code: asT<String>(json, 'code'),
      open: asT<String>(json, 'open'),
      processorClass: asT<String>(json, 'processorClass'),
      content: asT<String>(json, 'content'),
      selected: asT<bool>(json, 'selected'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tenantId': tenantId,
        'name': name,
        'busType': type,
        'icon': icon,
        'jumpType': jumpType,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'code': code,
        'open': open,
        'processorClass': processorClass,
        'content': content,
        'selected': selected,
      };
}
