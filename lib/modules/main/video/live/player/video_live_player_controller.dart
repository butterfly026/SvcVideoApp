import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:get/get.dart';

class VideoLivePlayerController extends GetxController {
 // final FijkPlayer player = FijkPlayer();

  Rx<ClassifyContentModel?> videoData = Rx(null);

  @override
  void onReady() {
    super.onReady();
    final arguments = Get.arguments;
    if (null != arguments) {
      final data = arguments as ClassifyContentModel;
      videoData.value = data;

      // player.setDataSource(
      //   // 'http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid_demo1080p.flv',
      //   // 'http://abc.ddbofh.cn/live/5039546_1702893863.flv?txSecret=90fc581940ce5993ec08d88a15daab18&txTime=65804357',
      //   // data.address,
      //   data.address,
      //   autoPlay: true,
      // );
    }
  }
}
