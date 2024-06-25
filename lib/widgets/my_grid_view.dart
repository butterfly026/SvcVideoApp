import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';

import 'image.dart';

// 回调
// item 当前遍历的对象
// index 当前下标
typedef StringCallback = String Function(dynamic item, int index);

/// 网格
class MyGridViewWidget<T> extends StatelessWidget {
  /// 数据
  final List<T> data;

  /// 是否可滑动
  final bool isScrollable;

  /// 每行个数
  final int count;

  /// 滑动方向
  final Axis scrollDirection;

  /// 图片地址回调
  final StringCallback imgCallBack;

  /// 文本地址回调
  final StringCallback textCallBack;

  const MyGridViewWidget({
    Key? key,
    required this.data,
    required this.count,
    this.scrollDirection = Axis.vertical,
    this.isScrollable = true,
    required this.imgCallBack,
    required this.textCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: isScrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: Dimens.gap_dp12,
      ),
      scrollDirection: scrollDirection,
      itemCount: (data.length / count).ceil(),
      itemBuilder: (context, index) {
        return Wrap(
          spacing: Dimens.gap_dp12, // 控制子widget之间的横向间距
          runSpacing: Dimens.gap_dp12, // 控制子widget之间的纵向间距
          alignment: WrapAlignment.start, // 控制子widget在主轴方向的对齐方式
          children: List.generate(
            data.length,
            (index) => SizedBox(
              width: (ScreenUtil().screenWidth -
                      Dimens.gap_dp24 -
                      Dimens.gap_dp36) /
                  count,
              child: Column(
                children: [
                  RHExtendedImage.asset(
                    borderRadius: BorderRadius.circular(10.0),
                    imgCallBack(data[index], index),
                    width: Dimens.gap_dp54,
                    height: Dimens.gap_dp54,
                  ),
                  Gaps.vGap6,
                  Text(
                    textCallBack(data[index], index),
                    style: TextStyle(fontSize: Dimens.font_sp12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
