
import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/data/models/favor/favor_item.dart';
import 'package:flutter_video_community/modules/favor/favor_controller.dart';
import 'package:flutter_video_community/widgets/image.dart';

class FavorListItem extends StatefulWidget {
  const FavorListItem({super.key, required this.favorItem});
  final FavorItemModel favorItem;

  @override
  State<FavorListItem> createState() => _FavorListItemState();
}

class _FavorListItemState extends State<FavorListItem> {
  @override
  Widget build(BuildContext context) {
    FavorController favorController = FavorController.to;
    FavorItemModel favorItem = widget.favorItem;
    return  Stack(
      children: [
        RHExtendedImage.network(
          favorItem.contentImageUrl,
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.circular(
            Dimens.gap_dp10,
          ),
        ),
        // if (data.vip)
        //   const Align(
        //     alignment: Alignment.topLeft,
        //     child: VideoLabelWidget(text: 'VIP'),
        //   ),
        if (favorController.editable.value) Positioned(
          right: -4,
          top:  -4,
          child: Transform.scale(
            scale: 1.5,
            child: Checkbox(
              activeColor: const Color(0xFFF9552A),
              value: favorItem.checked,
              side: const BorderSide(color: Colors.white, width: 1.5),
              onChanged: (value) {
                setState(() {
                  bool checked = !favorItem.checked;
                  favorController.handleCheckItem(favorItem.contentId, checked);
                  favorItem.checked = checked;
                });
              },
              shape: const CircleBorder(),//这里就是实现圆形的设置
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: Dimens.gap_dp30,
            alignment: Alignment.topLeft,
            margin: EdgeInsets.symmetric(
              horizontal: Dimens.gap_dp12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  favorItem.contentTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: Dimens.font_sp14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

      ],

    );;
  }
}

