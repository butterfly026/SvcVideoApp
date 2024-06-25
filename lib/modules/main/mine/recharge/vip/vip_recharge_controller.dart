import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/models/index/user.dart';
import 'package:flutter_video_community/data/models/mine/pay_channel.dart';
import 'package:flutter_video_community/data/models/mine/recharge_model.dart';
import 'package:flutter_video_community/data/repository/mine/mine_repository.dart';
import 'package:flutter_video_community/global/enum/recharge_type.dart';
import 'package:flutter_video_community/global/widgets/loading_dialog.dart';
import 'package:flutter_video_community/modules/main/mine/widgets/pay/pay_controller.dart';
import 'package:flutter_video_community/modules/main/mine/widgets/pay/pay_dialog.dart';
import 'package:flutter_video_community/utils/cache.dart';
import 'package:get/get.dart';

class VipRechargeController extends GetxController {
  static VipRechargeController get to => Get.find();

  Rx<UserModel?> userInfo = Rx(null);

  Rx<RechargeModel?> currentRecharge = Rx(null);

  /// 金额列表
  RxList<RechargeModel> vipRechargeList = RxList();

  /// 支付渠道
  RxList<PayChannelModel> payChannelList = RxList();

  PayController get payController => PayController.to;

  MineRepository get _repository => null == Get.context
      ? MineRepository()
      : RepositoryProvider.of<MineRepository>(Get.context!);

  @override
  void onReady() {
    super.onReady();
    _queryUserInfo();
    _getVipRechargePackage();
  }

  Future<void> _queryUserInfo() async {
    final userInfo = Cache.getInstance().userInfo;
    this.userInfo.value = userInfo;
  }

  /// 初始化
  Future<void> _getVipRechargePackage() async {
    try {
      if (null != Get.context) {
        LoadingDialog.show(Get.context!);
      }
      final dataList = await _repository.getRechargePackage(RechargeType.vip);
      LoadingDialog.dismiss();

      vipRechargeList.value = dataList;
      if (dataList.isNotEmpty) {
        switchRecharge(dataList.first);
      }

      await _getPayChannelList();
      payController.payChannelList.value = payChannelList;
      PayController.to.updatePayChannelList();
    } catch (error) {
      LoadingDialog.dismiss();
    }
  }

  Future<void> _getPayChannelList() async {
    try {
      final dataList = await _repository.getPayChannelList(RechargeType.vip);
      payChannelList.value = dataList;
    } catch (error) {
      /// void
    }
  }

  Future<void> switchRecharge(
    RechargeModel data,
  ) async {
    if (data.id == currentRecharge.value?.id) {
      return;
    }
    currentRecharge.value = data;
    PayController.to.rechargeData.value = data;
    PayController.to.updatePayChannelList();
    update();
  }

  Future<void> recharge(
    BuildContext context,
  ) async {
    PayDialog.show(context);
  }
}
