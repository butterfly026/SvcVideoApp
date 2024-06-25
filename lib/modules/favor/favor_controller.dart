

import 'package:flutter/foundation.dart';
import 'package:flutter_video_community/data/event/favor_del_event.dart';
import 'package:flutter_video_community/data/models/favor/favor_cat.dart';
import 'package:flutter_video_community/data/repository/favor/favor_repository.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FavorController extends GetxController {

  static FavorController get to => Get.find();


  var tabList = <FavorCatModel>[].obs;
  final FavorRepository _repository = Global.getIt<FavorRepository>();
  var editable = false.obs;
  List<String> favorDelList = <String>[].obs;

  void handleCheckItem(String contentId, bool checked) {
    if (checked) {
      _addToDelList(contentId);
    } else {
      _removeFromDelList(contentId);
    }
  }

  void delFavorList() async{
    if (favorDelList.isNotEmpty) {
      String collectIds = favorDelList.join(",");
      await _repository.cancelFavor(collectIds);
      eventBus.fire(FavorDelEvent());
      favorDelList.clear();
      editable.value = false;
    }
  }

  void _addToDelList(String contentId) {
    if (!favorDelList.contains(contentId)) {
      favorDelList.add(contentId);
    }
    update();
    debugPrint("addToDelList contentId=$contentId  favorDelList=$favorDelList");
  }

  void _removeFromDelList(String contentId) {
    if (favorDelList.contains(contentId)) {
      favorDelList.remove(contentId);
    }
    update();
    debugPrint("removeFromDelList collectId=$contentId  favorDelList=$favorDelList");
  }

  @override
  void onInit() {
    super.onInit();
    favorDelList.clear();
    loadData();
  }


  void loadData() async {
    List<FavorCatModel> tmpFavorCatList  = await _repository.getFavorCatList();
    if (tmpFavorCatList.isNotEmpty) {
      tabList.value = tmpFavorCatList;

    }
  }

}