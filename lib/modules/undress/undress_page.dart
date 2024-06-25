import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/button/draggable.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

import 'undress_page_controller.dart';

/// 一键脱衣
class UndressPage extends StatefulWidget {
  const UndressPage({
    super.key,
    this.second = true,
  });

  final bool second;

  @override
  State<StatefulWidget> createState() => _UndressPageState();
}

class _UndressPageState extends State<UndressPage> {
  final _controller = Get.put(UndressPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.second
          ? Theme.of(context).colorScheme.surface
          : Colors.transparent,
      body: Stack(
        children: [
          if (widget.second)
            Align(
              alignment: Alignment.topCenter,
              child: RHExtendedImage.asset(
                Images.imgBgHeader.assetName,
                width: double.infinity,
                height: Dimens.gap_dp1 * 375,
                fit: BoxFit.fill,
              ),
            ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                widget.second
                    ? CustomAppBar(
                        title: const Text('一键脱衣'),
                        backgroundColor: Colors.transparent,
                        systemOverlayStyle: const SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarIconBrightness: Brightness.dark,
                        ),
                      )
                    : CustomAppBar(
                        title: const Text('一键脱衣1'),
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                      ),
                Container(
                  height: Dimens.gap_dp44,
                  color: const Color(0xFFFFF1E5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.margin,
                  ),
                  child: Row(
                    children: [
                      RHExtendedImage.asset(
                        Images.iconOfficialTips.assetName,
                        width: Dimens.gap_dp24,
                        height: Dimens.gap_dp24,
                      ),
                      Gaps.hGap12,
                      const Expanded(
                        child: Text(
                          '处理一张照片的费用是 99 钻石',
                          style: TextStyle(
                            color: Color(0xFFFA6520),
                            fontSize: 12,
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// upload
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppTheme.margin,
                  ).copyWith(
                    top: Dimens.gap_dp12,
                  ),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(Dimens.gap_dp8),
                    dashPattern: const [6, 3],
                    color: const Color(0xFFFF7A01),
                    child: Container(
                      width: double.infinity,
                      height: Dimens.gap_dp10 * 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F6),
                        borderRadius: BorderRadius.circular(Dimens.gap_dp8),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            child: GestureDetector(
                              onTap: () {
                                /// upload image
                                _controller.pickAsset(context);
                              },
                              child: Obx(() {
                                final imageUrl = _controller.imageUrl.value;
                                if (imageUrl.isNotEmpty) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RHExtendedImage.network(
                                        imageUrl,
                                        height: Dimens.gap_dp10 * 14,
                                      ),
                                    ],
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.all(Dimens.gap_dp10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RHExtendedImage.asset(
                                        Images.iconUploadImage.assetName,
                                        width: Dimens.gap_dp32,
                                        height: Dimens.gap_dp32,
                                      ),
                                      Text(
                                        '点击上传图片',
                                        style: TextStyle(
                                          color: const Color(0xFF191D26),
                                          fontSize: Dimens.font_sp16,
                                          fontFamily: 'PingFang SC',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// 生成记录、提交
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppTheme.margin,
                  ).copyWith(
                    top: Dimens.gap_dp12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          text: '生成记录',
                          width: double.infinity,
                          height: Dimens.gap_dp48,
                          grey: true,
                          onTap: () {
                            Get.toNamed(AppRouter.undressRecord);
                          },
                        ),
                      ),
                      Gaps.hGap12,
                      Expanded(
                        child: GradientButton(
                          text: '提交',
                          width: double.infinity,
                          height: Dimens.gap_dp48,
                          onTap: () {
                            _controller.submit(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        /// 注意事项
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: Dimens.gap_dp26,
                          ).copyWith(
                            top: Dimens.gap_dp18,
                          ),
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '注意事项：\n',
                                  style: TextStyle(
                                    color: const Color(0xFF626773),
                                    fontSize: Dimens.font_sp14,
                                    fontFamily: 'PingFang SC',
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: '1、每次只可上传一张包含一名人物的图片\n',
                                  style: TextStyle(
                                    color: const Color(0xFF626773),
                                    fontSize: Dimens.font_sp14,
                                    fontFamily: 'PingFang SC',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '2、图片应尽量清晰、光线明亮，人物正面照、无遮挡\n',
                                  style: TextStyle(
                                    color: const Color(0xFF626773),
                                    fontSize: Dimens.font_sp14,
                                    fontFamily: 'PingFang SC',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '3、不支持多人图、禁止未成年人图 (否则封号处理)',
                                  style: TextStyle(
                                    color: const Color(0xFF626773),
                                    fontSize: Dimens.font_sp14,
                                    fontFamily: 'PingFang SC',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppTheme.margin,
                          ).copyWith(
                            top: Dimens.gap_dp18,
                          ),
                          child: RHExtendedImage.asset(
                            Images.imgUndressExample.assetName,
                            width: double.infinity,
                            height: Dimens.gap_dp10 * 24,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () {
              final aiUndressFloatingBanner =
                  _controller.adsRsp.value?.aiUndressFloatingBannerValue;
              if (null == aiUndressFloatingBanner) {
                return Gaps.empty;
              }
              return DraggableButton(data: aiUndressFloatingBanner);
            },
          ),
        ],
      ),
    );
  }
}
