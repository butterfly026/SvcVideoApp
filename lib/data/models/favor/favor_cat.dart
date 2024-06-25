// To parse this JSON data, do
//
//     final favorCatModel = favorCatModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_video_community/utils/app_tool.dart';

FavorCatModel favorCatModelFromJson(String str) => FavorCatModel.fromJson(json.decode(str));

String favorCatModelToJson(FavorCatModel data) => json.encode(data.toJson());

class FavorCatModel {
  final String id;
  final String url;
  final String name;
  final String openWay;
  final int number;

  String getType() {
    String? type;
    if (AppTool.isNotEmpty(url)) {
      Uri u = Uri.parse(url);
      type = u.queryParameters['type'];
    }
    return type ?? '';
  }


  FavorCatModel({
    this.id = '',
    this.url = '',
    this.name = '',
    this.openWay = '',
    this.number = 0,
  });

  factory FavorCatModel.fromJson(Map<String, dynamic> json) => FavorCatModel(
    id: json["id"],
    url: json["url"],
    name: json["name"],
    openWay: json["openWay"],
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "name": name,
    "openWay": openWay,
    "number": number,
  };
}
