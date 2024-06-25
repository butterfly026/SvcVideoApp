import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/modules/main/mine/widgets/pay/pay_controller.dart';
import 'package:flutter_video_community/utils/cache_util.dart';
import 'package:flutter_video_community/utils/umeng_util.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import 'pay_list_item.dart';

class PayDialog extends StatefulWidget {
  const PayDialog({super.key});

  static Future<void> show(BuildContext context) async {
    SmartDialog.show(
      tag: 'pay',
      builder: (_) {
        return const PayDialog();
      },
      alignment: Alignment.center,
      backDismiss: false,
      clickMaskDismiss: false,
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'pay');
  }

  @override
  State<StatefulWidget> createState() => _PayDialogState();
}

class _PayDialogState extends State<PayDialog> {
  @override
  Widget build(BuildContext context) {
    final payController = PayController.to;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: Dimens.gap_dp48,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: Dimens.gap_dp36,
                  child: RHExtendedImage.asset(
                    Images.imgBgAccountCredentialsHeader.assetName,
                    width: double.infinity,
                    height: Dimens.gap_dp36,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: Dimens.gap_dp20),
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
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  // height: Dimens.gap_dp10 * 380,
                  margin: EdgeInsets.only(top: Dimens.gap_dp30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(Dimens.gap_dp8),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '请选择支付方式',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimens.font_sp18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.vGap10,
                      Text(
                        '禁止修改金额、重复支付、超时支付',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimens.font_sp14,
                          color: const Color(0xFFD66D00),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: Dimens.gap_dp10 * 20,
                          maxHeight: Dimens.gap_dp10 * 22,
                        ),
                        child: GetBuilder<PayController>(
                          init: payController,
                          builder: (controller) {
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimens.gap_dp10,
                              ),
                              itemCount: controller.filterPayChannelList.length,
                              itemBuilder: (context, index) {
                                final itemData =
                                    controller.filterPayChannelList[index];
                                return PayListItem(data: itemData);
                              },
                            );
                          },
                        ),
                      ),
                      GradientButton(
                        text: '立即支付',
                        width: double.infinity,
                        height: Dimens.gap_dp46,
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimens.gap_dp20,
                        ).copyWith(bottom: Dimens.gap_dp16),
                        onTap: () {
                          UmengUtil.upPoint(PayController.payType, {
                            'name': UMengEvent.payBtn,
                            'desc': '立即支付按钮点击',
                          });
                          CacheUtil.setNeedUpdateUserInfo(true);
                          payController.startPay(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gaps.vGap12,
          GestureDetector(
            onTap: () {
              PayDialog.dismiss();
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
  }
}
