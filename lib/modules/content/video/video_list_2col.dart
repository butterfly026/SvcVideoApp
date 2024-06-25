
import 'package:flutter/material.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/widgets/HeaderWidget.dart';
import 'package:flutter_video_community/modules/content/video/video_list_1col_item.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:get/get.dart';

import 'video_list_2col_item.dart';

//视频布局  2列的样式

class VideoList2Col extends StatelessWidget {
  const VideoList2Col({super.key, required this.tabData, this.header, required this.onTapVideo});


  final SliverPadding? header;
  final TabModel tabData;
  final ValueChanged<ClassifyContentModel> onTapVideo;

  static const double padding = 15;


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
      ClassifyContentModel bannerVideo = item.dataList.first;
      slivers.add(SliverList(delegate: SliverChildListDelegate([
        Padding(
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
        ),
          Padding(padding: const EdgeInsets.all(padding),
              child: GestureDetector(
                  child: VideoList1ColItem(video: bannerVideo),
                  onTap: () => onTapVideo(bannerVideo),
              ))

      ]),));
      List tempList = item.dataList.sublist(1);
      if (tempList.isEmpty) {
        continue;
      }
      slivers.add(SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            mainAxisSpacing: padding,
            crossAxisSpacing: padding,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final itemData = tempList[index];
            return GestureDetector(
              onTap: () => onTapVideo(itemData),
              child: VideoList2ColItem(
                video: itemData,
              ),
            );
          }, childCount: tempList.length),
        ),
      ));
    }

    return CustomScrollView(
      slivers: [
        if (header != null) header!,
        ...slivers,
        const SliverToBoxAdapter(
            child: SizedBox(height: padding,)
        )
      ],
    );
  }
}
