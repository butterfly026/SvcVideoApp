import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/config.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/data/event/update_download_progress.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/global/controller/global_controller.dart';
import 'package:flutter_video_community/global/global.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/video/video_label.dart';

class CrackAppItemWidget extends StatefulWidget {
  const CrackAppItemWidget({
    super.key,
    required this.data,
  });

  final AdsModel data;

  @override
  State<StatefulWidget> createState() => _CrackAppItemWidgetState();
}

class _CrackAppItemWidgetState extends State<CrackAppItemWidget> {
  double progress = 0;

  bool get downloading => progress > 0.0;

  StreamSubscription<UpdateDownloadProgress>? streamSubscription;
  ValueNotifier<double> progressNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    streamSubscription = eventBus.on<UpdateDownloadProgress>().listen((event) {
      if (mounted && widget.data.id == event.appId) {
        progressNotifier.value = event.progress;
      }
    });
  }

  @override
  void dispose() {
    progressNotifier.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Dimens.gap_dp60,
          height: Dimens.gap_dp60,
          child: Stack(
            children: [
              RHExtendedImage.network(
                widget.data.pic,
                width: Dimens.gap_dp60,
                height: Dimens.gap_dp60,
                borderRadius: BorderRadius.circular(Dimens.gap_dp10),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ValueListenableBuilder(
                  valueListenable: progressNotifier,
                  builder: (context, progress, child) {
                    if (progress == 0 || progress == 1.0) {
                      return Gaps.empty;
                    }
                    return SizedBox(
                      height: Dimens.gap_dp6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.gap_dp10),
                        child: LinearProgressIndicator(
                          backgroundColor: AppTheme.success.withAlpha(25),
                          value: progress,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.success,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (widget.data.isVip)
                Align(
                  alignment: Alignment.topLeft,
                  child: VideoLabelWidget(
                    text: 'VIP',
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.gap_dp6,
                      vertical: Dimens.gap_dp1,
                    ),
                    style: TextStyle(
                      fontSize: Dimens.font_sp10,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Gaps.vGap6,
        Text(
          widget.data.name,
          style: TextStyle(
            fontSize: Dimens.font_sp12,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}
