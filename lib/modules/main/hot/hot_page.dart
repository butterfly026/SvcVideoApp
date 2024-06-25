import 'package:flutter/material.dart';
import 'package:flutter_floating/floating/floating.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/modules/main/crack/crack_page_controller.dart';
import 'package:flutter_video_community/modules/main/hot/hot_page_controller.dart';
import 'package:flutter_video_community/modules/main/main_controller.dart';
import 'package:flutter_video_community/modules/main/widgets/announcement_widget.dart';
import 'package:flutter_video_community/modules/main/widgets/app_item_widget.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/banner.dart';
import 'package:flutter_video_community/widgets/button/draggable.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:get/get.dart';

/// 热门
class HotPage extends StatefulWidget {
  const HotPage({super.key});

  @override
  State<StatefulWidget> createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> {
  final controller = Get.put(HotPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              /// banner
              Obx(
                () {
                  if (controller.hotBannerList.isEmpty) {
                    return Gaps.empty;
                  }
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppTheme.margin,
                    ).copyWith(bottom: Dimens.gap_dp12),
                    child: CustomBanner(
                      list: controller.hotBannerList,
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() {
                        if (controller.hotAppList.isEmpty) {
                          return Gaps.empty;
                        }
                        return Container(
                          constraints: BoxConstraints(
                            minHeight: Dimens.gap_dp100,
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                              top: Dimens.gap_dp12,
                              bottom: Dimens.gap_dp4,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: Dimens.gap_dp10,
                              childAspectRatio: 1.1,
                            ),
                            itemCount: controller.hotAppList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  GlobalController.to.launch(
                                    controller.hotAppList[index],
                                  );
                                },
                                child: AppItemWidget(
                                  data: controller.hotAppList[index],
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      Obx(
                        () {
                          if (controller.hotRecommendApps.isEmpty) {
                            return Gaps.empty;
                          }
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SectionWidget(title: '优质 App'),
                              Container(
                                margin: EdgeInsets.only(
                                  left: Dimens.gap_dp16,
                                  right: Dimens.gap_dp16,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: Images.imgBgHotDownloadApp,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Dimens.gap_dp10,
                                  ),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: controller.hotRecommendApps.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final data =
                                        controller.hotRecommendApps[index];
                                    return ListTile(
                                      leading: RHExtendedImage.network(
                                        data.pic,
                                        width: Dimens.gap_dp54,
                                        height: Dimens.gap_dp54,
                                        borderRadius: BorderRadius.circular(
                                          Dimens.gap_dp10,
                                        ),
                                      ),
                                      title: Text(
                                        data.name,
                                        style: TextStyle(
                                          fontSize: Dimens.font_sp1 * 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        data.name,
                                        style: TextStyle(
                                          fontSize: Dimens.font_sp13,
                                          color: Colors.black,
                                        ),
                                      ),
                                      trailing: GradientButton(
                                        text: '下载',
                                        width: Dimens.gap_dp10 * 7,
                                        height: Dimens.gap_dp30,
                                        style: TextStyle(
                                          fontSize: Dimens.gap_dp14,
                                        ),
                                        onTap: () {
                                          GlobalController.to.openApp(data);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () {
              final hotFloatingBanner =
                  controller.adsRsp.value?.hotFloatingBannerValue;
              if (null == hotFloatingBanner) {
                return Gaps.empty;
              }
              return DraggableButton(data: hotFloatingBanner);
            },
          ),
        ],
      ),
    );
  }
}
