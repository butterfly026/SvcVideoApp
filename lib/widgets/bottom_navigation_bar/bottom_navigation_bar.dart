import 'package:flutter/material.dart';
import 'package:flutter_video_community/config/dimens.dart';
import 'package:flutter_video_community/modules/main/main_controller.dart';
import 'package:get/get.dart';

import 'bottom_tab.dart';
import 'bottom_tab_model.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
    this.tabs,
    this.onTap,
  });

  final List<BottomTabModel>? tabs;
  final Function(int)? onTap;

  @override
  State<StatefulWidget> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  List<BottomTabModel> get _tabs => widget.tabs ?? [];

  late MainController controller;

  Color backgroundColor = Colors.white.withOpacity(0.75);

  @override
  void initState() {
    super.initState();
    controller = MainController.to;
    ever(
      controller.currentIndex,
      (callback) {
        if (mounted) {
          setState(() {});
        }
      },
    );
    ever(controller.bottomTabDataList, (callback) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabData = _tabs[controller.currentIndex.value];
    if (tabData.url.startsWith('app://video') ||
        tabData.url.startsWith('app://game') ||
        tabData.url.startsWith('app://antvVideo')) {
      backgroundColor = Theme.of(context).colorScheme.surface;
    } else {
      backgroundColor = Colors.white.withOpacity(0.75);
    }
    return Container(
      height: Dimens.gap_dp60,
      color: backgroundColor,
      child: Row(
        children: _tabs.map((data) => _buildTab(data)).toList(),
      ),
    );
  }

  Widget _buildTab(BottomTabModel tabData) {
    return Expanded(
      child: BottomTab(
        data: tabData,
        encrypted: true,
        selected: controller.currentIndex.value == _tabs.indexOf(tabData),
        onTap: (value) {
          final int newIndex = _tabs.indexOf(value);
          if (null != widget.onTap) {
            widget.onTap!.call(newIndex);
          }
        },
      ),
    );
  }
}
