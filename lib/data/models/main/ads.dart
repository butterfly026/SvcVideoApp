import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_video_community/utils/safe_convert.dart';

class AdsRsp {
  AdsRsp({
    this.first,
    this.second,
    this.homeBanner,
    this.homeVideoBanner,
    this.homePopup,
    this.hotBanner,
    this.hotApp,
    this.hotRecommendApp,
    this.crackBanner,
    this.crackApp,
    this.mineBanner1,
    this.mineBanner2,
    this.videoPlayAds,
    this.videoPlayContentAds,
    this.videoPlayApp,
    this.gameBanner,
    this.videoLiveBanner,
    this.mineApp,
    this.cartoonBanner,
    this.floatingBanner,
    this.newUserActivityDialogBanner,
    this.mineFloatingBanner,
    this.homeFloatingBanner,
    this.hotFloatingBanner,
    this.gameFloatingBanner,
    this.liveFloatingBanner,
    this.cartoonFloatingBanner,
    this.novelFloatingBanner,
    this.communityFloatingBanner,
    this.crackFloatingBanner,
    this.aiUndressFloatingBanner,
    this.tvFloatingBanner,
  });

  List<AdsModel> get hotBannerList => hotBanner ?? [];

  List<AdsModel> get hotApps => hotApp ?? [];

  List<AdsModel> get hotRecommendApps => hotRecommendApp ?? [];

  /// 破解模块轮播
  List<AdsModel> get crackBannerList => crackBanner ?? [];

  /// 破解模块app
  List<AdsModel> get crackApps => crackApp ?? [];

  /// 首页轮播列表
  List<AdsModel> get homeBannerList => homeBanner ?? [];

  /// 首页视频轮播列表
  List<AdsModel> get homeVideoBannerList => homeVideoBanner ?? [];

  List<AdsModel> get homePopupList => homePopup ?? [];

  List<AdsModel> get mineBanner1List => mineBanner1 ?? [];

  List<AdsModel> get mineBanner2List => mineBanner2 ?? [];

  /// 视频播放前广告
  AdsModel? get videoPlayAdsValue =>
      (null == videoPlayAds || videoPlayAds!.isEmpty)
          ? null
          : videoPlayAds![Random().nextInt(videoPlayAds!.length)];

  /// 播放页横幅
  List<AdsModel> get videoPlayContentAdsList => videoPlayContentAds ?? [];

  /// 播放页图标
  List<AdsModel> get videoPlayAppList => videoPlayApp ?? [];

  /// 游戏页轮播
  List<AdsModel> get gameBannerList => gameBanner ?? [];

  /// 视频直播轮播
  List<AdsModel> get videoLiveBannerList => videoLiveBanner ?? [];

  List<AdsModel> get mineAppList => mineApp ?? [];

  List<AdsModel> get cartoonBannerList => cartoonBanner ?? [];

  AdsModel? get floatingBannerValue =>
      (null == floatingBanner || floatingBanner!.isEmpty)
          ? null
          : floatingBanner![Random().nextInt(floatingBanner!.length)];

  /// 新人活动弹窗背景
  AdsModel? get newUserActivityDialogBannerValue =>
      (null == newUserActivityDialogBanner ||
              newUserActivityDialogBanner!.isEmpty)
          ? null
          : newUserActivityDialogBanner![
              Random().nextInt(newUserActivityDialogBanner!.length)];

  AdsModel? get mineFloatingBannerValue =>
      (null == mineFloatingBanner || mineFloatingBanner!.isEmpty)
          ? null
          : mineFloatingBanner![Random().nextInt(mineFloatingBanner!.length)];

  AdsModel? get homeFloatingBannerValue =>
      (null == homeFloatingBanner || homeFloatingBanner!.isEmpty)
          ? null
          : homeFloatingBanner![Random().nextInt(homeFloatingBanner!.length)];

  AdsModel? get hotFloatingBannerValue =>
      (null == hotFloatingBanner || hotFloatingBanner!.isEmpty)
          ? null
          : hotFloatingBanner![Random().nextInt(hotFloatingBanner!.length)];

