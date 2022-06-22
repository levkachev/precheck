import 'package:tests/widgets/test_review.dart';
import 'package:flutter/material.dart';

import 'models/models.dart';

class RoutesName {
  // ignore: non_constant_identifier_names
  static const String MAIN_PAGE = '/main_page';

  // ignore: non_constant_identifier_names
  static const String DETAILS_PAGE = '/details_page';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.MAIN_PAGE:
        final args = settings.arguments as TestSummaryScreenArguments;
        return _GeneratePageRoute(
            widget: TestScreenWidget(model: args), routeName: settings.name ?? RoutesName.MAIN_PAGE);
      case RoutesName.DETAILS_PAGE:
        final args = settings.arguments as TestSummaryScreenArguments;
        return _GeneratePageRoute(
            widget: TestScreenWidget(model: args), routeName: settings.name ?? RoutesName.MAIN_PAGE);
      default:
        final args = settings.arguments as TestSummaryScreenArguments;
        return _GeneratePageRoute(
            widget: TestScreenWidget(model: args), routeName: settings.name ?? RoutesName.MAIN_PAGE);
    }
  }
}

class _GeneratePageRoute extends PageRouteBuilder {
  final Widget widget;
  final String routeName;

  _GeneratePageRoute({required this.widget, required this.routeName})
      : super(
            settings: RouteSettings(name: routeName),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return SlideTransition(
                textDirection: TextDirection.rtl,
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
}
