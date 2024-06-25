enum LaunchType { route, app, web, third, hybrid }

extension LaunchTypeExtension on LaunchType {
  String get value {
    switch (this) {
      case LaunchType.route:

      /// 路由协议
        return '0';
      case LaunchType.app:

        /// 内置 app 应用
        return '1';
      case LaunchType.web:

        /// 内置浏览器
        return '2';
      case LaunchType.third:

        /// 外部浏览器
        return '3';
      case LaunchType.hybrid:
        //app页面和内置浏览器的结合
        return '4';
    }
  }

  int get intV {
    switch (this) {
    /// 路由协议
      case LaunchType.route:
        return 0;
    /// 内置 app 应用
      case LaunchType.app:
        return 1;
    /// 内置浏览器
      case LaunchType.web:
        return 2;
    /// 外部浏览器
      case LaunchType.third:
        return 3;
      case LaunchType.hybrid:
      //app页面和内置浏览器的结合
        return 4;
    }
  }
}
