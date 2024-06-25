// To parse this JSON data, do
//
//     final favorCatModel = favorCatModelFromJson(jsonString);

import 'dart:convert';

FavorItemModel favorItemModelFromJson(String str) => FavorItemModel.fromJson(json.decode(str));

String favorItemModelToJson(FavorItemModel data) => json.encode(data.toJson());

class FavorItemModel {
  final String collectId;
  final String userId;
  final String contentId;
  final String contentTitle;
  final String contentImageUrl;
  final String contentType;
  bool checked = false;


  FavorItemModel({
    this.collectId = '',
    this.userId = '',
    this.contentId = '',
    this.contentTitle = '',
    this.contentImageUrl = '',
    this.contentType = '',
  });

  factory FavorItemModel.fromJson(Map<String, dynamic> json) => FavorItemModel(
    collectId: json["collectId"],
    userId: json["userId"],
    contentId: json["contentId"],
    contentTitle: json["contentTitle"],
    contentImageUrl: json["contentImageUrl"],
    contentType: json["contentType"],
  );

  Map<String, dynamic> toJson() => {
    "icollectIdd": collectId,
    "userId": userId,
    "contentId": contentId,
    "contentTitle": contentTitle,
    "contentImageUrl": contentImageUrl,
    "contentType": contentType,
  };
}