  AdsModel? get gameFloatingBannerValue =>
      (null == gameFloatingBanner || gameFloatingBanner!.isEmpty)
          ? null
          : gameFloatingBanner![Random().nextInt(gameFloatingBanner!.length)];

  AdsModel? get liveFloatingBannerValue =>
      (null == liveFloatingBanner || liveFloatingBanner!.isEmpty)
          ? null
          : liveFloatingBanner![Random().nextInt(liveFloatingBanner!.length)];

  AdsModel? get cartoonFloatingBannerValue => (null == cartoonFloatingBanner ||
          cartoonFloatingBanner!.isEmpty)
      ? null
      : cartoonFloatingBanner![Random().nextInt(cartoonFloatingBanner!.length)];

  AdsModel? get novelFloatingBannerValue =>
      (null == novelFloatingBanner || novelFloatingBanner!.isEmpty)
          ? null
          : novelFloatingBanner![Random().nextInt(novelFloatingBanner!.length)];

  AdsModel? get communityFloatingBannerValue =>
      (null == communityFloatingBanner || communityFloatingBanner!.isEmpty)
          ? null
          : communityFloatingBanner![
              Random().nextInt(communityFloatingBanner!.length)];

  AdsModel? get crackFloatingBannerValue =>
      (null == crackFloatingBanner || crackFloatingBanner!.isEmpty)
          ? null
          : crackFloatingBanner![Random().nextInt(crackFloatingBanner!.length)];

  AdsModel? get aiUndressFloatingBannerValue =>
      (null == aiUndressFloatingBanner || aiUndressFloatingBanner!.isEmpty)
          ? null
          : aiUndressFloatingBanner![
              Random().nextInt(aiUndressFloatingBanner!.length)];

  AdsModel? get tvFloatingBannerValue =>
      (null == tvFloatingBanner || tvFloatingBanner!.isEmpty)
          ? null
          : tvFloatingBanner![Random().nextInt(tvFloatingBanner!.length)];

