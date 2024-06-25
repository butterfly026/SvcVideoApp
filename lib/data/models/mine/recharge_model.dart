import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/utils/safe_convert.dart';

class RechargeModel {
  final String id;
  final String tenantId;
  final String name;
  final String type;
  final String introduction;
  final String donation;
  final String pic;
  final String tag;
  final int amount;
  final String originalPrice;
  final String presentPrice;
  final String newComerPrice;
  final int number;
  bool selected;

  num get presentPriceValue =>
      presentPrice.isEmpty ? 0.0 : num.parse(presentPrice);

  num getPrice() {
    final newUserEquityTime = GlobalController.to.newUserEquityTime.value;
    if (newUserEquityTime > 0) {
      return newComerPrice.isEmpty ? 0.0 : num.parse(newComerPrice);
    } else {
      return presentPrice.isEmpty ? 0.0 : num.parse(presentPrice);
    }
  }

  RechargeModel({
    this.id = '',
    this.tenantId = '',
    this.name = '',
    this.type = '',
    this.introduction = '',
    this.donation = '',
    this.pic = '',
    this.tag = '',
    this.amount = 0,
    this.originalPrice = '',
    this.presentPrice = '',
    this.newComerPrice = '',
    this.number = 0,
    this.selected = false,
  });

  factory RechargeModel.fromJson(Map<String, dynamic>? json) {
    return RechargeModel(
      id: asT<String>(json, 'id'),
      tenantId: asT<String>(json, 'tenantId'),
      name: asT<String>(json, 'name'),
      type: asT<String>(json, 'type'),
      introduction: asT<String>(json, 'introduction'),
      donation: asT<String>(json, 'donation'),
      pic: asT<String>(json, 'pic'),
      tag: asT<String>(json, 'tag'),
      amount: asT<int>(json, 'amount'),
      originalPrice: asT<String>(json, 'originalPrice'),
      presentPrice: asT<String>(json, 'presentPrice'),
      newComerPrice: asT<String>(json, 'newComerPrice'),
      number: asT<int>(json, 'number'),
      selected: asT<bool>(json, 'selected'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tenantId': tenantId,
        'name': name,
        'type': type,
        'introduction': introduction,
        'donation': donation,
        'pic': pic,
        'tag': tag,
        'amount': amount,
        'originalPrice': originalPrice,
        'presentPrice': presentPrice,
        'newComerPrice': newComerPrice,
        'number': number,
        'selected': selected,
      };
}
