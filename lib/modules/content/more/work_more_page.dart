import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/modules/content/more/work_more_controller.dart';
import 'package:flutter_video_community/modules/content/video/video_list_2col_item.dart';
import 'package:flutter_video_community/modules/main/widgets/work_cat_list_item.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

/// 更多小说
class WorkMorePage extends StatefulWidget {
  const WorkMorePage({super.key});

  @override
  State<StatefulWidget> createState() => _WorkMorePageState();
}

class _WorkMorePageState extends State<WorkMorePage> {
  late WorkMoreController _controller;
  String? title;
  bool showVid2Col = false;//是否展示视频2列的yangshi
  static const double padding = 15;

  @override
  void initState() {
    super.initState();
    title = Get.parameters['title'];
    String? catId = Get.parameters['catId'];
    String? type = Get.parameters['type'];
    if (AppTool.isNotEmpty(type) && 'video' == type) {
      showVid2Col = true;
    }

    if (AppTool.isNotEmpty(catId)) {
      _controller = Get.put(WorkMoreController(), tag: catId);
      _controller.catId = catId;
      _controller.init();
      _controller.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F5),
      body: Stack(
        children: [
          RHExtendedImage.asset(
            Images.imgBgHeader.assetName,
            width: double.infinity,
            height: Dimens.gap_dp1 * 375,
            fit: BoxFit.fill,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Dimens.gap_dp1 * 375,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x00FFFFFF),
                    Color(0xFFF9F5F5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Column(
            children: [
              CustomAppBar(
                title: Text(title ?? '更多'),
                backgroundColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),

              Obx(() {
                return _controller.dataList.isNotEmpty ? Expanded(
                    child: EasyRefresh(
                      onRefresh: () async {
                        _controller.loadData();
                      },
                      onLoad: () async {
                        _controller.loadMore();
                      },
                      child: _buildContentStyle(),
                    )
                ): const EmptyView();
              })
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentStyle() {
    Widget workStyle = GridView.builder(
      itemCount: _controller.dataList.length,
      padding: const EdgeInsets.symmetric(
          horizontal: dPadding,
          vertical: dPadding
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        mainAxisSpacing: dPadding,
        crossAxisSpacing: dPadding,
      ),
      itemBuilder: (context, index) {
        final item = _controller.dataList[index];
        return GestureDetector(
          onTap: () {
            Get.toNamed(
              AppRouter.workDetail,
              parameters: {'id': item.id, 'type': item.type},
            );
          },
          child: WorkCatItemWidget(data: item),
        );
      },
    );
    Widget videoStyle = GridView.builder(
      itemCount: _controller.dataList.length,
      padding: const EdgeInsets.symmetric(
          horizontal: dPadding,
          vertical: dPadding
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        mainAxisSpacing: padding,
        crossAxisSpacing: padding,
      ),
      itemBuilder: (context, index) {
        final item = _controller.dataList[index];
        return GestureDetector(
          onTap: () {
            Get.toNamed(AppRouter.videoPlayer, parameters: {"id": item.id});
          },
          child:VideoList2ColItem(video: item),
        );
      },
    );
    return showVid2Col ? videoStyle : workStyle;
  }
}
