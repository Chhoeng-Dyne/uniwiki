import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Text(
            'Comparison',
            style: TextStyle(color: AppColors.dark, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
