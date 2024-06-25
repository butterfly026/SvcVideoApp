// To parse this JSON data, do
//
//     final liveAnchorModel = liveAnchorModelFromJson(jsonString);

import 'dart:convert';

LiveAnchorModel liveAnchorModelFromJson(String str) => LiveAnchorModel.fromJson(json.decode(str));

String liveAnchorModelToJson(LiveAnchorModel data) => json.encode(data.toJson());

class LiveAnchorModel {
  final String id;
  final String address;
  final String img;
  final String title;
  final String open;
  final String classifyId;
  final dynamic number;
  final String source;

  LiveAnchorModel({
    this.id = "",
    this.address = "" ,
    this.img = "",
    this.title = "",
    this.open = "",
    this.classifyId = "",
    this.number = 0,
    this.source = "",
  });

  factory LiveAnchorModel.fromJson(Map<String, dynamic> json) => LiveAnchorModel(
    id: json["id"],
    address: json["address"],
    img: json["img"],
    title: json["title"],
    open: json["open"],
    classifyId: json["classifyId"],
    number: json["number"],
    source: json["source"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "img": img,
    "title": title,
    "open": open,
    "classifyId": classifyId,
    "number": number,
    "source": source,
  };
}
