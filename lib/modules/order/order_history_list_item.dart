import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/data/models/mine/order_history_model.dart';
import 'package:flutter_video_community/data/models/mine/recharge_model.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/modules/order/order_history_controller.dart';
import 'package:flutter_video_community/modules/main/mine/recharge/vip/vip_recharge_controller.dart';
import 'package:flutter_video_community/widgets/countdown/countdown.dart';
import 'package:flutter_video_community/widgets/gradient_text.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class OrderHistoryListItem extends StatelessWidget {
  const OrderHistoryListItem({
    super.key,
     required this.data,
  });

  final OrderHistoryModel data;

  @override
  Widget build(BuildContext context) {
    final controller = OrderHistoryController.to;
    int orderStatus = data.orderStatue;
    String orderNo = data.orderNo;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border:  Border.all(
          color: Colors.grey.withOpacity(0.2), //边框颜色
          width: 1, //边框宽度
        ), // 边色与边宽度
        color: Colors.white, // 底色
        boxShadow: [
          BoxShadow(
            blurRadius: 10, //阴影范围
            spreadRadius: 0.1, //阴影浓度
            color: Colors.grey.withOpacity(0.2), //阴影颜色
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child:
                Text("订单号: $orderNo",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: Dimens.font_sp18, fontWeight: FontWeight.w400),)),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,//扩大点击区域
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Icon(Icons.copy_sharp),
                  ),
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: orderNo),
                    );
                    //Get.snackbar("用户id已复制", "", duration: const Duration(seconds: 1));
                     showToast('已复制');
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(orderStatus == 0 ? '已支付' : '未支付', style: TextStyle(
                    color: orderStatus == 0? Colors.green : Colors.deepOrangeAccent ,
                    fontSize: Dimens.font_sp18,
                  ),),
                  Text(data.createTime, style: TextStyle(fontSize: Dimens.font_sp16, fontWeight: FontWeight.w400),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
