import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';

class UniWikiApp extends StatelessWidget {
  final String? initialRoute;

  const UniWikiApp({super.key, this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniWiki',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute ?? AppRoutes.splash,
      onGenerateInitialRoutes: (routeFromEngine) {
        final startRoute = initialRoute ?? AppRoutes.splash;
        final builder = AppRoutes.routes[startRoute] ?? AppRoutes.routes[AppRoutes.splash]!;
        return [
          MaterialPageRoute(
            builder: builder,
            settings: RouteSettings(name: startRoute),
          ),
        ];
      },
      routes: AppRoutes.routes,
    );
  }
}
