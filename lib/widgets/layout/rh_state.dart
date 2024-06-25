import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video_community/global/enum/state.dart';

abstract class RhState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  final StreamController<LoadState> _streamController = StreamController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => didMountWidget(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    _streamController.close();
    WidgetsBinding.instance.removeObserver(this);
  }

  /// Schedule a callback for the end of this frame.
  void didMountWidget() {}

  /// The application is visible and responding to user input.
  void onResumed() {}

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  void onPaused() {}

  /// The application is in an inactive state and is not receiving user input.
  void onInactive() {}

  /// The application is still hosted on a flutter engine but is detached from
  /// any host views.
  void onDetached() {}
}
