import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/main/ads.dart';
import 'package:flutter_video_community/data/models/tab.dart';
import 'package:flutter_video_community/modules/main/home/home_page_controller.dart';
import 'package:flutter_video_community/modules/main/video/app/video_app_controller.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/utils/screen.dart';

class VideoClassifyDialog extends StatelessWidget {
  const VideoClassifyDialog({
    super.key,
    this.tabIndex = 0,
    this.adsModel,
    this.callback,
  });

  final int tabIndex;
  final AdsModel? adsModel;
  final Function(int)? callback;

  static Future<void> show(
    BuildContext context, {
    int index = 0,
    AdsModel? adsModel,
    Function(int)? callback,
  }) async {
    SmartDialog.show(
      tag: 'videoClassify',
      builder: (_) {
        return VideoClassifyDialog(
          tabIndex: index,
          adsModel: adsModel,
          callback: callback,
        );
      },
      alignment: Alignment.topCenter,
    );
  }

  static Future<void> dismiss() async {
    SmartDialog.dismiss(tag: 'videoClassify');
  }

  @override
  Widget build(BuildContext context) {
    List<TabModel> tabDataList;
    if (null != adsModel) {
      tabDataList = VideoAppController.to.tabDataList;
    } else {
      tabDataList = HomePageController.to.tabDataList;
    }
    return Container(
      width: Screen.width,
      height: Dimens.gap_dp10 * 27,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Dimens.gap_dp12),
          bottomRight: Radius.circular(Dimens.gap_dp12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.margin,
            ).copyWith(top: Dimens.gap_dp56),
            child: Text(
              '选择栏目',
              style: TextStyle(
                fontSize: Dimens.font_sp18,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                vertical: Dimens.gap_dp12,
                horizontal: Dimens.gap_dp12,
              ),
              itemCount: tabDataList.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                final double itemWidth = (Screen.width - 50) / 3;
                final bool isSelected = tabIndex == index;
                final itemData = tabDataList[index];
                return Container(
                  width: itemWidth,
                  margin: EdgeInsets.symmetric(
                    horizontal: Dimens.gap_dp1 * 5,
                    vertical: Dimens.gap_dp1 * 5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : const Color(0xFF999999),
                    borderRadius: BorderRadius.circular(Dimens.gap_dp8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        dismiss();
                        if (null != callback) {
                          callback!(index);
                        }
                      },
                      borderRadius: BorderRadius.circular(Dimens.gap_dp8),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          itemData.name,
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
