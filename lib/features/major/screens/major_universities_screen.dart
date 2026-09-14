import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_universities.dart';
import '../../../data/models/major_model.dart';
import '../../../data/models/university_model.dart';
import 'major_detail_screen.dart';

class UniversityMajorOffering {
  final UniversityModel university;
  final UniversityMajorModel major;

  const UniversityMajorOffering({
    required this.university,
    required this.major,
  });
}

class MajorUniversitiesScreen extends StatelessWidget {
  final MajorModel major;
  final List<UniversityModel> allUniversities;

  const MajorUniversitiesScreen({
    super.key,
    required this.major,
    this.allUniversities = const [],
  });

  /// Resolves all universities that offer this major
  List<UniversityMajorOffering> _findOfferings() {
    final pool = allUniversities.isNotEmpty ? allUniversities : mockUniversities;
    final targetName = major.name.toLowerCase().trim();
    final results = <UniversityMajorOffering>[];

    // Keywords extraction
    final keywords = _extractKeywords(targetName);

    for (final uni in pool) {
      UniversityMajorModel? bestMatch;
      int bestScore = 0;

      for (final m in uni.majors) {
        final mName = m.name.toLowerCase();
        final score = _matchScore(mName, keywords, targetName);
        if (score > bestScore) {
          bestScore = score;
          bestMatch = m;
        }
      }

      if (bestMatch != null && bestScore > 0) {
        results.add(UniversityMajorOffering(
          university: uni,
          major: bestMatch,
        ));
      }
    }

    // Fallback: If no matches found, map to universities in the pool
    if (results.isEmpty) {
      for (final uni in pool.take(4)) {
        final fallbackMajor = uni.majors.isNotEmpty
            ? uni.majors.first
            : UniversityMajorModel(name: major.name);
        results.add(UniversityMajorOffering(
          university: uni,
          major: fallbackMajor,
        ));
      }
    }

    return results;
  }

  List<String> _extractKeywords(String majorName) {
    if (majorName.contains('computer') || majorName.contains('cs')) {
      return ['computer', 'data', 'information', 'computing', 'artificial', 'software'];
    } else if (majorName.contains('software')) {
      return ['software', 'computer', 'digital', 'technology', 'it'];
    } else if (majorName.contains('civil')) {
      return ['civil', 'structural', 'construction'];
    } else if (majorName.contains('medicine')) {
      return ['medicine', 'doctor', 'medical', 'dental', 'pharmacy'];
    } else if (majorName.contains('business')) {
      return ['business', 'management', 'administration', 'marketing', 'entrepreneurship'];
    } else if (majorName.contains('architecture')) {
      return ['architecture', 'architectural', 'urban', 'interior'];
    } else if (majorName.contains('finance') || majorName.contains('banking')) {
      return ['finance', 'banking', 'accounting', 'fintech', 'economics'];
    } else if (majorName.contains('international')) {
      return ['international', 'diplomacy', 'relations', 'affairs'];
    } else if (majorName.contains('design')) {
      return ['design', 'multimedia', 'animation', 'branding', 'fashion'];
    } else if (majorName.contains('tourism')) {
      return ['tourism', 'hospitality', 'hotel', 'eco-tourism'];
    }
    return [majorName];
  }

  int _matchScore(String candidate, List<String> keywords, String target) {
    if (candidate == target) return 100;
    if (candidate.contains(target)) return 80;
    int score = 0;
    for (final kw in keywords) {
      if (candidate.contains(kw)) {
        score += 20;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final offerings = _findOfferings();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Hero Image Banner
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        major.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppColors.secondary,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.school_rounded,
                            color: AppColors.primary,
                            size: 64,
                          ),
                        ),
                      ),
                      // Dark gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.50),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Overlapping White Sheet with Rounded Top Corners
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subtle drag handle
                        Center(
                          child: Container(
                            width: 38,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Major Name Title
                        Text(
                          major.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Subtitle badge
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${offerings.length} Universities Offer This Major',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Helper note
                        Text(
                          'Select any university below to view its specific curriculum, semester courses, and tuition fees for ${major.name}.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.dark.withValues(alpha: 0.75),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 22),

                        // List of Universities Offering the Major
                        const Text(
                          'Offering Universities',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (offerings.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.secondary),
                            ),
                            child: const Center(
                              child: Text(
                                'No universities found for this major at the moment.',
                                style: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: offerings.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final offering = offerings[index];
                              return _UniversityOfferingCard(
                                offering: offering,
                                onTap: () {
                                  // Directly navigate to that major detail screen!
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => MajorDetailScreen(
                                        major: offering.major,
                                        university: offering.university,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Floating Glass Back Button (Top Left)
          Positioned(
            top: topPadding + 10,
            left: 18,
            child: _GlassHeaderButton(
              icon: Icons.arrow_back_ios_new_rounded,
              tooltip: 'Back to Home',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card showing university and its specific program for the major
class _UniversityOfferingCard extends StatelessWidget {
  final UniversityMajorOffering offering;
  final VoidCallback onTap;

  const _UniversityOfferingCard({
    required this.offering,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final uni = offering.university;
    final major = offering.major;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // University Photo Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    uni.imageAsset,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 72,
                      height: 72,
                      color: AppColors.secondary,
                      child: const Icon(
                        Icons.school_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // University details & program title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // University Name
                      Text(
                        uni.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Location Line
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              uni.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Program Title Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          major.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Tuition Pill
                      Text(
                        uni.tuitionLabel,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),

                // Chevron icon
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.primary,
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

/// Glassmorphic circular header back button
class _GlassHeaderButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _GlassHeaderButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.75),
                Colors.white.withValues(alpha: 0.35),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.90),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.dark.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(-1, -1),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                icon,
                color: AppColors.dark,
                size: 20,
              ),
              tooltip: tooltip,
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
