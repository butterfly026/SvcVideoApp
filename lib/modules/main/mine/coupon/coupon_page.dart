import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/mine/coupon_model.dart';
import 'package:flutter_video_community/global/widgets/state_widget.dart';
import 'package:flutter_video_community/modules/main/mine/coupon/coupon_controller.dart';
import 'package:flutter_video_community/modules/main/mine/coupon/coupon_list_item.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:get/get.dart';

/// 优惠券
class CouponPage extends StatefulWidget {
  const CouponPage({super.key});

  @override
  State<StatefulWidget> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  final _controller = Get.put(CouponController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
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
            body: Column(
              children: [
                CustomAppBar(
                  title: Text(
                    '优惠券',
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
                Expanded(
                  child: GetBuilder<CouponController>(
                    init: _controller,
                    builder: (controller) {
                      return StateWidget(
                        state: _controller.loadState.value,
                        onReload: _controller.reload,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _controller.dataList.length,
                          itemBuilder: (context, index) {
                            return CouponListItem(
                              data: _controller.dataList[index],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
