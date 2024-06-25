import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/models/favor/favor_item.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/modules/favor/favor_list_controller.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:get/get.dart';

import 'favor_list_item.dart';

class FavorList extends StatefulWidget {
  const FavorList({super.key, required this.type, required this.route, required this.openWay});

  final String type;
  final String route;
  final String openWay;

  @override
  State<FavorList> createState() => _FavorListState();
}

class _FavorListState extends State<FavorList> {
  late FavorListController _controller;

  @override
  void initState() {
    super.initState();
    String? type = widget.type;
    _controller = Get.put(FavorListController(), tag: type);
    if (AppTool.isNotEmpty(type)) {
      _controller.type = type;
      _controller.init();
      _controller.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<FavorItemModel> dataList =  _controller.dataList;
      return EasyRefresh(
          onRefresh: () async {
            _controller.loadData();
          },
          onLoad: () async {
            _controller.loadMore();
          },
          child: dataList.isEmpty ? const EmptyView() : GridView.builder(
              padding: const EdgeInsets.all(
                dPadding,
              ),
              itemCount: dataList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: dPadding,
                mainAxisSpacing: dPadding,
              ),
              itemBuilder: (context, index) {
                FavorItemModel favorItemModel = dataList[index];
                return GestureDetector(
                  onTap: () {
                  String route = widget.route;
                  route = '$route&id=${favorItemModel.contentId}';
                  debugPrint("route=${route}");
                  AppUtil.to(route, widget.openWay);
                },
                child: FavorListItem(favorItem: favorItemModel,));
          })

      );
    });;
  }
}

