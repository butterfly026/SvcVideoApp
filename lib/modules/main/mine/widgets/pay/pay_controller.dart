import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_video_community/data/event/purchase_occurred_event.dart';
import 'package:flutter_video_community/data/models/mine/pay_channel.dart';
import 'package:flutter_video_community/data/models/mine/recharge_model.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/global/repository/global_repository.dart';
import 'package:flutter_video_community/global/widgets/loading_dialog.dart';
import 'package:flutter_video_community/utils/cache_util.dart';
import 'package:flutter_video_community/utils/common_util.dart';
import 'package:flutter_video_community/utils/umeng_util.dart';
import 'package:flutter_video_community/widgets/dialog.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PayController extends GetxController {
  static PayController get to => Get.find();

  static String payType = "";
  static setPayType(String value) {
    payType = value;
  }

  /// 支付渠道
  RxList<PayChannelModel> payChannelList = RxList();
  RxList<PayChannelModel> filterPayChannelList = RxList();

  Rx<RechargeModel?> rechargeData = Rx(null);
  Rx<PayChannelModel?> payChannelData = Rx(null);

  GlobalRepository get _repository => null == Get.context
      ? GlobalRepository()
      : RepositoryProvider.of<GlobalRepository>(Get.context!);

  Future<void> updatePayChannelList() async {
    final rechargeModel = rechargeData.value;
    if (null == rechargeModel) {
      return;
    }
    final filterList = payChannelList.where((element) {
      return rechargeModel.getPrice() >= element.minPriceValue &&
          rechargeModel.getPrice() <= element.maxPriceValue;
    }).toList();
    if (filterList.isNotEmpty) {
      filterList.first.selected = true;
      filterPayChannelList.value = filterList;
      payChannelData.value = filterList.first;
    }
  }

  Future<void> switchPayChannel(
    PayChannelModel data,
  ) async {
    if (data.id == payChannelData.value?.id) {
      return;
    }
    payChannelData.value = data;

    for (final item in filterPayChannelList) {
      item.selected = item.id == data.id;
    }
    update();
  }

  Future<void> startPay(
    BuildContext context,
  ) async {
    try {
      final rechargeModel = rechargeData.value;
      if (null == rechargeModel) {
        return;
      }
      final rechargePackageId = rechargeModel.id;

      final payChannelModel = payChannelData.value;
      if (null == payChannelModel) {
        return;
      }
      final payCode = payChannelModel.code;
      final dataMap = <String, dynamic>{
        'rechargePackageId': rechargePackageId,
        'payCode': payCode,
      };
      LoadingDialog.show(context);
      final result = await _repository.createOrder(dataMap);
      CacheUtil.setNeedUpdateUserInfo(true);
      LoadingDialog.dismiss();
      if (null != result) {
        // ignore: use_build_context_synchronously
        _startPay(context, result);
        eventBus.fire(PurchaseOccurredEvent());
      } else {
        /// 订单创建失败
        // ignore: use_build_context_synchronously
        RhActionDialog.show(
          context,
          text: '订单创建失败',
          actionCancelText: '关闭',
        );
      }
    } catch (error) {
      LoadingDialog.dismiss();
    }
  }

  Future<void> _startPay(
    BuildContext context,
    String url,
  ) async {
    CommonUtil.launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    ).then((value) {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          checkPayResult(context, url);
        },
      );
    });
  }

  Future<void> checkPayResult(
    BuildContext context,
    String url,
  ) async {
    RhActionDialog.show(
      context,
      text: '是否已完成付款？如果支付失败可切换其他支付渠道',
      actionCancelText: '选择其他支付渠道',
      actionConfirmText: '支付成功',
      onConfirm: () {
        UmengUtil.upPoint(payType, {
          'name': UMengEvent.paySuccess,
          'desc': '支付成功',
        });
        CacheUtil.setNeedUpdateUserInfo(true);
        Get.back();
      },
    );
  }
}
