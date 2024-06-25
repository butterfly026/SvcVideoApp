
import 'package:flutter_video_community/data/models/game/game_withdrawal_record.dart';
import 'package:flutter_video_community/data/models/mine/order_history_model.dart';
import 'package:flutter_video_community/data/repository/game/game_repository.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class WithdrawalRecordController extends GetxController {


  static WithdrawalRecordController get to => Get.find();
  String? rechargeType;
  int pageIndex = 1;
  int pageSize = 20;
  var dataList = <GameWithdrawalRecordModel>[].obs;
  /// 金额列表
  //RxList<OrderHistoryModel> itemList = RxList();
  GameRepository get _repository => Global.getIt<GameRepository>();
  @override
  void onReady() {
    super.onReady();

  }

  loadMore() async {
    int tmpPageIndex = pageIndex + 1;
    List<GameWithdrawalRecordModel> newItemList = await _repository.getGameWithdrawalRecord(tmpPageIndex, pageSize);
    if (newItemList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex += 1;
      List<GameWithdrawalRecordModel> tmpList = <GameWithdrawalRecordModel>[];
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


  Future<List<GameWithdrawalRecordModel>> loadData() async{
    pageIndex = 0;
    dataList.value = await _repository.getGameWithdrawalRecord(1, pageSize);
    if (dataList.isNotEmpty) {
      //成功了才设置pageIndex
      pageIndex = 1;
    }
    // update();
    return dataList;
  }

}