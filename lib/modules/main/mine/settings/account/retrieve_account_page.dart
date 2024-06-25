import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/cell.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

/// 找回账号
class RetrieveAccountPage extends StatefulWidget {
  const RetrieveAccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _RetrieveAccountPageState();
}

class _RetrieveAccountPageState extends State<RetrieveAccountPage> {
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
                title: const Text('找回账号'),
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
                        title: '使用账号凭证找回',
                        onTap: () {
                          Get.toNamed(AppRouter.scanCredentials);
                        },
                      ),
                      // _buildCustomCell(
                      //   context,
                      //   title: '使用手机号找回',
                      //   onTap: () {},
                      // ),
                      // _buildCustomCell(
                      //   context,
                      //   title: '联系客服找回',
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
    Function()? onTap,
  }) {
    return CustomCell(
      showArrow: true,
      onTap: onTap,
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
