import 'package:flutter/material.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:flutter_video_community/widgets/list_scroll_view.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'state/empty_view.dart';
import 'state/loading_view.dart';

class RefreshView extends StatelessWidget {
  const RefreshView({
    super.key,
    required this.body,
    this.refreshController,
    this.onRefresh,
    this.onLoading,
    this.onReload,
    this.loadState = LoadState.loading,
  });

  final RefreshController? refreshController;
  final void Function()? onRefresh;
  final void Function()? onLoading;
  final void Function()? onReload;
  final LoadState loadState;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return CustomListScrollView(
      body: body,
      refreshController: refreshController,
      onRefresh: loadState == LoadState.loading ? null : onRefresh,
      onLoading: loadState == LoadState.loading ? null : onLoading,
      placeholderBuilder: (context) {
        Widget? child = const LoadingView();
        if (loadState == LoadState.empty) {
          child = const EmptyView();
        } else if (loadState == LoadState.failed) {
          child = GestureDetector(
            onTap: onReload,
            child: const EmptyView(
              text: '加载失败，点击重新加载',
            ),
          );
        } else if (loadState == LoadState.successful) {
          child = null;
        }
        return null != child ? Center(child: child) : null;
      },
    );
  }
}
