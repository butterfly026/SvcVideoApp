import 'package:flutter_video_community/utils/safe_convert.dart';

//对应getSocAttendantInfo的response
class CommunityModel {
  CommunityModel({
    this.id = '',
    this.title = '',
    this.content = '',
    this.pic = '',
    this.area = '',
    this.areaCode = '',
    this.type = '',
    this.name = '',
    this.sex = '',
    this.age = '',
    this.open = '',
    this.packagePrice = '',
    this.contact = '',
    this.serviceItems = '',
    this.situation = '',
    this.price = 0.0,
    this.height = 0,
    this.auth = false,
    this.haveCollect = false,
  });

  String get ageValue => age.isEmpty ? '0岁' : '$age岁';
  String get heightValue => '${height}cm';

  factory CommunityModel.fromJson(Map<String, dynamic>? json) {
    return CommunityModel(
      id: asT<String>(json, 'id'),
      title: asT<String>(json, 'title'),
      content: asT<String>(json, 'content'),
      pic: asT<String>(json, 'pic'),
      area: asT<String>(json, 'area'),
      areaCode: asT<String>(json, 'areaCode'),
      type: asT<String>(json, 'type'),
      name: asT<String>(json, 'name'),
      sex: asT<String>(json, 'sex'),
      age: asT<String>(json, 'age'),
      open: asT<String>(json, 'open'),
      packagePrice: asT<String>(json, 'packagePrice'),
      contact: asT<String>(json, 'contact'),
      serviceItems: asT<String>(json, 'serviceItems'),
      situation: asT<String>(json, 'situation'),
      price: asT<num>(json, 'price'),
      height: asT<int>(json, 'height'),
      auth: asT<bool>(json, 'auth'),
      haveCollect: asT<bool>(json, 'haveCollect'),
    );
  }

  String id;
  String title;
  String content;
  String pic;
  String area;
  String areaCode;
  String type;
  String name;
  String sex;
  String age;
  String open;
  String packagePrice;
  String contact;
  String serviceItems;
  String situation;
  num price;
  int height;
  bool auth;
  bool haveCollect;
}
