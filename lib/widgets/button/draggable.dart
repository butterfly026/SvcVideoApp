import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/modules/main/game/widgets/dragbutton.dart';
import 'package:flutter_video_community/utils/screen.dart';
import 'package:flutter_video_community/widgets/image.dart';

class DraggableButton extends StatelessWidget {
  const DraggableButton({
    super.key,
    required this.data,
  });

  final AdsModel data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
            DraggableFloatingActionButton(
              initialOffset: Offset(
                Screen.width - Dimens.gap_dp100,
                Screen.height - 200,
              ),
              dragEnable: true,
              child: GestureDetector(
                onTap: () {
                  GlobalController.to.launch(data);
                },
                child: RHExtendedImage.network(
                  data.pic,
                  width: Dimens.gap_dp100,
                  height: Dimens.gap_dp100,
                  borderRadius: BorderRadius.circular(
                    Dimens.gap_dp10,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
