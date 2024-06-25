import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/global/widgets/state_widget.dart';
import 'package:flutter_video_community/modules/main/crack/crack_page_controller.dart';
import 'package:flutter_video_community/modules/main/widgets/announcement_widget.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/banner.dart';
import 'package:flutter_video_community/widgets/button/draggable.dart';
import 'package:get/get.dart';

import 'crack_app_item.dart';

/// 破解页
class CrackPage extends StatefulWidget {
  const CrackPage({super.key});

  @override
  State<StatefulWidget> createState() => _CrackPageState();
}

class _CrackPageState extends State<CrackPage> {
  final controller = Get.put(CrackPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () {
                  final crackBannerList = controller.adsList;
                  final isEmpty = crackBannerList.isEmpty;
                  if (isEmpty) {
                    return Gaps.empty;
                  }

                  /// banner
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppTheme.margin,
                    ).copyWith(bottom: Dimens.gap_dp12),
                    child: CustomBanner(
                      list: controller.adsBannerList,
                    ),
                  );
                },
              ),

              /// 公告
              Obx(
                () {
                  if (controller.announcement.value.isEmpty) {
                    return Gaps.empty;
                  }
                  return AnnouncementWidget(
                    text: controller.announcement.value,
                  );
                },
              ),

              Expanded(
                child: Obx(
                  () {
                    return StateWidget(
                      state: controller.loadState.value,
                      child: GridView.builder(
                        itemCount: controller.adsList.length,
                        padding: EdgeInsets.all(Dimens.gap_dp12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemBuilder: (context, index) {
                          final itemData = controller.adsList[index];
                          return GestureDetector(
                            onTap: () {
                              controller.openApp(itemData);
                            },
                            child: CrackAppItemWidget(
                              data: itemData,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Obx(
            () {
              final crackFloatingBanner =
                  controller.adsRsp.value?.crackFloatingBannerValue;
              if (null == crackFloatingBanner) {
                return Gaps.empty;
              }
              return DraggableButton(data: crackFloatingBanner);
            },
          ),
        ],
      ),
    );
  }
}
