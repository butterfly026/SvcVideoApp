
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/models/mine/order_history_model.dart';
import 'package:flutter_video_community/data/repository/mine/mine_repository.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class OrderHistoryController extends GetxController {


  static OrderHistoryController get to => Get.find();
  String? rechargeType;
  int pageIndex = 1;
  int pageSize = 20;
  var dataList = <OrderHistoryModel>[].obs;
  /// 金额列表
  //RxList<OrderHistoryModel> itemList = RxList();
  MineRepository get _repository => Global.getIt<MineRepository>();
  @override
  void onReady() {
    super.onReady();

  }

  loadMore() async {
    int tmpPageIndex = pageIndex + 1;
    List<OrderHistoryModel> newItemList = await _repository.getOrderHistory(rechargeType!, tmpPageIndex, pageSize);
    if (newItemList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex += 1;
      List<OrderHistoryModel> tmpList = <OrderHistoryModel>[];
      tmpList.addAll(dataList);
      tmpList.addAll(newItemList);
      dataList.value = tmpList;
      print("size=${newItemList.length}");
    }
  }

  void init() {
    pageIndex = 0;
    dataList.clear();
  }

  Future<List<OrderHistoryModel>?> loadData() async{
    if (AppTool.isEmpty(rechargeType)) {
      return null;
    }
    // update();
    return loadDataWithType(rechargeType!);
  }

  Future<List<OrderHistoryModel>> loadDataWithType(String rechargeType) async{
    pageIndex = 0;
    dataList.value = await _repository.getOrderHistory(rechargeType, 1, pageSize);
    if (dataList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex = 1;
    }
    // update();
    return dataList;
  }

}