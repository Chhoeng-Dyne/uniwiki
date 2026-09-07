import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_categories.dart';
import '../../../data/mock/mock_majors.dart';
import '../../../data/mock/mock_universities.dart';
import '../../../data/models/university_model.dart';
import '../widgets/category_item.dart';
import '../widgets/home_header.dart';
import '../widgets/major_card.dart';
import '../widgets/section_header.dart';
import '../widgets/university_card.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool Function(UniversityModel university) isBookmarked;
  final ValueChanged<UniversityModel> onBookmarkToggle;

  const HomeScreen({
    super.key,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top:
            false, // header handles its own top padding for the gradient to reach the notch
        child: SingleChildScrollView(
          // Keeps the last section above the persistent floating navigation bar.
          padding: const EdgeInsets.only(bottom: 116),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                userName: 'Pu Do',
                onProfileTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
                onNotificationTap: () {},
                onSortTap: () {},
                onSearchChanged: (value) {},
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories
                    SectionHeader(title: 'Categories', onSeeAll: () {}),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 98,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: mockCategories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 18),
                        itemBuilder: (context, index) {
                          return CategoryItem(category: mockCategories[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Popular University
                    SectionHeader(title: 'Popular University', onSeeAll: () {}),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 222,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mockUniversities.length,
                        itemBuilder: (context, index) {
                          return UniversityCard(
                            university: mockUniversities[index],
                            isBookmarked: isBookmarked(mockUniversities[index]),
                            onBookmarkTap: () =>
                                onBookmarkToggle(mockUniversities[index]),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Top Major
                    SectionHeader(title: 'Top Major', onSeeAll: () {}),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 182,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mockMajors.length,
                        itemBuilder: (context, index) {
                          return MajorCard(major: mockMajors[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
