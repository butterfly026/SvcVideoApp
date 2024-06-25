import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/cell.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

/// 设置
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                title: const Text('设置'),
                backgroundColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppTheme.margin,
                ).copyWith(
                  top: Dimens.gap_dp12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(Dimens.gap_dp10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.gap_dp10),
                  child: CustomCellGroup(
                    minHeight: Dimens.gap_dp56,
                    showDivider: false,
                    children: [
                      _buildCustomCell(
                        context,
                        title: '找回账号',
                        leading: Images.iconRetrieveAccount.assetName,
                        onTap: () {
                          Get.toNamed(AppRouter.retrieveAccount);
                        },
                      ),
                      // _buildCustomCell(
                      //   context,
                      //   title: '支付密码',
                      //   leading: Images.iconPayPassword.assetName,
                      //   onTap: () {},
                      // ),
                      // _buildCustomCell(
                      //   context,
                      //   title: '绑定手机',
                      //   leading: Images.iconBindPhone.assetName,
                      //   onTap: () {},
                      // ),
                      _buildCustomCell(
                        context,
                        title: '卡券',
                        leading: Images.iconRedeemCode.assetName,
                        onTap: () {
                          Get.toNamed(AppRouter.coupon);
                        },
                      ),
                      // _buildCustomCell(
                      //   context,
                      //   title: '观影券',
                      //   leading: Images.iconRedeemCode.assetName,
                      //   onTap: () {},
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCell(
    BuildContext context, {
    required String title,
    required String leading,
    Function()? onTap,
  }) {
    return CustomCell(
      showArrow: true,
      onTap: onTap,
      leading: Container(
        margin: EdgeInsets.only(
          right: Dimens.gap_dp10,
        ),
        child: RHExtendedImage.asset(
          leading,
          width: Dimens.gap_dp20,
          height: Dimens.gap_dp20,
        ),
      ),
      title: Text(title),
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.gap_dp12,
      ),
      titleStyle: TextStyle(
        fontSize: Dimens.font_sp16,
        color: const Color(0xFF191D26),
      ),
    );
  }
}
