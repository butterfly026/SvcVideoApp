import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/global/app_const.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/section.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'share_page_controller.dart';

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<StatefulWidget> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final _controller = Get.put(SharePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
        key: _controller.rootWidgetKey,
        child: Stack(
          children: [
            RHExtendedImage.asset(Images.imgSplash.assetName),
            Container(
              height: Dimens.gap_dp10 * 20,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x00FFFFFF),
                    Color(0xFFFFFFFF),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: Dimens.gap_dp1 * 190),
              color: Theme.of(context).colorScheme.surface,
            ),
            Column(
              children: [
                CustomAppBar(
                  title: const Text('分享推广'),
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: Dimens.gap_dp1 * 288,
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppTheme.margin,
                          ),
                          child: Stack(
                            children: [
                              RHExtendedImage.asset(
                                Images.imgBgShareQrcode.assetName,
                                width: double.infinity,
                                height: Dimens.gap_dp1 * 288,
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: Dimens.gap_dp50,
                                  ).copyWith(top: Dimens.gap_dp50),
                                  child: RHExtendedImage.asset(
                                    Images.imgDashLine.assetName,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: Dimens.gap_dp50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '最大的乱伦平台',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Dimens.font_sp14,
                                        fontFamily: 'PingFang SC',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: Dimens.gap_dp20),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '累计邀请 ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: Dimens.font_sp14,
                                              fontFamily: 'PingFang SC',
                                            ),
                                          ),
                                          TextSpan(
                                            text: '5人',
                                            style: TextStyle(
                                              color: const Color(0xFFF9552A),
                                              fontSize: Dimens.font_sp14,
                                              fontFamily: 'PingFang SC',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: Dimens.gap_dp1 * 120,
                                    height: Dimens.gap_dp1 * 120,
                                    margin: EdgeInsets.symmetric(
                                      vertical: Dimens.gap_dp10,
                                    ),
                                    alignment: Alignment.center,
                                    child: Obx(
                                          () {
                                        return QrImageView(
                                          data: _controller.qrCodeContent.value,
                                          version: QrVersions.auto,
                                          size: Dimens.gap_dp10 * 12,
                                          padding: EdgeInsets.all(Dimens.gap_dp6),
                                          backgroundColor: Colors.white,
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: Dimens.gap_dp10),
                                    child: Obx(
                                          () {
                                        return RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '我的推广码 ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: Dimens.font_sp14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                '${_controller.userInfo.value?.inviteCode}',
                                                style: TextStyle(
                                                  color: const Color(0xFFF9552A),
                                                  fontSize: Dimens.font_sp14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    
                        /// 保存图片、复制链接
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: Dimens.gap_dp50,
                          ).copyWith(
                            top: Dimens.gap_dp12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GradientButton(
                                  text: '保存图片',
                                  height: Dimens.gap_dp48,
                                  onTap: () {
                                    _controller.capturePng();
                                  },
                                ),
                              ),
                              Gaps.hGap14,
                              Expanded(
                                child: GradientButton(
                                  text: '复制推广链接',
                                  height: Dimens.gap_dp48,
                                  onTap: () {
                                    var text =
                                        "${Cache.getInstance().appConfig?.shareContent} ${Cache.getInstance().appConfig?.shareUrl}";
                                    Clipboard.setData(ClipboardData(text: text));
                                    showToast('链接复制成功');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    
                        Container(
                          margin: EdgeInsets.only(
                            top: Dimens.gap_dp20,
                          ),
                          child: const SectionWidget(
                            title: '规则说明',
                          ),
                        ),
                    
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: Dimens.gap_dp30,
                          ),
                          child: HtmlWidget(
                            Cache.getInstance().appConfig?.sharePageContent ?? '',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                            child: RHExtendedImage.asset(Images.imgShareSocial.assetName)),
                      ],
                    ),
                  ),
                )
              
              ],
            ),
          ],
        ),
      ),
    );
  }
}
