import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/global/widgets/refresh_view.dart';
import 'package:flutter_video_community/global/widgets/video_list_item.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'video_search_controller.dart';

/// 视频搜索
class VideoSearchPage extends StatefulWidget {
  const VideoSearchPage({super.key});

  @override
  State<StatefulWidget> createState() => _VideoSearchPageState();
}

class _VideoSearchPageState extends State<VideoSearchPage> {
  late VideoSearchController searchController;
  late RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    searchController = VideoSearchController();
    Get.put(searchController);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      searchController.load(
        refreshController,
      );
    });
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
                title: Obx(() {
                  return Text(
                    searchController.searchModel.value.keywords,
                  );
                }),
                backgroundColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
              Expanded(
                child: GetBuilder<VideoSearchController>(
                  init: searchController,
                  builder: (controller) {
                    return RefreshView(
                      refreshController: refreshController,
                      loadState: controller.loadState.value,
                      onRefresh: controller.onRefresh,
                      onLoading: controller.onLoadMore,
                      onReload: () {
                        controller.load(refreshController);
                      },
                      body: GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimens.gap_dp12,
                        ),
                        itemCount: controller.dataList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: Dimens.gap_dp12,
                          crossAxisSpacing: Dimens.gap_dp12,
                        ),
                        itemBuilder: (context, index) {
                          final itemData = controller.dataList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRouter.videoPlayer,
                                arguments: itemData,
                              );
                            },
                            child: VideoListItem(cover: itemData.pic, title: itemData.title,),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
