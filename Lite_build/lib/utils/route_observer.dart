import 'package:flutter/material.dart';

final RouteObserver<ModalRoute<dynamic>> csRouteObserver = RouteObserver<ModalRoute<dynamic>>();

class LoggingRouteObserver extends RouteObserver<ModalRoute<dynamic>> {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint('[ROUTE] push ${route.settings.name ?? route.runtimeType} from ${previousRoute?.settings.name ?? previousRoute?.runtimeType}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint('[ROUTE] pop ${route.settings.name ?? route.runtimeType} to ${previousRoute?.settings.name ?? previousRoute?.runtimeType}');
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    debugPrint('[ROUTE] remove ${route.settings.name ?? route.runtimeType}');
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugPrint('[ROUTE] replace ${oldRoute?.settings.name ?? oldRoute?.runtimeType} -> ${newRoute?.settings.name ?? newRoute?.runtimeType}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

final LoggingRouteObserver loggingRouteObserver = LoggingRouteObserver();