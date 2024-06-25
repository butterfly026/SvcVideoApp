import 'package:flutter_video_community/utils/safe_convert.dart';

class IpModel {
  IpModel({
    this.ip = '',
    this.city = '',
    this.country = '',
    this.region = '',
    this.regionId = '',
    this.cityId = '',
    this.ispId = '',
    this.isp = '',
  });

  factory IpModel.fromJson(Map<String, dynamic>? json) {
    return IpModel(
      ip: asT<String>(json, 'ip'),
      city: asT<String>(json, 'city'),
      country: asT<String>(json, 'country'),
      region: asT<String>(json, 'region'),
      regionId: asT<String>(json, 'region_id'),
      cityId: asT<String>(json, 'city_id'),
      ispId: asT<String>(json, 'isp_id'),
      isp: asT<String>(json, 'isp'),
    );
  }

  String ip;
  String city;
  String country;
  String region;
  String regionId;
  String cityId;
  String ispId;
  String isp;
}
