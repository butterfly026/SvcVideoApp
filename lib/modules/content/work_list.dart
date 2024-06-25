import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/global/enum/classify.dart';
import 'package:flutter_video_community/global/widgets/HeaderWidget.dart';
import 'package:flutter_video_community/global/widgets/empty_refresh_view.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/global/widgets/video_list_item.dart';
import 'package:flutter_video_community/modules/content/work_list_logic.dart';
import 'package:flutter_video_community/modules/main/widgets/announcement_widget.dart';
import 'package:flutter_video_community/modules/main/widgets/work_cat_list_item.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/banner.dart';
import 'package:get/get.dart';

class WorkList extends StatefulWidget {
  const WorkList({
    super.key,
    required this.catId,
    required this.type,
  });

  final String catId;
  final String type;

  @override
  State<StatefulWidget> createState() => WorkListState();
}

class WorkListState extends State<WorkList> {
  late WorkListLogic logic;
  static const double padding = 15;

  @override
  void initState() {
    super.initState();
    if (AppTool.isNotEmpty(widget.catId) && AppTool.isNotEmpty(widget.type)) {
      logic = Get.put(WorkListLogic(), tag: widget.catId);
      logic.init(widget.catId, widget.type);
    }
  }

  @override
  Widget build(BuildContext context) {
    String moreTxt = ContentEnum.novel.type == widget.type ? '小说' : '漫画';
    String type = widget.type;
    return Obx(() {
      List<ClassifyContentModel> dataList = logic.dataList;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: EasyRefresh(
          onRefresh: () async {
            logic.loadData();
          },
          onLoad: () async {
            logic.loadMore();
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(dPadding),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  if (logic.adsList.isNotEmpty)
                    CustomBanner(
                      list: logic.adsList,
                      onTap: (index) {},
                    ),

                  /// 公告
                  if (logic.announcement.value.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: dPadding),
                      child: AnnouncementWidget(
                        text: logic.announcement.value,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: HeaderWidget(
                      title: moreTxt,
                      more: true,
                      onTap: () {
                        Get.toNamed(
                          AppRouter.workMore,
                          parameters: {
                            'title': '更多',
                            'catId': logic.catId,
                            'type': type
                          },
                        );
                      },
                    ),
                  ),
                ])),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: padding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    mainAxisSpacing: dPadding,
                    crossAxisSpacing: dPadding,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final itemData = dataList[index];
                    return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRouter.workDetail,
                            parameters: {
                              'id': itemData.id,
                              'type': itemData.type
                            },
                          );
                        },
                        child: WorkCatItemWidget(
                          data: itemData,
                        ));
                  }, childCount: dataList.length),
                ),
              )
            ],
          ),
        ),
        // body: Column(
        //   children: [
        //     /// banner
        //     if (logic.adsList.isNotEmpty)
        //       Container(
        //         margin: const EdgeInsets.symmetric(
        //           horizontal: AppTheme.margin,
        //         ).copyWith(bottom: Dimens.gap_dp12),
        //         child: CustomBanner(
        //           list: logic.adsList,
        //           onTap: (index) {},
        //         ),
        //       ),
        //
        //     /// 公告
        //     if (logic.announcement.value.isNotEmpty)
        //       AnnouncementWidget(
        //         text: logic.announcement.value,
        //       ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: dPadding).copyWith(top: dPadding),
        //       child: HeaderWidget(
        //         title: moreTxt,
        //         more: true,
        //         onTap: () {
        //           Get.toNamed(
        //             AppRouter.workMore,
        //             parameters: {'title': '更多', 'catId': logic.catId, 'type' : type},
        //           );
        //         },
        //       ),
        //     ),
        //     Expanded(
        //       child: logic.dataList.isEmpty ?  EmptyRefreshView(onRefresh: (){
        //         logic.loadData();
        //
        //         // Get.toNamed(
        //         //   AppRouter.liveRoom,
        //         //   parameters: {'url' : 'dsa'},
        //         // );
        //       },) : EasyRefresh(
        //         onRefresh: () async {
        //           logic.loadData();
        //         },
        //         onLoad: () async {
        //           logic.loadMore();
        //         },
        //         child: GridView.builder(
        //           padding: const EdgeInsets.all(
        //             dPadding,
        //           ),
        //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //             crossAxisCount: 2,
        //             childAspectRatio: 0.72,
        //             crossAxisSpacing: dPadding,
        //             mainAxisSpacing: dPadding,
        //           ),
        //           itemCount: logic.dataList.length,
        //           itemBuilder: (context, index) {
        //             final itemData = logic.dataList[index];
        //             return GestureDetector(
        //               onTap: () {
        //                 Get.toNamed(
        //                   AppRouter.workDetail,
        //                   parameters: {'id': itemData.id, 'type': itemData.type},
        //
        //                 );
        //               },
        //               child: WorkCatItemWidget(
        //                 data: itemData,
        //               ),
        //             );
        //           },
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      );
    });
  }
}
