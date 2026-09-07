import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/bookmark/screens/bookmark_screen.dart';
import '../../features/scholarships/screens/scholarships_screen.dart';
import '../../features/comparison/screens/comparison_screen.dart';
import '../../data/mock/mock_universities.dart';
import '../../data/models/university_model.dart';

class MainNavShell extends StatefulWidget {
  const MainNavShell({super.key});

  @override
  State<MainNavShell> createState() => _MainNavShellState();
}

class _MainNavShellState extends State<MainNavShell> {
  int _selectedIndex = 0;
  final Set<String> _bookmarkedUniversityNames = <String>{};

  void _toggleBookmark(UniversityModel university) {
    setState(() {
      if (!_bookmarkedUniversityNames.add(university.name)) {
        _bookmarkedUniversityNames.remove(university.name);
      }
    });
  }

  List<Widget> get _screens {
    final bookmarkedUniversities = mockUniversities
        .where((university) => _bookmarkedUniversityNames.contains(university.name))
        .toList(growable: false);

    return [
      HomeScreen(
        isBookmarked: (university) =>
            _bookmarkedUniversityNames.contains(university.name),
        onBookmarkToggle: _toggleBookmark,
      ),
      BookmarkScreen(
        universities: bookmarkedUniversities,
        onRemoveBookmark: _toggleBookmark,
      ),
      const ScholarshipScreen(),
      const ComparisonScreen(),
    ];
  }

  final List<NavBarItem> _navItems = const [
    NavBarItem(icon: Icons.home_rounded, label: 'Home'),
    NavBarItem(icon: Icons.bookmark_rounded, label: 'Bookmark'),
    NavBarItem(icon: Icons.school_rounded, label: 'Scholarship'),
    NavBarItem(icon: Icons.compare_arrows_rounded, label: 'Compare'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // IndexedStack keeps every page mounted; only the visible body changes.
          Positioned.fill(
            child: IndexedStack(index: _selectedIndex, children: _screens),
          ),
          // This single overlay remains mounted while destinations are changed.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: RepaintBoundary(
                child: CustomBottomNavBar(
                  key: const ValueKey('primary-floating-navigation'),
                  currentIndex: _selectedIndex,
                  onTap: (index) => setState(() => _selectedIndex = index),
                  items: _navItems,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
