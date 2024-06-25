import 'package:flutter/foundation.dart';
import 'package:flutter_video_community/data/models/main/classify_content.dart';
import 'package:flutter_video_community/data/repository/content/work_repository.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:get/get.dart';

class WorkSearchLogic extends GetxController {
  WorkRepository get _repository => Global.getIt<WorkRepository>();

  String? keyword;
  String? type;

  int pageIndex = 1;
  int pageSize = 10;
  var dataList = <ClassifyContentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void init(String type, String keyword) {
    this.type = type;
    this.keyword = keyword;
    pageIndex = 0;
    dataList.clear();
  }

  @override
  void onReady() {
    super.onReady();
  }

  loadMore() async {
    if (AppTool.isEmpty(keyword)) {
      debugPrint('work_search--loadMore-> keyword is null');
    }
    if (AppTool.isEmpty(type)) {
      debugPrint('work_search--loadMore-> type is null');
    }
    int tmpPageIndex = pageIndex + 1;
    List<ClassifyContentModel> newItemList = await _repository.getWorkSearchList(type!, keyword!, tmpPageIndex, pageSize);
    if (newItemList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex += 1;
      List<ClassifyContentModel> tmpList = <ClassifyContentModel>[];
      tmpList.addAll(dataList);
      tmpList.addAll(newItemList);
      dataList.value = tmpList;
      print("size=${newItemList.length}");
    }
  }


  Future<void> loadData() async{
    debugPrint('work_search-> loadData');
    if (AppTool.isEmpty(keyword)) {
      debugPrint('work_search--loadData-> keyword is null');
    }
    if (AppTool.isEmpty(type)) {
      debugPrint('work_search--loadData-> type is null');
    }
    pageIndex = 0;
    dataList.value = await _repository.getWorkSearchList(type!, keyword!, pageIndex, pageSize);
    if (dataList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex = 1;
    }
  }

}
