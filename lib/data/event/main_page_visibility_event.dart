import 'package:flutter_video_community/widgets/bottom_navigation_bar/bottom_tab_model.dart';

class MainPageVisibilityEvent {
  MainPageVisibilityEvent({
    this.visible = false,
    required this.data,
  });

  String get routeName => data.content;

  bool visible;
  BottomTabModel data;

  @override
  String toString() {
    return 'MainPageVisibilityEvent{visible: $visible, data: $data}';
  }
}
