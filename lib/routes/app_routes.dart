import 'package:flutter/material.dart';
import '../core/navigation/main_nav_shell.dart';

class AppRoutes {
  static const String home = '/';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const MainNavShell(),
  };
}
