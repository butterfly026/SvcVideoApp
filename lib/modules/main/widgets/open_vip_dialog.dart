import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/modules/main/widgets/equity_time.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:flutter_video_community/widgets/countdown/countdown.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

class OpenVipDialog extends StatefulWidget {
  const OpenVipDialog({
    super.key,
  });

  static Future<void> show(BuildContext context) async {
    SmartDialog.show(
      tag: 'open_vip',
      builder: (_) {
        return const OpenVipDialog();
      },
      alignment: Alignment.center,
      backDismiss: true,
      clickMaskDismiss: false,
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'open_vip');
  }

  @override
  State<StatefulWidget> createState() => _OpenVipDialogState();
}

class _OpenVipDialogState extends State<OpenVipDialog> {
  AdsRsp? adsRsp;

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final newUserEquityTime = Cache.getInstance().login?.newUserEquityTime ?? 0;

    return Obx(() {
      adsRsp = GlobalController.to.adsRsp.value;
      final url = adsRsp == null ? '' : adsRsp!.homePopupList[0].pic;
      final uri = Uri.parse(url);
      final top = double.parse(uri.queryParameters['top'] ?? '0').w;
      final left = double.parse(uri.queryParameters['left'] ?? '0').w;
      final fontSize = double.parse(uri.queryParameters['fontsize'] ?? '12').sp;
      final fontColor = _colorFromHex(uri.queryParameters['fontcolor'] ?? '#333333');

      final duration = uri.queryParameters['newuser'] == '1'
          ? newUserEquityTime
          : int.parse(uri.queryParameters['duration'] ?? '0');

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimens.gap_dp20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              // height: Dimens.gap_dp1 * 370,
              child: Stack(
                children: [
                  Align(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimens.gap_dp20,
                      ),
                      child: RHExtendedImage.network(
                        url,
                        width: double.infinity,
                        // height: Dimens.gap_dp1 * 370,
                      ),
                    ),
                  ),
                  Positioned(
                    left: left,
                    top: top,
                    child: GestureDetector(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          // borderRadius: BorderRadius.circular(20.w),
                        ),
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: BlocProvider<EquityTimeCubit>(
                            create: (context) {
                              return EquityTimeCubit(
                                Duration(seconds: duration),
                              );
                            },
                            child: BlocBuilder<EquityTimeCubit, Duration>(
                              builder: (context, duration) {
                                final data = CountdownModel.parse(duration);
                                return Text(
                                  '${data.hour1}${data.hour2}:${data.minutes1}${data.minutes2}:${data.seconds1}${data.seconds2}',
                                  style: TextStyle(
                                    color: fontColor,
                                    fontSize: fontSize,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        OpenVipDialog.dismiss();
                        Get.toNamed(AppRouter.vipRecharge);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Gaps.vGap32,
            GestureDetector(
              onTap: () {
                OpenVipDialog.dismiss();
              },
              child: RHExtendedImage.asset(
                Images.iconCloseCircle.assetName,
                width: Dimens.gap_dp30,
                height: Dimens.gap_dp30,
              ),
            ),
          ],
        ),
      );
    });
  }
}
