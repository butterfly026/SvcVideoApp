
import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';

class RouteEmpty extends StatelessWidget {
  const RouteEmpty({super.key, required this.route, required this.openWay});

  final String route;
  final String openWay;

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: GradientButton(
    //     text: '点击跳转',
    //     width: 90,
    //     height: 46,
    //     onTap: () {
    //       /// 开始阅读
    //       AppUtil.to(route, openWay);
    //     },
    //   ),
    // );
    return Container();
  }
}