  factory AdsRsp.fromJson(Map<String, dynamic>? json) {
    final List<AdsModel> adsList1 = [];
    final List<AdsModel> adsList2 = [];

    final List<AdsModel> homeBannerList = [];
    final List<AdsModel> homeVideoBannerList = [];
    final List<AdsModel> homePopupList = [];

    final List<AdsModel> hotBannerList = [];
    final List<AdsModel> hotAppList = [];
    final List<AdsModel> hotRecommendAppList = [];

    final List<AdsModel> crackBannerList = [];
    final List<AdsModel> crackAppList = [];

    final List<AdsModel> mineBanner1List = [];
    final List<AdsModel> mineBanner2List = [];

    final List<AdsModel> videoPlayAdsList = [];
    final List<AdsModel> videoPlayContentAdsList = [];
    final List<AdsModel> videoPlayAppList = [];

    final List<AdsModel> gameBannerList = [];

    final List<AdsModel> videoLiveBannerList = [];

    final List<AdsModel> mineAppList = [];

    final List<AdsModel> cartoonBannerList = [];

    final List<AdsModel> floatingBannerList = [];

    final List<AdsModel> mineFloatingBannerList = [];
    final List<AdsModel> homeFloatingBannerList = [];
    final List<AdsModel> hotFloatingBannerList = [];
    final List<AdsModel> gameFloatingBannerList = [];
    final List<AdsModel> liveFloatingBannerList = [];
    final List<AdsModel> cartoonFloatingBannerList = [];
    final List<AdsModel> novelFloatingBannerList = [];
    final List<AdsModel> communityFloatingBannerList = [];
    final List<AdsModel> crackFloatingBannerList = [];
    final List<AdsModel> aiUndressFloatingBannerList = [];
    final List<AdsModel> tvFloatingBannerList = [];

    final List<AdsModel> newUserActivityDialogBannerList = [];

    if (null == json) {
      return AdsRsp(
        first: adsList1,
        second: adsList2,
      );
    }

    if (json['1'] is List) {
      for (final item in json['1']) {
        adsList1.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['2'] is List) {
      for (final item in json['2']) {
        adsList2.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['3'] is List) {
      for (final item in json['3']) {
        homeBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['4'] is List) {
      for (final item in json['4']) {
        homeVideoBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['5'] is List) {
      for (final item in json['5']) {
        floatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['6'] is List) {
      for (final item in json['6']) {
        newUserActivityDialogBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['7'] is List) {
      for (final item in json['7']) {
        hotBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['8'] is List) {
      for (final item in json['8']) {
        hotAppList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['9'] is List) {
      for (final item in json['9']) {
        hotRecommendAppList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['10'] is List) {
      for (final item in json['10']) {
        crackAppList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['11'] is List) {
      for (final item in json['11']) {
        crackBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['12'] is List) {
      for (final item in json['12']) {
        videoPlayAdsList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['13'] is List) {
      for (final item in json['13']) {
        videoPlayContentAdsList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['14'] is List) {
      for (final item in json['14']) {
        videoPlayAppList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['15'] is List) {
      for (final item in json['15']) {
        videoLiveBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['17'] is List) {
      for (final item in json['17']) {
        gameBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['18'] is List) {
      for (final item in json['18']) {
        mineAppList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['19'] is List) {
      for (final item in json['19']) {
        mineBanner1List.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['20'] is List) {
      for (final item in json['20']) {
        mineBanner2List.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['21'] is List) {
      for (final item in json['21']) {
        cartoonBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['mine'] is List) {
      for (final item in json['mine']) {
        mineFloatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['home'] is List) {
      for (final item in json['home']) {
        homeFloatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['hot'] is List) {
      for (final item in json['hot']) {
        hotFloatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['game'] is List) {
      for (final item in json['game']) {
        gameFloatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['live'] is List) {
      for (final item in json['live']) {
        liveFloatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['cartoon'] is List) {
      for (final item in json['cartoon']) {
        cartoonFloatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['novel'] is List) {
      for (final item in json['novel']) {
        novelFloatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['community'] is List) {
      for (final item in json['community']) {
        communityFloatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['crack'] is List) {
      for (final item in json['crack']) {
        crackFloatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['aiUndress'] is List) {
      for (final item in json['aiUndress']) {
        aiUndressFloatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['tv'] is List) {
      for (final item in json['tv']) {
        tvFloatingBannerList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    if (json['homePopupAd'] is List) {
      for (final item in json['homePopupAd']) {
        homePopupList.add(
          AdsModel.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    return AdsRsp(
      first: adsList1,
      second: adsList2,
      homeBanner: homeBannerList,
      homeVideoBanner: homeVideoBannerList,
      homePopup: homePopupList,
      hotBanner: hotBannerList,
      hotApp: hotAppList,
      hotRecommendApp: hotRecommendAppList,
      crackBanner: crackBannerList,
      crackApp: crackAppList,
      mineBanner1: mineBanner1List,
      mineBanner2: mineBanner2List,
      videoPlayAds: videoPlayAdsList,
      videoPlayContentAds: videoPlayContentAdsList,
      videoPlayApp: videoPlayAppList,
      gameBanner: gameBannerList,
      videoLiveBanner: videoLiveBannerList,
      mineApp: mineAppList,
      cartoonBanner: cartoonBannerList,
      floatingBanner: floatingBannerList,
      newUserActivityDialogBanner: newUserActivityDialogBannerList,
      mineFloatingBanner: mineFloatingBannerList,
      homeFloatingBanner: homeFloatingBannerList,
      hotFloatingBanner: hotFloatingBannerList,
      gameFloatingBanner: gameFloatingBannerList,
      liveFloatingBanner: liveFloatingBannerList,
      cartoonFloatingBanner: cartoonFloatingBannerList,
      novelFloatingBanner: novelFloatingBannerList,
      communityFloatingBanner: communityFloatingBannerList,
      crackFloatingBanner: crackFloatingBannerList,
      aiUndressFloatingBanner: aiUndressFloatingBannerList,
      tvFloatingBanner: tvFloatingBannerList,
    );
  }

  List<AdsModel>? first = [];
  List<AdsModel>? second = [];
  List<AdsModel>? homeBanner = [];
  List<AdsModel>? homeVideoBanner = [];
  List<AdsModel>? homePopup = [];
  List<AdsModel>? hotBanner = [];
  List<AdsModel>? hotApp = [];
  List<AdsModel>? hotRecommendApp = [];
  List<AdsModel>? crackBanner = [];
  List<AdsModel>? crackApp = [];
  List<AdsModel>? mineBanner1 = [];
  List<AdsModel>? mineBanner2 = [];
  List<AdsModel>? videoPlayAds = [];
  List<AdsModel>? videoPlayContentAds = [];
  List<AdsModel>? videoPlayApp = [];
  List<AdsModel>? gameBanner = [];
  List<AdsModel>? videoLiveBanner = [];
  List<AdsModel>? mineApp = [];
  List<AdsModel>? cartoonBanner = [];
  List<AdsModel>? floatingBanner = [];
  List<AdsModel>? newUserActivityDialogBanner = [];
  List<AdsModel>? mineFloatingBanner = [];
  List<AdsModel>? homeFloatingBanner = [];
  List<AdsModel>? hotFloatingBanner = [];
  List<AdsModel>? gameFloatingBanner = [];
  List<AdsModel>? liveFloatingBanner = [];
  List<AdsModel>? cartoonFloatingBanner = [];
  List<AdsModel>? novelFloatingBanner = [];
  List<AdsModel>? communityFloatingBanner = [];
  List<AdsModel>? crackFloatingBanner = [];
  List<AdsModel>? aiUndressFloatingBanner = [];
  List<AdsModel>? tvFloatingBanner = [];
}

class AdsModel {
  final String id;
  final String name;
  final String url;
  final String type;
  final String openWay;
  final String pic;
  final String open;
  final String tenantId;
  final String appId;
  final int number;
  final bool adv;
  final String packageName;
  String direction;
  final bool isAdv;
  final String logo;
  final String resourceUrl;
  final String vip;

  bool get gridView => direction == 'grid_view';

  AdsModel({
    this.id = '',
    this.name = '',
    this.url = '',
    this.type = '',
    this.openWay = '',
    this.pic = '',
    this.open = '',
    this.tenantId = '',
    this.appId = '',
    this.number = 0,
    this.adv = false,
    this.packageName = '',
    this.direction = 'grid_view',
    this.isAdv = false,
    this.logo = '',
    this.resourceUrl = '',
    this.vip = '',
  });

  bool get isVip => vip == 'Y';

  factory AdsModel.fromJson(Map<String, dynamic>? json) {
    bool isAdv = asT<bool>(json, 'isAdv');
    return AdsModel(
      id: asT<String>(json, 'id'),
      name: asT<String>(json, 'name'),
      url: !isAdv ? asT<String>(json, 'resourceUrl') : asT<String>(json, 'url'),
      type: asT<String>(json, 'type'),
      openWay: asT<String>(json, 'openWay'),
      pic: !isAdv ? asT<String>(json, 'logo') : asT<String>(json, 'pic'),
      open: asT<String>(json, 'open'),
      tenantId: asT<String>(json, 'tenantId'),
      appId: asT<String>(json, 'appId'),
      number: asT<int>(json, 'number'),
      adv: asT<bool>(json, 'adv'),
      packageName: asT<String>(json, 'code'),
      isAdv: asT<bool>(json, 'isAdv'),
      logo: asT<String>(json, 'logo'),
      resourceUrl: asT<String>(json, 'resourceUrl'),
      vip: asT<String>(json, 'vip'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'type': type,
        'openWay': openWay,
        'pic': pic,
        'open': open,
        'tenantId': tenantId,
        'appId': appId,
        'number': number,
        'adv': adv,
        'code': packageName,
        'isAdv': isAdv,
        'logo': logo,
        'resourceUrl': resourceUrl,
        'vip': vip,
      };
}
