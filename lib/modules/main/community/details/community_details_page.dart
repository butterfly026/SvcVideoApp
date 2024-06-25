import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/event/purchase_occurred_event.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/modules/main/community/details/community_details_controller.dart';
import 'package:flutter_video_community/modules/main/community/widgets/official_tips_widget.dart';
import 'package:flutter_video_community/modules/main/community/widgets/post_banner_widget.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class CommunityDetailsPage extends StatefulWidget {
  const CommunityDetailsPage({super.key});

  @override
  State<StatefulWidget> createState() => _CommunityDetailsPageState();
}

class _CommunityDetailsPageState extends State<CommunityDetailsPage>
    with RouteAware {
  final _controller = Get.put(
    CommunityDetailsController(),
  );
  String? detailId;

  late final StreamSubscription purchaseOccurredSubscription;
  @override
  void initState() {
    super.initState();
    purchaseOccurredSubscription = eventBus.on<PurchaseOccurredEvent>().listen((event) {
      _controller.refreshDefaultDetail();
    });
  }

  @override
  void dispose() {
    AppRouter.routeObservers.unsubscribe(this);
    purchaseOccurredSubscription.cancel();
    super.dispose();
  }
  //
  // @override
  // void didPopNext() {
  //   debugPrint("CommunityDetailsPage---didPopNext");
  //   //其他页面被pop之后跳转到此页面
  //   _controller.refreshDefaultDetail();
  //   super.didPopNext();
  // }

  @override
  void didPush() {
    //别的页面跳转到此页时
    detailId = Get.parameters['id'];
    if (AppTool.isNotEmpty(detailId)) { //社区详情id
      _controller.refreshData(detailId!);
    }
    super.didPush();
  }

  @override
  void didChangeDependencies() {
    AppRouter.routeObservers.subscribe(
      this,
      ModalRoute.of(context)!,
    );
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as CommunityDetailArg;
    //bool auth = _controller.details.value?.auth ?? false;

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
                title: const Text('楼凤信息'),
                backgroundColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const OfficialTipsWidget(
                        text: '',
                      ),
                      Obx(() {
                        final bannerList = _controller.bannerList;
                        if (bannerList.isEmpty) {
                          return Gaps.empty;
                        }
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppTheme.margin,
                          ).copyWith(top: Dimens.gap_dp16),
                          child: PostBannerWidget(
                            list: bannerList,
                          ),
                        );
                      },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppTheme.margin,
                        ).copyWith(top: Dimens.gap_dp16),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .surface,
                          borderRadius: BorderRadius.circular(Dimens.gap_dp10),
                        ),
                        padding: EdgeInsets.all(Dimens.gap_dp10),
                        child: Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _controller.details.value?.title ?? '',
                                      style: TextStyle(
                                        fontSize: Dimens.font_sp14,
                                        color: const Color(0xFF191D26),
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '2023-12-14',
                                    style: TextStyle(
                                      fontSize: Dimens.font_sp12,
                                      color: const Color(0xFF626773),
                                    ),
                                  ),
                                ],
                              ),
                              Gaps.vGap10,
                              ReadMoreText(
                                _controller.details.value?.content ?? '',
                                trimLines: 2,
                                colorClickableText: const Color(0xFFFF0000),
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '查看更多',
                                trimExpandedText: '点击收起',
                                style: TextStyle(
                                  height: 1.8,
                                  fontSize: Dimens.font_sp12,
                                  color: const Color(0xFF626773),
                                ),
                                moreStyle: TextStyle(
                                  fontSize: Dimens.font_sp12,
                                  color: const Color(0xFFFF0000),
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppTheme.margin,
                        ).copyWith(top: Dimens.gap_dp16),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .surface,
                          borderRadius: BorderRadius.circular(Dimens.gap_dp10),
                        ),
                        padding: EdgeInsets.all(Dimens.gap_dp10),
                        child: Obx(() {
                          final details = _controller.details.value;
                          final value =
                              '性别：${details?.sex} 年龄：${details
                              ?.ageValue} 身高：${details?.heightValue}';
                          return Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '价格：',
                                      style: TextStyle(
                                        fontSize: Dimens.font_sp12,
                                        color: const Color(0xFF626773),
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${details?.situation}',
                                      style: TextStyle(
                                        fontSize: Dimens.font_sp12,
                                        color: const Color(0xFFF9552A),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '详情：',
                                      style: TextStyle(
                                        fontSize: Dimens.font_sp12,
                                        color: const Color(0xFF626773),
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: value,
                                      style: TextStyle(
                                        fontSize: Dimens.font_sp12,
                                        color: const Color(0xFFF9552A),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      Obx(() {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppTheme.margin,
                          ).copyWith(top: Dimens.gap_dp16),
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .surface,
                            borderRadius: BorderRadius.circular(
                                Dimens.gap_dp10),
                          ),
                          padding: EdgeInsets.only(
                            left: Dimens.gap_dp10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '联系方式：  ${(_controller.details.value
                                      ?.auth ?? false)
                                      ? _controller.details.value!.contact
                                      : "*********************"}',
                                  style: TextStyle(
                                    fontSize: Dimens.font_sp12,
                                    color: const Color(0xFF626773),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // 复制联系方式
                                  if ((_controller.details.value
                                      ?.auth ?? false)) {
                                    _controller.copy();
                                  } else {
                                    _controller.unlock();
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.gap_dp10,
                                    vertical: Dimens.gap_dp12,
                                  ),
                                  child: Text(
                                    '复制',
                                    style: TextStyle(
                                      fontSize: Dimens.font_sp12,
                                      color: const Color(0xFFF9552A),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Obx(() {
                bool favored = _controller.details.value?.haveCollect ?? false;

                return Container(
                  height: Dimens.gap_dp56,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppTheme.margin,
                  ).copyWith(bottom: Dimens.gap_dp20),
                  child: Row(
                    children: [
                      Gaps.hGap10,
                      GestureDetector(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // RHExtendedImage.asset(
                            //   collected ? Images.iconCollectionFilled.assetName : Images.iconCollection.assetName,
                            //   width: Dimens.gap_dp24,
                            //   height: Dimens.gap_dp24,
                            //   color: const Color(0xFF965100),
                            // ),
                            Icon(
                              favored ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: const Color(0xFF965100),
                              size: Dimens.gap_dp32,
                            ),
                            Text(
                              favored ? '已经收藏' : '加入收藏',
                              style: TextStyle(
                                fontSize: Dimens.font_sp14,
                                color: const Color(0xFF965100),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          _controller.favorOrNot();
                        },
                      ),
                      Gaps.hGap20,
                      Expanded(
                        child: GradientButton(
                          text: '解锁',
                          width: double.infinity,
                          height: double.infinity,
                          onTap: (_controller.details.value?.auth ?? false)
                              ? null
                              : () {
                            _controller.unlock();
                          },
                          grey: _controller.details.value?.auth ?? false,
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}
