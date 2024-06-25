import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/modules/main/mine/mine_page_controller.dart';
import 'package:flutter_video_community/modules/main/widgets/app_icon_widget.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:get/get.dart';

class AppIconsGroupWidget extends StatelessWidget {
  const AppIconsGroupWidget({super.key, required this.controller});

  final MinePageController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: Dimens.gap_dp20,
          ),
          child: const SectionWidget(
            title: '设置桌面图标',
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(
              top: Dimens.gap_dp4,
              left: Dimens.gap_dp1 * 21,
              right: Dimens.gap_dp16,
              bottom: Dimens.gap_dp16,
            ),
            constraints: BoxConstraints(
              minHeight: Dimens.gap_dp100,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(
                Dimens.gap_dp12,
              ),
            ),
            child: Obx(() {
              return GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  top: Dimens.gap_dp12,
                  bottom: Dimens.gap_dp4,
                ),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: Dimens.gap_dp10,
                  childAspectRatio: 1.1,
                ),
                itemCount: controller.appIcons.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await controller
                          .changeAppIcon(controller.appIcons[index]);
                    },
                    child: AppIconWidget(
                      data: controller.appIcons[index],
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
