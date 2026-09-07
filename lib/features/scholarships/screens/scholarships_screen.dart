import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ScholarshipScreen extends StatelessWidget {
  const ScholarshipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Text(
            'Scholarship',
            style: TextStyle(color: AppColors.dark, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
