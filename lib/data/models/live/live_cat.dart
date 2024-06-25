// To parse this JSON data, do
//
//     final liveCatModel = liveCatModelFromJson(jsonString);

import 'dart:convert';

LiveCatModel liveCatModelFromJson(String str) => LiveCatModel.fromJson(json.decode(str));

String liveCatModelToJson(LiveCatModel data) => json.encode(data.toJson());

class LiveCatModel {
  final String id;
  final String address;
  final String url;
  final String img;
  final dynamic number;
  final String title;
  final String open;
  final String openWay;

  LiveCatModel({
    required this.id,
    required this.address,
    required this.url,
    required this.img,
    required this.number,
    required this.title,
    required this.open,
    required this.openWay,
  });

  factory LiveCatModel.fromJson(Map<String, dynamic> json) => LiveCatModel(
    id: json["id"],
    address: json["address"],
    url: json["url"],
    img: json["img"],
    number: json["number"],
    title: json["title"],
    open: json["open"],
    openWay: json["openWay"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "url": url,
    "img": img,
    "number": number,
    "title": title,
    "open": open,
    "openWay": openWay,
  };
}
