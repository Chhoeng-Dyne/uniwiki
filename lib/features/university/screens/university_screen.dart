import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_scholarships.dart';
import '../../../data/models/scholarship_model.dart';
import '../../../data/models/university_model.dart';
import '../../major/screens/major_detail_screen.dart';
import '../../scholarships/widgets/apply_scholarship_modal.dart';

class UniversityScreen extends StatefulWidget {
  final UniversityModel university;
  final bool isBookmarked;
  final ValueChanged<UniversityModel> onBookmarkToggle;

  const UniversityScreen({
    super.key,
    required this.university,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  @override
  State<UniversityScreen> createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  late bool _bookmarked;

  @override
  void initState() {
    super.initState();
    _bookmarked = widget.isBookmarked;
  }

  void _handleBookmarkTap() {
    setState(() {
      _bookmarked = !_bookmarked;
    });
    widget.onBookmarkToggle(widget.university);
  }

  ScholarshipModel? get _availableScholarship {
    final uniName = widget.university.name.toLowerCase().trim();
    for (final s in mockScholarships) {
      final sUni = s.universityName.toLowerCase().trim();
      if (sUni == uniName || sUni.contains(uniName) || uniName.contains(sUni)) {
        return s;
      }
    }
    return null;
  }

  void _handleApplyScholarship() {
    final scholarship = _availableScholarship;
    if (scholarship != null) {
      ApplyScholarshipModal.show(
        context: context,
        scholarship: scholarship,
        onSubmitted: () {
          NotificationService.instance.addNotification(
            title: 'Application Started: ${scholarship.discountPercent} Grant',
            message:
                'You initiated application for ${scholarship.provider} at ${scholarship.universityName}. Deadline in ${scholarship.daysLeft} days.',
            actionTag: 'scholarship',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Application submitted for ${scholarship.provider}!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      );
    } else {
      _showUnavailableScholarship();
    }
  }

  void _showUnavailableScholarship() {
    // 1. Send alert to Notification Service
    NotificationService.instance.addNotification(
      title: 'Unavailable Scholarship',
      message: 'No active scholarships are currently available for ${widget.university.name}.',
      actionTag: 'scholarship',
    );

    // 2. Show one-line pop text at the bottom
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text(
              'Unavailable Scholarship',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.dark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final university = widget.university;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable Page Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. University Header Image
                SizedBox(
                  height: 290,
                  width: double.infinity,
                  child: Image.asset(
                    university.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppColors.secondary,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.school,
                        color: AppColors.primary,
                        size: 64,
                      ),
                    ),
                  ),
                ),

                // 2. Overlapping White Container with Rounded Top Corners
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
                        // Subtle drag indicator handle
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

                        // University Name
                        Text(
                          university.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Location Line
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                university.location,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.dark.withValues(alpha: 0.75),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Campus Line
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.account_balance_outlined,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                university.campus,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.dark.withValues(alpha: 0.75),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Tuition Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.payments_outlined,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                university.tuitionLabel,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Apply Scholarship Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _handleApplyScholarship,
                            icon: const Icon(
                              Icons.school_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Apply Scholarship',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 1,
                              shadowColor: AppColors.primary.withValues(alpha: 0.3),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Section 1: Background of the University
                        const Text(
                          'About University',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          university.description.isNotEmpty
                              ? university.description
                              : 'A prestigious higher education institution located in Cambodia dedicated to providing quality academic instruction and industry-ready careers.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: AppColors.dark.withValues(alpha: 0.75),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Section 2: Campus Location & Physical Address
                        const Text(
                          'Location & Campus',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _LocationCard(university: university),
                        const SizedBox(height: 26),

                        // Section 3: Majors Offered
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Offered Majors',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${university.majors.length} Majors',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Major Cards (Round container at the 4 edges)
                        if (university.majors.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.secondary),
                            ),
                            child: const Center(
                              child: Text(
                                'Major information being updated.',
                                style: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: university.majors.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final major = university.majors[index];
                              return _MajorItemCard(
                                major: major,
                                university: university,
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

          // 3. Floating Back Button (Top Left of image)
          Positioned(
            top: topPadding + 10,
            left: 18,
            child: _GlassHeaderButton(
              icon: Icons.arrow_back_ios_new_rounded,
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // 4. Floating Bookmark Button (Top Right of image)
          Positioned(
            top: topPadding + 10,
            right: 18,
            child: _GlassHeaderButton(
              icon: _bookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              iconColor: _bookmarked ? AppColors.primary : AppColors.dark,
              tooltip: _bookmarked ? 'Remove bookmark' : 'Bookmark university',
              onPressed: _handleBookmarkTap,
            ),
          ),
        ],
      ),
    );
  }
}

/// Glassmorphic circular header button for Back and Bookmark actions
class _GlassHeaderButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String tooltip;
  final VoidCallback onPressed;

  const _GlassHeaderButton({
    required this.icon,
    this.iconColor,
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
                color: iconColor ?? AppColors.dark,
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

/// Round container at 4 edges displaying each individual major
class _MajorItemCard extends StatelessWidget {
  final UniversityMajorModel major;
  final UniversityModel university;

  const _MajorItemCard({
    required this.major,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => MajorDetailScreen(
                  major: major,
                  university: university,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                // Leading icon badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),

                // Major Name and Faculty / Degree
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        major.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        major.faculty.isNotEmpty
                            ? '${major.degree} · ${major.faculty}'
                            : major.degree,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Chevron Indicator
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Styled interactive card showing real campus and physical address
class _LocationCard extends StatelessWidget {
  final UniversityModel university;

  const _LocationCard({required this.university});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      university.campus,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      university.location,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dark.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (university.address.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.8)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.navigation_outlined,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      university.address,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.dark.withValues(alpha: 0.85),
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.primary),
                    tooltip: 'Copy full address',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: university.address));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Address copied to clipboard!',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.dark,
                          duration: const Duration(seconds: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

