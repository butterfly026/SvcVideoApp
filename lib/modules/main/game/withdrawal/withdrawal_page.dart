import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/enum/pay.dart';
import 'package:flutter_video_community/modules/main/game/game_page_controller.dart';
import 'package:flutter_video_community/modules/main/game/withdrawal/withdrawal_page_controller.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/gradient_text.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/input.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../../../utils/umeng_util.dart';

/// 游戏提现
class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<StatefulWidget> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
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
              resizeToAvoidBottomInset: false,
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
                child: Column(
                  children: [
                    CustomAppBar(
                      title: Text(
                        '我的钱包',
                        style: TextStyle(
                          fontSize: Dimens.font_sp16,
                        ),
                      ),
                      actions: [
                        IconButton(
                          constraints: const BoxConstraints.expand(width: 100),
                          icon: Text(
                            '提现记录',
                            style: TextStyle(
                              fontSize: Dimens.font_sp16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed(AppRouter.gameWithdrawalRecord);
                          },
                        ),
                      ],
                      backgroundColor: Colors.transparent,
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarIconBrightness: Brightness.dark,
                      ),
                    ),
                    Expanded(
                      child: GetBuilder<WithdrawalPageController>(
                        init: WithdrawalPageController(),
                        builder: (controller) {
                          return Column(
                            children: [
                              Container(
                                height: Dimens.gap_dp1 * 93,
                                margin: EdgeInsets.only(
                                  left: Dimens.gap_dp16,
                                  right: Dimens.gap_dp16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFE0A9),
                                      Color(0xFFFFCE63),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      Dimens.gap_dp12,
                                    ),
                                    topRight: Radius.circular(
                                      Dimens.gap_dp12,
                                    ),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: Dimens.gap_dp16,
                                        ),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "余额",
                                                  style: TextStyle(
                                                    fontSize: Dimens.font_sp16,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                      0xFF965100,
                                                    ),
                                                  ),
                                                ),
                                                Gaps.vGap8,
                                                Text(
                                                  GamePageController
                                                      .to.gameBalance.value,
                                                  style: TextStyle(
                                                    fontSize: Dimens.font_sp20,
                                                    color: const Color(
                                                      0xFF5C3200,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    UmengUtil.upPoint(
                                                        UMengType.buttonClick, {
                                                      'name': UMengEvent
                                                          .gameRechargeBuy,
                                                      'desc': '游戏充值'
                                                    });
                                                    Get.toNamed(
                                                        AppRouter.gameDeposit);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                      right: Dimens.gap_dp20,
                                                    ),
                                                    width: Dimens.gap_dp1 * 69,
                                                    height: Dimens.gap_dp30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        Dimens.gap_dp1 * 6.93,
                                                      ),
                                                    ),
                                                    child: GradientText(
                                                      text: "充值",
                                                      gradient:
                                                          const LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          Color(0xFFFF0000),
                                                          Color(0xFFFF9900),
                                                        ],
                                                      ),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            Dimens.font_sp12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: Dimens.gap_dp1 * 37,
                                margin: EdgeInsets.only(
                                  left: Dimens.gap_dp16,
                                  right: Dimens.gap_dp16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                      Dimens.gap_dp12,
                                    ),
                                    bottomRight: Radius.circular(
                                      Dimens.gap_dp12,
                                    ),
                                  ),
                                  color: const Color(0xFFFFE9BB),
                                ),
                                child: Row(
                                  children: [
                                    Gaps.hGap16,
                                    Text(
                                      "可提现余额: ${GamePageController.to.gameBalance.value}",
                                      style:
                                          TextStyle(fontSize: Dimens.font_sp12),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "资金明细",
                                          style: TextStyle(
                                            fontSize: Dimens.font_sp12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gaps.hGap16,
                                  ],
                                ),
                              ),
                              Gaps.vGap16,
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: Dimens.gap_dp16,
                                      right: Dimens.gap_dp16,
                                    ),
                                    child: Column(
                                      children: [
                                        Gaps.vGap12,
                                        _buildSelect(
                                          context,
                                          '提现方式',
                                          controller.payTypeValue,
                                          style: null !=
                                                  controller
                                                      .currentPayType.value
                                              ? TextStyle(
                                                  color: Colors.black,
                                                  fontSize: Dimens.font_sp16,
                                                )
                                              : null,
                                          onTap: () {
                                            controller.showPayTypeDialog(
                                              context,
                                            );
                                          },
                                        ),
                                        Gaps.vGap12,
                                        _buildInput(
                                          context,
                                          "姓名",
                                          "请输入姓名",
                                          controller.nameInputController,
                                        ),
                                        if (controller.currentPayType.value ==
                                            PayType.bank)
                                          _buildBankWidget(),
                                        if (controller.currentPayType.value ==
                                            PayType.alipay)
                                          _buildAlipayWidget(),
                                        if (controller.currentPayType.value ==
                                            PayType.usdt)
                                          _buildUsdtWidget(),
                                        Gaps.vGap12,
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: Dimens.gap_dp100,
                                              child: Text(
                                                '提现金额',
                                                style: TextStyle(
                                                    fontSize: Dimens.font_sp16),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: Dimens.gap_dp48,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF2F5F8),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.gap_dp6),
                                                ),
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.only(
                                                  left: Dimens.gap_dp12,
                                                  right: Dimens.gap_dp12,
                                                ),
                                                child: CustomInputNormal(
                                                  controller: controller
                                                      .withdrawalAmountInputController,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: Dimens.font_sp16,
                                                  ),
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: Dimens.font_sp16,
                                                  ),
                                                  hintText: '请输入提现金额',
                                                  keyboardType:
                                                      const TextInputType
                                                          .numberWithOptions(
                                                    decimal: true,
                                                  ),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                      RegExp("[0-9]"),
                                                    ),
                                                    // MyNumberTextInputFormatter(digit: 2),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gaps.vGap12,
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: Dimens.gap_dp100),
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '*实际到账0.0元\n',
                                                  style: TextStyle(
                                                    fontSize: Dimens.font_sp12,
                                                    color: const Color(
                                                      0xFFFB6621,
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '提现手续费: 1000以内(含)2%，1000以上2%',
                                                  style: TextStyle(
                                                    fontSize: Dimens.font_sp12,
                                                    color: Colors.black,
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
                              ),
                              GradientButton(
                                text: '提交申请',
                                width: double.infinity,
                                height: Dimens.gap_dp56,
                                onTap: () {
                                  controller.submit(context);
                                },
                                margin: const EdgeInsets.all(AppTheme.margin),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                  left: Dimens.gap_dp16,
                                  right: Dimens.gap_dp16,
                                ),
                                child: Text(
                                  '提现提醒: 105元起，若余额不足请先进游戏转出金币，若有疑问，请联系游戏客服',
                                  style: TextStyle(
                                    fontSize: Dimens.font_sp14,
                                    color: const Color(0xFF626773),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Gaps.vGap26,
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankWidget() {
    final controller = WithdrawalPageController.to;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Gaps.vGap12,
        _buildSelect(
          context,
          '银行名称',
          controller.bankValue,
          style: controller.currentBank.value.isNotEmpty
              ? TextStyle(
                  color: Colors.black,
                  fontSize: Dimens.font_sp16,
                )
              : null,
          onTap: () {
            controller.showBankDialog(context);
          },
        ),
        Gaps.vGap12,
        _buildInput(
          context,
          "银行卡号",
          "请输入银行卡号",
          controller.cardNumberInputController,
        ),
        Gaps.vGap12,
        _buildInput(
          context,
          "开户支行",
          "请输入开户支行",
          controller.bankBranchInputController,
        ),
      ],
    );
  }

  Widget _buildUsdtWidget() {
    final controller = WithdrawalPageController.to;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Gaps.vGap12,
        _buildSelect(
          context,
          '协议网络',
          controller.usdtTypeValue,
          style: null != controller.currentUsdtType.value
              ? TextStyle(
                  color: Colors.black,
                  fontSize: Dimens.font_sp16,
                )
              : null,
          onTap: () {
            controller.showUsdtTypeDialog(context);
          },
        ),
        Gaps.vGap12,
        _buildInput(
          context,
          "协议地址",
          "请输入协议地址",
          controller.usdtAddressInputController,
        ),
      ],
    );
  }

  Widget _buildAlipayWidget() {
    final controller = WithdrawalPageController.to;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Gaps.vGap12,
        _buildInput(
          context,
          "支付宝账号",
          "请输入支付宝账号",
          controller.alipayAccountInputController,
        ),
      ],
    );
  }

  /// ====输入框===========
  Widget _buildInput(
    BuildContext context,
    String label,
    String hintText,
    TextEditingController controller,
  ) {
    return Row(
      children: [
        SizedBox(
          width: Dimens.gap_dp100,
          child: Text(
            label,
            style: TextStyle(fontSize: Dimens.font_sp16),
          ),
        ),
        Expanded(
          child: Container(
            height: Dimens.gap_dp48,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F5F8),
              borderRadius: BorderRadius.circular(Dimens.gap_dp6),
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: Dimens.gap_dp12,
              right: Dimens.gap_dp12,
            ),
            child: CustomInputNormal(
              controller: controller,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: Dimens.font_sp16,
              ),
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: Dimens.font_sp16,
              ),
              hintText: hintText,
              keyboardType: TextInputType.text,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelect(
    BuildContext context,
    String label,
    String hintText, {
    TextStyle? style,
    Function()? onTap,
  }) {
    return Row(
      children: [
        SizedBox(
          width: Dimens.gap_dp100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: Dimens.font_sp16,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: Dimens.gap_dp48,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F5F8),
                borderRadius: BorderRadius.circular(Dimens.gap_dp6),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                left: Dimens.gap_dp12,
                right: Dimens.gap_dp12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hintText,
                    style: style ??
                        TextStyle(
                          color: Colors.grey,
                          fontSize: Dimens.font_sp16,
                        ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
