import 'package:flutter/material.dart';
import 'package:flutter_video_community/global/enum/state.dart';
import 'package:flutter_video_community/global/widgets/state/loading_view.dart';

import 'state/empty_view.dart';

class StateWidget extends StatelessWidget {
  const StateWidget({
    super.key,
    required this.child,
    this.state,
    this.loadingView,
    this.emptyView,
    this.failedView,
    this.onReload,
  });

  final Widget child;
  final LoadState? state;
  final Widget? loadingView;
  final Widget? emptyView;
  final Widget? failedView;
  final void Function()? onReload;

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: loadingView ?? const LoadingView(),
    );
    switch (state ?? LoadState.loading) {
      case LoadState.empty:
        body = emptyView ?? const EmptyView();
        break;
      case LoadState.failed:
        body = failedView ??
            GestureDetector(
              onTap: onReload,
              child: const EmptyView(
                text: '加载失败，点击重新加载',
              ),
            );
        break;
      case LoadState.successful:
        body = child;
        break;
      case LoadState.loading:
        body = Center(
          child: loadingView ?? const LoadingView(),
        );
        break;
      case LoadState.cancel:
        body = emptyView ?? const EmptyView();
        break;
    }
    return body;
  }
}
