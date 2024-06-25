part of router;

class RouteObservers<R extends Route<dynamic>> extends RouteObserver<R> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final name = route.settings.name ?? '';
    if (name.isNotEmpty) AppRouter.history.add(name);
    if (kDebugMode) {
      print('didPush');
      print(AppRouter.history);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    AppRouter.history.remove(route.settings.name);
    if (kDebugMode) {
      print('didPop');
      print(AppRouter.history);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      final index = AppRouter.history.indexWhere((element) {
        return element == oldRoute?.settings.name;
      });
      final name = newRoute.settings.name ?? '';
      if (name.isNotEmpty) {
        if (index > -1) {
          AppRouter.history[index] = name;
        } else {
          AppRouter.history.add(name);
        }
      }
    }
    if (kDebugMode) {
      print('didReplace');
      print(AppRouter.history);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    AppRouter.history.remove(route.settings.name);
    if (kDebugMode) {
      print('didRemove');
      print(AppRouter.history);
    }
  }
}
