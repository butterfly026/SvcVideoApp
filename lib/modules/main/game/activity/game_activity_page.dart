import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/game/game.dart';
import 'package:flutter_video_community/global/widgets/state_widget.dart';
import 'package:flutter_video_community/modules/main/game/activity/game_activity_controller.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

import 'game_activity_list_item.dart';

class GameActivityPage extends StatefulWidget {
  const GameActivityPage({super.key});

  @override
  State<StatefulWidget> createState() => _GameActivityPageState();
}

class _GameActivityPageState extends State<GameActivityPage> {
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
                title: const Text('活动'),
                backgroundColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
              Expanded(
                child: GetBuilder<GameActivityController>(
                  init: GameActivityController(),
                  builder: (controller) {
                    return StateWidget(
                      state: controller.loadState.value,
                      onReload: controller.loadData,
                      child: ListView.builder(
                        addRepaintBoundaries: false,
                        addAutomaticKeepAlives: false,
                        itemCount: controller.dataList.length,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.margin,
                        ),
                        itemBuilder: (context, index) {
                          GameActivityModel gameActivity = controller.dataList[index];
                          return GestureDetector(
                            onTap: (){
                              String route = gameActivity.url;
                              String openWay = gameActivity.openType;
                              AppUtil.to(route, openWay);
                            },
                            child: GameActivityListItem(
                              data: gameActivity,
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
        ],
      ),
    );
  }
}
