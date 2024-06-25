import 'package:flutter_video_community/data/models/mine/coupon_model.dart';
import 'package:flutter_video_community/data/models/mine/order_history_model.dart';
import 'package:flutter_video_community/data/models/mine/pay_channel.dart';
import 'package:flutter_video_community/data/models/mine/recharge_model.dart';
import 'package:flutter_video_community/data/repository/mine/mine_api.dart';
import 'package:flutter_video_community/global/enum/recharge_type.dart';

class MineRepository {
  final MineApi _api = MineApi();

  Future<List<OrderHistoryModel>> getOrderHistory(String rechargeType, int pageNum, int pageSize) async {
    final response = await _api.getOrderHistory(rechargeType, pageNum, pageSize);
    List<OrderHistoryModel> orderHistoryList = [];
    final jsonList = response.data as List;
    for (final item in jsonList) {
      orderHistoryList.add(
        OrderHistoryModel.fromJson(item as Map<String, dynamic>),
      );
    }
    return orderHistoryList;
  }

  Future<List<RechargeModel>> getRechargePackage(RechargeType rechargeType) async {
    final response = await _api.getRechargePackage(rechargeType.value);
    List<RechargeModel> rechargeModelList = [];
    final jsonList = response.data as List;
    for (final item in jsonList) {
      rechargeModelList.add(
        RechargeModel.fromJson(item as Map<String, dynamic>),
      );
    }
    return rechargeModelList;
  }

  Future<List<PayChannelModel>> getPayChannelList(RechargeType rechargeType) async {
    final response = await _api.getPayChannelList(rechargeType.value);
    List<PayChannelModel> dataList = [];
    final jsonList = response.data as List;
    for (final item in jsonList) {
      dataList.add(
        PayChannelModel.fromJson(item as Map<String, dynamic>),
      );
    }
    return dataList;
  }

  Future<List<CouponModel>> getCouponList() async {
    final response = await _api.getCouponList();
    List<CouponModel> dataList = [];
    final jsonList = response.data as List;
    for (final item in jsonList) {
      dataList.add(
        CouponModel.fromJson(item as Map<String, dynamic>),
      );
    }
    return dataList;
  }
}
