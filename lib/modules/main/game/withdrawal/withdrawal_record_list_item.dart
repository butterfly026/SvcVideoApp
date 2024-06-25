import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/models/game/game_withdrawal_record.dart';
import 'package:flutter_video_community/global/enum/pay.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:oktoast/oktoast.dart';

import 'withdrawal_record_controller.dart';

class GameWithdrawalRecordListItem extends StatelessWidget {
  const GameWithdrawalRecordListItem({
    super.key,
     required this.data,
  });

  final GameWithdrawalRecordModel data;

  @override
  Widget build(BuildContext context) {
    final controller = WithdrawalRecordController.to;
    int orderStatus = int.parse(data.status);
    String orderNo = data.id;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Dimens.gap_dp1 * 60,
                  height: Dimens.gap_dp26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCE63),
                    borderRadius: BorderRadius.circular(
                      Dimens.gap_dp1 * 3,
                    ),
                  ),
                  child: Text(AppUtil.showPayName(data.exchangeAccount.type),style: TextStyle(
                      color: Color(0xFF965100),fontWeight: FontWeight.bold,
                      fontSize: Dimens.font_sp16

                  ),),
                ),
                Gaps.hGap6,
                Expanded(child:
                Text("订单号: $orderNo",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: Dimens.font_sp18, fontWeight: FontWeight.w400),)),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,//扩大点击区域
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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

                  Text(_showOrderStatusName(orderStatus), style: TextStyle(
                    color: showOrderStatusColor(orderStatus) ,
                    fontSize: Dimens.font_sp18,
                  ),),

                  Text(data.exchangeTime, style: TextStyle(fontSize: Dimens.font_sp16, fontWeight: FontWeight.w400),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _showOrderStatusName(int status) {
    String defaultName = "网络异常";
    switch(status) {
      case 1:
        return '申请中';
      case 2:
        return '已处理';
      case 3:
        return '已拒绝';
    }
    return defaultName;
  }

  Color showOrderStatusColor(int status) {
    Color defaultColor = Colors.black26;
    switch(status) {
      case 1:
        return const Color(0xFF64a6f8);
      case 2:
        return const Color(0xFF89C45F);
      case 3:
        return const Color(0xFFdfa859);
    }
    return defaultColor;
  }

}
