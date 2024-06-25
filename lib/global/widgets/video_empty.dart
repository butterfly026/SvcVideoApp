
import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/utils/app.dart';
import 'package:flutter_video_community/widgets/button/gradient.dart';

class VideoEmpty extends StatelessWidget {
  const VideoEmpty({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Image(
              image: AssetImage('assets/images/image_empty.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '暂无数据',
                style: TextStyle(
                      color: const Color(0xff626773),
                      fontSize: Dimens.font_sp14,
                    ),
              ),
            ),
          ),
        ],
      )
    );
    return Container();
  }
}
