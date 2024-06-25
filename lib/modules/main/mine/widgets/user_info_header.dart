import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/modules/main/mine/mine_page_controller.dart';
import 'package:flutter_video_community/modules/main/mine/widgets/vip_widget.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class UserInfoHeader extends StatelessWidget {
  const UserInfoHeader({super.key, required this.userInfo});

  final UserModel userInfo;

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.margin,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: Dimens.gap_dp80,
              height: Dimens.gap_dp80,
              child: AppTool.isEmpty(userInfo.avatar) ?
              RHExtendedImage.asset(
                'assets/images/dading.png',
                width: Dimens.gap_dp100,
                height: Dimens.gap_dp100,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(Dimens.gap_dp40),
              ) : RHExtendedImage.network(
                userInfo.avatar,
                width: Dimens.gap_dp100,
                height: Dimens.gap_dp100,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(Dimens.gap_dp40),
              ),
            ),
            Gaps.hGap20,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    userInfo.nickName ?? '',
                    style: TextStyle(
                      fontSize: Dimens.font_sp18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.vGap4,
                  if (!AppTool.isEmpty(userInfo.userId))
                    GestureDetector(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppUtil.showUserId(userInfo.userId),
                              style: TextStyle(
                                fontSize: Dimens.font_sp16,
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                           Icon(Icons.copy_sharp, size: Dimens.font_sp16)
                        ],
                      ),
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                              text: userInfo.userId),
                        );
                        //Get.snackbar("用户id已复制", "", duration: const Duration(seconds: 1));
                        showToast('用户id已复制');
                      },
                    ),
                  Gaps.vGap6,
                   VipWidget(vipTime: userInfo.vipTime),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRouter.settings);
              },
              child: Container(
                height: Dimens.gap_dp20,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(
                  left: AppTheme.margin / 2,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '个人设置',
                      style: TextStyle(
                        fontSize: Dimens.font_sp12,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    Container(
                      width: Dimens.gap_dp20,
                      height: Dimens.gap_dp20,
                      alignment: Alignment.center,
                      child: RHExtendedImage.asset(
                        Images.iconArrowRight.assetName,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildUserAvatar(MinePageController controller) {
    return controller.userInfo.value?.avatar == null ?
    RHExtendedImage.asset(
      // controller.userInfo.value?.avatar ??
      Images.avatar.assetName,
      width: Dimens.gap_dp100,
      height: Dimens.gap_dp100,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(Dimens.gap_dp40),
    ) : RHExtendedImage.network(
      controller.userInfo.value!.avatar,
      width: Dimens.gap_dp100,
      height: Dimens.gap_dp100,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(Dimens.gap_dp40),
    );
  }
}
