import 'package:flutter/material.dart';
import '../core/navigation/main_nav_shell.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/profile/screens/profile_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const MainNavShell(),
    notifications: (context) => const NotificationsScreen(),
    profile: (context) => const ProfileScreen(),
  };
}

