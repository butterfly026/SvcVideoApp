import 'package:flutter/services.dart';
import 'package:flutter_video_community/data/models/community/community.dart';
import 'package:flutter_video_community/data/repository/community/community_repository.dart';
import 'package:flutter_video_community/data/repository/favor/favor_repository.dart';
import 'package:flutter_video_community/data/repository/index/index_repository.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/widgets/loading_dialog.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class CommunityDetailsController extends GetxController {
  Rx<CommunityModel?> details = Rx(null);

  RxList<String> bannerList = RxList();
  String? curDetailId;

  CommunityRepository get _repository => Global.getIt<CommunityRepository>();
  IndexRepository get _indexRepository => Global.getIt<IndexRepository>();
  FavorRepository get _favorRepository => Global.getIt<FavorRepository>();

  @override
  void onReady() {
    super.onReady();
  }

  void refreshDefaultDetail() async {
    if (!AppTool.isEmpty(curDetailId)) {
      refreshData(curDetailId!);
    }
  }

  void refreshData(String id) async {
    curDetailId = id;
    await _indexRepository.userInfo();
    getDetails(id);
  }

  Future<void> _checkDetail() async {
    if (AppTool.isEmpty(curDetailId) || Get.context == null) {
      return;
    }
    if (details.value == null) {
      await getDetails(curDetailId!);
    }
    if (details.value == null) {
      return;
    }
  }

  Future<void> favorOrNot() async{
    if (details.value == null) {
      return;
    }
    bool favored = details.value?.haveCollect ?? false;
    CommunityModel communityModel = details.value!;

    if (favored) {
      await _favorRepository.cancelFavor(communityModel.id).then((value) =>
      {showToast("已取消收藏")});
    } else {
      await _favorRepository.favor(communityModel.id, communityModel.title
          , communityModel.pic, communityModel.type).then((value) => {
            showToast('收藏成功')
      });
    }
    refreshDefaultDetail();
    
  }

  //解锁社区子模块内容
  Future<void> unlock() async {
    await _checkDetail();
    LoadingDialog.show(Get.context!);
    CommunityModel detail = details.value!;
    num? unlockCoins = detail.price;
    LoadingDialog.dismiss();
    AppUtil.consumeCoin(unlockCoins, detail.type, detail.id, detail.title);
  }

  Future<void> getDetails(String id) async {
    try {
      final value = await _repository.getSocAttendantInfo(id);
      details.value = value;
      final pic = value.pic;
      if (pic.isNotEmpty) {
        final list = pic.split(',');
        bannerList.value = list;
      }
    } catch (error) {
      /// void
    }
  }

  Future<void> copy() async {
    if (null != details.value) {
      await Clipboard.setData(
        ClipboardData(text: details.value!.contact),
      );
      showToast('已复制');
    }
  }
}
