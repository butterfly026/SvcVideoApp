import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/modules/content/more/work_more_controller.dart';
import 'package:flutter_video_community/modules/content/video/video_list_2col_item.dart';
import 'package:flutter_video_community/modules/main/widgets/work_cat_list_item.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

import 'work_search_logic.dart';

/// 作品搜索页
class WorkSearchPage extends StatefulWidget {
  const WorkSearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _WorkSearchPageState();
}

class _WorkSearchPageState extends State<WorkSearchPage> {
  late WorkSearchLogic _logic;
  String? type;
  String? keyword;
  bool showVid2Col = false; //是否展示视频2列的yangshi
  static const double padding = 15;

  @override
  void initState() {
    super.initState();
    keyword = Get.parameters['keyword'];
    type = Get.parameters['type'];
    if (AppTool.isNotEmpty(type) && 'video' == type) {
      showVid2Col = true;
    }
    _logic = Get.put(WorkSearchLogic());

    if (AppTool.isNotEmpty(keyword) && AppTool.isNotEmpty(type)) {
      _logic.init(type!, keyword!);
      _logic.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<ClassifyContentModel> dataList = _logic.dataList;
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
                  title: Text('搜索结果'),
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                ),
                Expanded(
                    child: dataList.isNotEmpty ? EasyRefresh(
                      onRefresh: () async {
                        _logic.loadData();
                      },
                      onLoad: () async {
                        _logic.loadMore();
                      },
                      child: _buildContentStyle(dataList),
                    ) : const EmptyView()
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildContentStyle(List<ClassifyContentModel> dataList) {
    Widget workStyle = GridView.builder(
      itemCount: dataList.length,
      padding: const EdgeInsets.symmetric(
          horizontal: dPadding,
          vertical: dPadding
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        mainAxisSpacing: dPadding,
        crossAxisSpacing: dPadding,
      ),
      itemBuilder: (context, index) {
        final item = dataList[index];
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
      itemCount: dataList.length,
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
        final item = dataList[index];
        return GestureDetector(
          onTap: () {
            Get.toNamed(AppRouter.videoPlayer, parameters: {"id": item.id});
          },
          child: VideoList2ColItem(video: item),
        );
      },
    );
    return showVid2Col ? videoStyle : workStyle;
  }
}
