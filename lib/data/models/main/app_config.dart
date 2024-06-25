import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_video_community/data/models/update.dart';
import 'package:flutter_video_community/utils/safe_convert.dart';

class AppConfigModel {
  final String id;
  final String tenantId;
  final String androidUrl;
  final String iosUrl;
  final String version;
  final String toUpdate;
  final String announcement;
  final String acOpen;
  final String updateContent;
  final String customerService;
  final String customerOpenWay;
  final String buyHide;
  final String appAdvType;
  final String apkPackageName;
  final String apkSignature;
  final String rollAnnouncement;
  final int undressPrice;
  final String shareUrl;
  final String shareContent;
  final String sharePageContent;
  List<AppActivityModel>? appActivityList;

  AppConfigModel({
    this.id = '',
    this.tenantId = '',
    this.androidUrl = '',
    this.iosUrl = '',
    this.version = '',

    /// 更新(N 否Y 是)
    this.toUpdate = '',

    /// 公告
    this.announcement = '',

    /// 公告开关(0正常 1停用)
    this.acOpen = '',
    this.updateContent = '',

    /// 客服URL
    this.customerService = '',

    /// 客服打开方式（1打开页面 2内置浏览器打开 3外置浏览器打开）
    this.customerOpenWay = '',

    /// 充值隐藏（N否 Y是）
    this.buyHide = '',

    /// 应用所处广告分类
    this.appAdvType = '',
    this.apkPackageName = '',
    this.apkSignature = '',

    /// 滚动公告
    this.rollAnnouncement = '',

    /// 脱衣价格
    this.undressPrice = 0,
    this.shareUrl = '',
    this.shareContent = '',
    this.sharePageContent = '',
    this.appActivityList,
  });

  /// 是否需要版本更新
  bool get needUpdate => toUpdate == 'Y';

  /// 是否需要展示公告
  bool get needShowAc => acOpen == '0';

  UpdateModel get updateInfo => UpdateModel(
        content: updateContent,
        downloadUrl: Platform.isIOS ? iosUrl : androidUrl,
      );

  factory AppConfigModel.fromJson(Map<String, dynamic>? json) {
    List<AppActivityModel> rules = [];
    if (null != json && null != json['appActivityList']) {
      for (final item in json['appActivityList']) {
        rules.add(
          AppActivityModel.fromJson(
            item as Map<String, dynamic>,
          ),
        );
      }
    }
    return AppConfigModel(
      id: asT<String>(json, 'id'),
      tenantId: asT<String>(json, 'tenantId'),
      androidUrl: asT<String>(json, 'androidUrl'),
      iosUrl: asT<String>(json, 'iosUrl'),
      version: asT<String>(json, 'version'),
      toUpdate: asT<String>(json, 'toUpdate'),
      announcement: asT<String>(json, 'announcement'),
      acOpen: asT<String>(json, 'acOpen'),
      updateContent: asT<String>(json, 'updateContent'),
      customerService: asT<String>(json, 'customerService'),
      customerOpenWay: asT<String>(json, 'customerOpenWay'),
      buyHide: asT<String>(json, 'buyHide'),
      appAdvType: asT<String>(json, 'appAdvType'),
      apkPackageName: asT<String>(json, 'apkPackageName'),
      apkSignature: asT<String>(json, 'apkSignature'),
      rollAnnouncement: asT<String>(json, 'rollAnnouncement'),
      undressPrice: asT<int>(json, 'undressPrice'),
      shareUrl: asT<String>(json, 'shareUrl'),
      shareContent: asT<String>(json, 'shareContent'),
      sharePageContent: asT<String>(json, 'sharePageContent'),
      appActivityList: rules,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tenantId': tenantId,
        'androidUrl': androidUrl,
        'iosUrl': iosUrl,
        'version': version,
        'toUpdate': toUpdate,
        'announcement': announcement,
        'acOpen': acOpen,
        'updateContent': updateContent,
        'customerService': customerService,
        'customerOpenWay': customerOpenWay,
        'buyHide': buyHide,
        'appAdvType': appAdvType,
        'apkPackageName': apkPackageName,
        'apkSignature': apkSignature,
        'rollAnnouncement': rollAnnouncement,
        'undressPrice': undressPrice,
        'shareUrl': shareUrl,
        'shareContent': shareContent,
        'sharePageContent': sharePageContent,
      };
}

class AppActivityModel {
  const AppActivityModel({
    this.activityId = '',
    this.showType = '',
    this.rechargeActivity = '',
    this.rechargeType = '',
    this.posit = '',
    this.pic = '',
    this.openWay = '',
    this.url = '',
    this.number = 0,
    this.open = '',
    this.content = '',
    this.rule = '',
    this.rules,
  });

  factory AppActivityModel.fromJson(Map<String, dynamic>? json) {
    List<ActivityRule> ruleList = [];
    if (null != json && null != json['rule']) {
      final rules = jsonDecode(json['rule'] as String) as List;
      debugPrint('ruleJson ========> $rules');
      for (final item in rules) {
        ruleList.add(
          ActivityRule.fromJson(
            item as Map<String, dynamic>,
          ),
        );
      }
    }
    return AppActivityModel(
      activityId: asT<String>(json, 'activityId'),
      showType: asT<String>(json, 'showType'),
      rechargeActivity: asT<String>(json, 'rechargeActivity'),
      rechargeType: asT<String>(json, 'rechargeType'),
      posit: asT<String>(json, 'posit'),
      pic: asT<String>(json, 'pic'),
      openWay: asT<String>(json, 'openWay'),
      url: asT<String>(json, 'url'),
      open: asT<String>(json, 'open'),
      content: asT<String>(json, 'content'),
      rule: asT<String>(json, 'rule'),
      number: asT<int>(json, 'number'),
      rules: ruleList,
    );
  }

  final String activityId;
  final String showType;
  final String rechargeActivity;
  final String rechargeType;
  final String posit;
  final String pic;
  final String openWay;
  final String url;
  final int number;
  final String open;
  final String content;
  final String rule;
  final List<ActivityRule>? rules;
}

class ActivityRule {
  const ActivityRule({
    this.rechargePackageId = '',
    this.rechargePackageType = '',
    this.price = 0,
    this.ratio = 0,
  });

  factory ActivityRule.fromJson(Map<String, dynamic>? json) {
    return ActivityRule(
      rechargePackageId: asT<String>(json, 'rechargePackageId'),
      rechargePackageType: asT<String>(json, 'rechargePackageType'),
      price: asT<num>(json, 'price'),
      ratio: asT<num>(json, 'price'),
    );
  }

  final String rechargePackageId;
  final String rechargePackageType;
  final num price;
  final num ratio;
}

class AppIconModel {
  const AppIconModel({
    this.name = '',
    this.title = '',
    this.icon = '',
  });

  factory AppIconModel.fromJson(Map<String, dynamic>? json) {
    List<ActivityRule> ruleList = [];
    if (null != json && null != json['rule']) {
      final rules = jsonDecode(json['rule'] as String) as List;
      debugPrint('ruleJson ========> $rules');
      for (final item in rules) {
        ruleList.add(
          ActivityRule.fromJson(
            item as Map<String, dynamic>,
          ),
        );
      }
    }
    return AppIconModel(
      name: asT<String>(json, 'name'),
      icon: asT<String>(json, 'icon'),
      title: asT<String>(json, 'title'),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'icon': icon,
        'title': title,
      };
  final String name;
  final String icon;
  final String title;
}
