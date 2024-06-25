// To parse this JSON data, do
//
//     final undressRecordModel = undressRecordModelFromJson(jsonString);

import 'dart:convert';

UndressRecordModel undressRecordModelFromJson(String str) => UndressRecordModel.fromJson(json.decode(str));

String undressRecordModelToJson(UndressRecordModel data) => json.encode(data.toJson());

class UndressRecordModel {
  String id;
  String userId;
  String userName;
  String taskId;
  String taskStatus;
  String startTime;
  String endTime;
  dynamic result;
  String original;

  UndressRecordModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.taskId,
    required this.taskStatus,
    required this.startTime,
    required this.endTime,
    required this.result,
    required this.original,
  });

  factory UndressRecordModel.fromJson(Map<String, dynamic> json) => UndressRecordModel(
    id: json["id"] ?? '',
    userId: json["userId"] ?? '',
    userName: json["userName"] ?? '',
    taskId: json["taskId"] ?? '',
    taskStatus: json["taskStatus"],
    startTime: json["startTime"] ?? '',
    endTime: json["endTime"] ?? '',
    result: json["result"] ,
    original: json["original"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "userName": userName,
    "taskId": taskId,
    "taskStatus": taskStatus,
    "startTime": startTime,
    "endTime": endTime,
    "result": result,
    "original": original,
  };
}
