
import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/widgets/HeaderWidget.dart';
import 'package:flutter_video_community/modules/content/video/video_list_1col_item.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:get/get.dart';

//视频布局  1列的样式
class VideoList1Col extends StatelessWidget {
  const VideoList1Col({super.key, required this.tabData, this.header, required this.onTapVideo});


  final SliverPadding? header;
  final TabModel tabData;
  static const double padding = 15;
  final ValueChanged<ClassifyContentModel> onTapVideo;

  @override
  Widget build(BuildContext context) {
    List<TabModel>? children = tabData.childrenList; //二级分类
    if (children.isEmpty) {
      children.add(tabData);
    }

    List<Widget> slivers = [];
    for(var item in children)   {
      if (item.dataList.isEmpty) {
        continue;
      }
      slivers.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: HeaderWidget(
          title: item.name,
          more: true,
          onTap: () {
            Get.toNamed(
              AppRouter.workMore,
              parameters: {'title': '更多视频', 'catId': item.id, 'type' : 'video'},
            );
          },
        ),
      ));
      for(var video in item.dataList) {
        slivers.add(Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: GestureDetector(
                onTap: () => onTapVideo(video),
                child: VideoList1ColItem(video: video))));
      }

    }
    return CustomScrollView(
      slivers: [
        if (header != null) header!,
        SliverList(
            delegate: SliverChildListDelegate([
              ...slivers
            ])
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: padding,)
        )
      ],
    );
  }
}
