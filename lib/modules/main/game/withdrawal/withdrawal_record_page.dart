import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/global/widgets/state/empty_view.dart';
import 'package:flutter_video_community/modules/main/game/withdrawal/withdrawal_record_list_item.dart';
import 'package:flutter_video_community/modules/order/order_history_list_item.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/app_tool.dart';
import 'package:flutter_video_community/widgets/app_bar.dart';
import 'package:get/get.dart';

import 'withdrawal_record_controller.dart';

class WithdrawalRecordPage extends StatefulWidget {
  const WithdrawalRecordPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WithdrawalRecordPageState();
}

class _WithdrawalRecordPageState extends State<WithdrawalRecordPage> {
  late WithdrawalRecordController _controller;
  String title = '';
  @override
  void initState() {
    super.initState();
    _controller = Get.put(WithdrawalRecordController());
    title = Get.parameters['title'] ?? "提现记录";
    _controller.init();
    _controller.loadData();
    // if (AppTool.isNotEmpty(rechargeType)) {
    //   _controller.rechargeType = rechargeType;
    //
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Image(
            image: Images.imgBgHeader,
            fit: BoxFit.fitWidth,
          ),
          Obx(() {
            return Column(
              children: [
                CustomAppBar(
                  title: Text(title),
                  backgroundColor: Colors.transparent,
                ),
                Gaps.vGap16,
                _controller.dataList.isNotEmpty
                    ? Expanded(
                      child: EasyRefresh(
                        onRefresh: () async {
                          _controller.loadData();
                        },
                        onLoad: () async {
                          _controller.loadMore();
                        },
                        child:ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.margin,
                            ),
                            itemCount: _controller.dataList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: Dimens.gap_dp12,
                                ),
                                child: GameWithdrawalRecordListItem(
                                  data: _controller.dataList[index],
                                ),
                              );
                            },
                          )
                      ),
                    )
                    : const EmptyView(),

              ],
            );
          })
        ],
      ),
    );
  }
}
