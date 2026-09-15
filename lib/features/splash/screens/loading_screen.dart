import 'dart:async';
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class LoadingScreen extends StatefulWidget {
  final Duration duration;

  const LoadingScreen({
    super.key,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, _navigateToHome);
  }

  void _navigateToHome() {
    _timer?.cancel();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final imageWidth = (screenSize.width * 0.68).clamp(220.0, 320.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _navigateToHome,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/loading_page.png',
                  width: imageWidth,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school_rounded, size: 72, color: Color(0xFF112D4E)),
                      SizedBox(height: 16),
                      Text(
                        'UNIWIKI',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF112D4E),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF112D4E)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
