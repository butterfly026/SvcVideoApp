import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/config/gaps.dart';
import 'package:flutter_video_community/config/images.dart';
import 'package:flutter_video_community/themes/theme.dart';
import 'package:flutter_video_community/widgets/image.dart';
import 'package:flutter_video_community/widgets/input.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.editingController,
    this.onSubmitted,
  });

  final TextEditingController editingController;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Dimens.gap_dp48,
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.margin,
        vertical: Dimens.gap_dp6,
      ),
      child: Container(
        height: Dimens.gap_dp32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.gap_dp24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFF0000),
              Color(0xFFFF7A00),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.gap_dp1 * 1.5,
          vertical: Dimens.gap_dp1 * 1.5,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(Dimens.gap_dp24),
          ),
          padding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RHExtendedImage.asset(
                Images.iconSearchGrey.assetName,
                width: Dimens.gap_dp14,
                height: Dimens.gap_dp14,
              ),
              Gaps.hGap8,
              Expanded(
                child: CustomInputNormal(
                  controller: editingController,
                  hintText: '搜索',
                  hintStyle: TextStyle(
                    color: const Color(0xFF61646C),
                    fontSize: Dimens.font_sp14,
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onSubmitted: onSubmitted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
