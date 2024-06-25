import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/models/undress/undress_record.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'undress_record_list_logic.dart';

class UndressRecordList extends StatefulWidget {
  const UndressRecordList({super.key, required this.taskStatus});

  final int taskStatus;

  @override
  State<UndressRecordList> createState() => _UndressRecordListState();
}

class _UndressRecordListState extends State<UndressRecordList> {
  late UndressRecordListLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = Get.put(UndressRecordListLogic(), tag: widget.taskStatus.toString());
    _logic.init(widget.taskStatus);
    _logic.loadData();
  }

  String _getTaskStatus(String status) {
    switch(status) {
      case '1':
        return '排队中';
      case '2':
        return '已完成';
      case '3':
        return '生成失败';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<UndressRecordModel> dataList =  _logic.dataList;
      return EasyRefresh(
          onRefresh: () async {
            _logic.loadData();
          },
          onLoad: () async {
            _logic.loadMore();
          },
          child: dataList.isEmpty ? const EmptyView() : ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: dPadding,
            ),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              UndressRecordModel item = dataList[index];
              return Padding(
                padding: const EdgeInsets.all(dPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  RHExtendedImage.network(
                      item.original,
                      width: 64,
                      height: 64,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    const SizedBox(width: dPadding,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.startTime),
                        const SizedBox(height: dPadding),
                        Text(_getTaskStatus(item.taskStatus), style: const TextStyle(
                          color:  Color(0xFFF9552A)
                        ),),
                      ],
                    )
                  ],
                ),
              );
            },
          )

      );
    });;
  }
}

