import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/data/repository/main/main_repository.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/router/router.dart';
import 'package:flutter_video_community/utils/cache_util.dart';
import 'package:flutter_video_community/widgets/bottom_navigation_bar/bottom_tab_model.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class AppMenuUnlockView extends StatelessWidget {
  const AppMenuUnlockView({
    super.key,
    required this.tabData, required this.unlockFinished, required this.userCoins,
  });
  final BottomTabModel tabData;
  final Function() unlockFinished;
  final num userCoins;

  @override
  Widget build(BuildContext context) {
    num coinsTobeConsumed = tabData.unlockPrice;
    String title = '';
    String btnTitle = '';
    Function()? onOkBtn;
    final dataMap = <String, dynamic>{
      'coins': coinsTobeConsumed,
      'busType': 'appMemu',
      'busId': tabData.id,
      'busName': '解锁${tabData.name}菜单',
    };
    if (userCoins >= coinsTobeConsumed) {
      title = '当前需消费$coinsTobeConsumed金币';
      btnTitle = "立即解锁";
      onOkBtn = () async{
        MainRepository mainRepository = Global.getIt<MainRepository>();
        await mainRepository.buy(dataMap);
        // await reload();
       // LoadingDialog.dismiss();
        unlockFinished();
        showToast('解锁成功');
      };
    } else {
      title = '余额不足, 解锁需消费$coinsTobeConsumed金币';
      btnTitle = "立即充值";
      onOkBtn = () {
        Get.toNamed(AppRouter.coinRecharge);
      };
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0x80000000),
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimens.gap_dp40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: Dimens.gap_dp1 * 450,
              child: Stack(
                children: [
                  RHExtendedImage.asset(
                    Images.imgBgUnlockMenu.assetName,
                    width: double.infinity,
                    height: Dimens.gap_dp1 * 450,
                  ),
                  Positioned(
                    left: 74,
                    right: 74,
                    bottom: 40,
                    child: GradientButton(
                      width: Dimens.gap_dp10 * 13,
                      height: Dimens.gap_dp48,
                      text: btnTitle,
                      onTap: () {
                        if (null != onOkBtn) {
                          onOkBtn();
                        }
                      },
                    ),
                  ),
                  Positioned(
                    left: 56,
                    right: 56,
                    bottom: Dimens.gap_dp10 * 13,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFE7D4BA),
                        fontSize: Dimens.font_sp16,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
