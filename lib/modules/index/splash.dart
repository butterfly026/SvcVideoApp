import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/global/widgets/loading_chasing_dots.dart';
import 'package:flutter_video_community/modules/index/splash_controller.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SplashController splashController;

  @override
  void initState() {
    super.initState();
    splashController = SplashController();
    Get.put(splashController);
    // ever(splashController.appConfigInfo, (appConfigInfo) {
    //   if (null == appConfigInfo) {
    //     return;
    //   }
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     if (context.mounted) {
    //       if (appConfigInfo.needUpdate) {
    //         AppUpdateDialog.show(
    //           context,
    //           data: appConfigInfo.updateInfo,
    //         );
    //       }
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: splashController,
      builder: (controller) {
        return  Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          // body: RHExtendedImage.asset(
          //   Images.imgSplash.assetName,
          //   fit: BoxFit.cover,
          // ),
          //body: Image(image: Images.imgSplash, fit: BoxFit.cover,)
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: Images.imgSplash,
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppUtil.buildLoadingAnimation(),
                  const SizedBox(
                    height: 14,
                  ),
                  const Text('正在匹配最优线路...', style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
