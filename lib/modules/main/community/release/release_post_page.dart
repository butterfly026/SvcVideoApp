import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/input.dart';
import 'package:get/get.dart';

import 'release_post_controller.dart';

/// 发布楼凤信息
class ReleasePostPage extends StatefulWidget {
  const ReleasePostPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReleasePostPageState();
}

class _ReleasePostPageState extends State<ReleasePostPage> {
  final _controller = Get.put(ReleasePostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              title: Text(
                '发布楼凤信息',
                style: TextStyle(
                  fontSize: Dimens.font_sp16,
                ),
              ),
              backgroundColor: Colors.transparent,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
            body: Theme(
              data: AppTheme.light().copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  isCollapsed: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimens.gap_dp20,
                    vertical: Dimens.gap_dp4,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.margin,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              height: Dimens.gap_dp40,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '发布内容',
                                style: TextStyle(
                                  color: const Color(0xFF191D26),
                                  fontSize: Dimens.font_sp16,
                                ),
                              ),
                            ),
                            Container(
                              height: Dimens.gap_dp52,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    BorderRadius.circular(Dimens.gap_dp4),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimens.gap_dp12,
                              ),
                              child: CustomInputNormal(
                                controller: _controller.titleEditingController,
                                style: TextStyle(
                                  fontSize: Dimens.font_sp14,
                                  color: const Color(0xFF191D26),
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.font_sp14,
                                ),
                                hintText: '请输入标题内容',
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Container(
                              height: Dimens.gap_dp80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    BorderRadius.circular(Dimens.gap_dp4),
                              ),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(top: Dimens.gap_dp10),
                              padding: EdgeInsets.symmetric(
                                vertical: Dimens.gap_dp12,
                                horizontal: Dimens.gap_dp12,
                              ),
                              child: CustomInputNormal(
                                controller:
                                    _controller.contentEditingController,
                                style: TextStyle(
                                  fontSize: Dimens.font_sp14,
                                  color: const Color(0xFF191D26),
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.font_sp14,
                                ),
                                hintText: '添加描述',
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Container(
                              height: Dimens.gap_dp40,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: Dimens.gap_dp10),
                              child: Text(
                                '详细信息',
                                style: TextStyle(
                                  color: const Color(0xFF191D26),
                                  fontSize: Dimens.font_sp16,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    BorderRadius.circular(Dimens.gap_dp4),
                              ),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(top: Dimens.gap_dp10),
                              padding: EdgeInsets.symmetric(
                                vertical: Dimens.gap_dp12,
                                horizontal: Dimens.gap_dp12,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _controller.showCityPicker(context);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          '所在地区：',
                                          style: TextStyle(
                                            fontSize: Dimens.font_sp14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: Dimens.gap_dp34,
                                            alignment: Alignment.centerLeft,
                                            child: Obx(
                                              () {
                                                final cityResult = _controller
                                                    .cityResult.value;
                                                TextStyle style = TextStyle(
                                                  fontSize: Dimens.font_sp14,
                                                  color: Colors.grey,
                                                );
                                                if (null != cityResult) {
                                                  style = TextStyle(
                                                    fontSize: Dimens.font_sp14,
                                                    color:
                                                        const Color(0xFF191D26),
                                                  );
                                                }
                                                return Text(
                                                  null == cityResult
                                                      ? '选择省市区'
                                                      : '${cityResult.provinceName}-${cityResult.cityName}-${cityResult.areaName}',
                                                  style: style,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimens.gap_dp34,
                                    child: Row(
                                      children: [
                                        Text(
                                          '服务项目：',
                                          style: TextStyle(
                                            fontSize: Dimens.font_sp14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomInputNormal(
                                            controller: _controller
                                                .serviceItemsEditingController,
                                            style: TextStyle(
                                              fontSize: Dimens.font_sp14,
                                              color: const Color(0xFF191D26),
                                            ),
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: Dimens.font_sp14,
                                            ),
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimens.gap_dp34,
                                    child: Row(
                                      children: [
                                        Text(
                                          '消费情况：',
                                          style: TextStyle(
                                            fontSize: Dimens.font_sp14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomInputNormal(
                                            controller: _controller
                                                .situationEditingController,
                                            style: TextStyle(
                                              fontSize: Dimens.font_sp14,
                                              color: const Color(0xFF191D26),
                                            ),
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: Dimens.font_sp14,
                                            ),
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: Dimens.gap_dp40,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: Dimens.gap_dp10),
                              child: Text(
                                '解锁价格（钻石）',
                                style: TextStyle(
                                  color: const Color(0xFF191D26),
                                  fontSize: Dimens.font_sp16,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                /// todo 设置价格区间
                              },
                              child: Container(
                                height: Dimens.gap_dp52,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius:
                                      BorderRadius.circular(Dimens.gap_dp4),
                                ),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.gap_dp12,
                                ),
                                child: Text(
                                  '可设置价格区间',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Dimens.font_sp14,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: Dimens.gap_dp40,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: Dimens.gap_dp10),
                              child: Text(
                                '联系方式',
                                style: TextStyle(
                                  color: const Color(0xFF191D26),
                                  fontSize: Dimens.font_sp16,
                                ),
                              ),
                            ),
                            Container(
                              height: Dimens.gap_dp52,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    BorderRadius.circular(Dimens.gap_dp4),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimens.gap_dp12,
                              ),
                              child: CustomInputNormal(
                                controller:
                                    _controller.contactEditingController,
                                style: TextStyle(
                                  fontSize: Dimens.font_sp14,
                                  color: const Color(0xFF191D26),
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimens.font_sp14,
                                ),
                                hintText: '手机号/微信/QQ',
                                keyboardType: TextInputType.text,
                              ),
                            ),

                            /// 风险提示:
                            // 1、以上信息由用户自行上传发布与b无关，请自行分辨真伪。
                            // 2、未见面不付款，见面不满意请拒绝服务。平台只提供交流信息，请拒绝支付任何以平台名义的费用。
                            // 3、遇到其他问题请联系在线客服处理

                            Container(
                              margin: EdgeInsets.only(top: Dimens.gap_dp10),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '风险提示：\n',
                                      style: TextStyle(
                                        color: const Color(0xFF626773),
                                        fontSize: Dimens.font_sp14,
                                        fontFamily: 'PingFang SC',
                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '1、以上信息由用户自行上传发布与b无关，请自行分辨真伪。\n',
                                      style: TextStyle(
                                        color: const Color(0xFF626773),
                                        fontSize: Dimens.font_sp14,
                                        fontFamily: 'PingFang SC',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '2、未见面不付款，见面不满意请拒绝服务。平台只提供交流信息，请拒绝支付任何以平台名义的费用。\n',
                                      style: TextStyle(
                                        color: const Color(0xFF626773),
                                        fontSize: Dimens.font_sp14,
                                        fontFamily: 'PingFang SC',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '3、遇到其他问题请联系在线客服处理',
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
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.gap_dp12,
                      ),
                      child: GradientButton(
                        text: '立即发布',
                        height: Dimens.gap_dp56,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
