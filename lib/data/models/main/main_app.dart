import 'package:flutter_video_community/utils/safe_convert.dart';

class MainAppModel {
  final String id; //appId
  final String name;
  final String logo;
  final String open;
  final String bottomIcon;
  final String bottomUrl;
  final String bottomImg;
  final String layout;
  final String dominantColor;
  final String secondaryColor;
  final String classifyColor;
  final String classifyBgColor;
  final String headers;
  final String vip;
  final String bgImg;
  final String type;
  final int number;
  int freeTime;

  MainAppModel({
    this.id = '',
    this.name = '',
    this.logo = '',

    /// 开关（0正常 1停用）
    this.open = '',

    /// 按钮icon
    this.bottomIcon = '',

    /// 按钮url
    this.bottomUrl = '',

    /// 按钮图片
    this.bottomImg = '',

    /// 版式
    this.layout = '',

    /// 主色
    this.dominantColor = '',

    /// 副色
    this.secondaryColor = '',

    /// 分类色
    this.classifyColor = '',

    /// 分类背景色
    this.classifyBgColor = '',
    this.headers = '',

    /// 是否VIP(N否 Y是)
    this.vip = '',
    this.bgImg = '',
    this.type = '',
    this.number = 0,

    /// 免费时间
    this.freeTime = 0,
  });

  factory MainAppModel.fromJson(Map<String, dynamic>? json) {
    return MainAppModel(
      id: asT<String>(json, 'id'),
      name: asT<String>(json, 'name'),
      logo: asT<String>(json, 'logo'),
      open: asT<String>(json, 'open'),
      bottomIcon: asT<String>(json, 'bottomIcon'),
      bottomUrl: asT<String>(json, 'bottomUrl'),
      bottomImg: asT<String>(json, 'bottomImg'),
      layout: asT<String>(json, 'layout'),
      dominantColor: asT<String>(json, 'dominantColor'),
      secondaryColor: asT<String>(json, 'secondaryColor'),
      classifyColor: asT<String>(json, 'classifyColor'),
      classifyBgColor: asT<String>(json, 'classifyBgColor'),
      headers: asT<String>(json, 'headers'),
      vip: asT<String>(json, 'vip'),
      bgImg: asT<String>(json, 'bgImg'),
      type: asT<String>(json, 'type'),
      number: asT<int>(json, 'number'),
      freeTime: asT<int>(json, 'freeTime'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logo': logo,
        'open': open,
        'bottomIcon': bottomIcon,
        'bottomUrl': bottomUrl,
        'bottomImg': bottomImg,
        'layout': layout,
        'dominantColor': dominantColor,
        'secondaryColor': secondaryColor,
        'classifyColor': classifyColor,
        'classifyBgColor': classifyBgColor,
        'headers': headers,
        'vip': vip,
        'bgImg': bgImg,
        'type': type,
        'number': number,
        'freeTime': freeTime,
      };
}
