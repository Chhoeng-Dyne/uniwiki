import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_major_curriculum.dart';
import '../../../data/models/university_model.dart';

class SideBySideComparisonView extends StatefulWidget {
  final UniversityModel university1;
  final UniversityMajorModel major1;
  final UniversityModel university2;
  final UniversityMajorModel major2;

  const SideBySideComparisonView({
    super.key,
    required this.university1,
    required this.major1,
    required this.university2,
    required this.major2,
  });

  @override
  State<SideBySideComparisonView> createState() => _SideBySideComparisonViewState();
}

class _SideBySideComparisonViewState extends State<SideBySideComparisonView> {
  late UniversityMajorModel _hydrated1;
  late UniversityMajorModel _hydrated2;
  int _selectedSemesterIndex = 0; // 0 = Sem 1, 1 = Sem 2, etc.

  @override
  void initState() {
    super.initState();
    _hydrateData();
  }

  @override
  void didUpdateWidget(covariant SideBySideComparisonView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.university1 != widget.university1 ||
        oldWidget.major1 != widget.major1 ||
        oldWidget.university2 != widget.university2 ||
        oldWidget.major2 != widget.major2) {
      _hydrateData();
    }
  }

  void _hydrateData() {
    _hydrated1 = getHydratedMajorDetails(widget.major1, widget.university1);
    _hydrated2 = getHydratedMajorDetails(widget.major2, widget.university2);
  }

  @override
  Widget build(BuildContext context) {
    final maxSemesters = max(
      _hydrated1.semesters.length,
      _hydrated2.semesters.length,
    );

    final safeSemesterIndex = _selectedSemesterIndex < maxSemesters
        ? _selectedSemesterIndex
        : 0;

    final sem1 = safeSemesterIndex < _hydrated1.semesters.length
        ? _hydrated1.semesters[safeSemesterIndex]
        : null;

    final sem2 = safeSemesterIndex < _hydrated2.semesters.length
        ? _hydrated2.semesters[safeSemesterIndex]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Overview Comparison Cards (University & Major Headers)
        _buildSideBySideHeader(),

        const SizedBox(height: 18),

        // 2. High-level Summary Metrics Comparison (Side-by-side Table/Row)
        _buildMetricComparisonCard(),

        const SizedBox(height: 18),

        // 3. Tuition & Price Comparison Breakdown
        _buildTuitionComparisonSection(sem1, sem2),

        const SizedBox(height: 22),

        // 4. Semester Selector Pill Row
        if (maxSemesters > 0) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Semester Curriculum Breakdown',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(maxSemesters, (index) {
                final isSelected = index == safeSemesterIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('Semester ${index + 1}'),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.dark.withValues(alpha: 0.8),
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.secondary.withValues(alpha: 0.8),
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedSemesterIndex = index);
                      }
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 14),

          // 5. Side-by-Side Courses for Selected Semester
          _buildSideBySideCourses(sem1, sem2, safeSemesterIndex),
        ],

        const SizedBox(height: 20),

        // 6. Career Paths Comparison
        _buildCareerComparisonSection(),
      ],
    );
  }

  Widget _buildSideBySideHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // University 1 / Major 1 (Left Side)
        Expanded(
          child: _buildHeaderCard(
            university: widget.university1,
            major: _hydrated1,
            badgeLabel: 'Program 1',
            badgeColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        // University 2 / Major 2 (Right Side)
        Expanded(
          child: _buildHeaderCard(
            university: widget.university2,
            major: _hydrated2,
            badgeLabel: 'Program 2',
            badgeColor: const Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard({
    required UniversityModel university,
    required UniversityMajorModel major,
    required String badgeLabel,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge & Logo row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeLabel,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Image.asset(
                    university.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppColors.secondary,
                      child: Icon(Icons.school, size: 16, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            major.name,
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            university.name,
            style: TextStyle(
              color: AppColors.dark.withValues(alpha: 0.65),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricComparisonCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildComparisonRow(
            label: 'Degree Type',
            leftValue: _hydrated1.degree,
            rightValue: _hydrated2.degree,
            isFirst: true,
          ),
          _buildComparisonRow(
            label: 'Faculty / School',
            leftValue: _hydrated1.faculty.isNotEmpty ? _hydrated1.faculty : widget.university1.campus,
            rightValue: _hydrated2.faculty.isNotEmpty ? _hydrated2.faculty : widget.university2.campus,
          ),
          _buildComparisonRow(
            label: 'Total Credits',
            leftValue: '${_hydrated1.totalCredits} Credits',
            rightValue: '${_hydrated2.totalCredits} Credits',
          ),
          _buildComparisonRow(
            label: 'Curriculum Length',
            leftValue: '${_hydrated1.semesters.length} Semesters',
            rightValue: '${_hydrated2.semesters.length} Semesters',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow({
    required String label,
    required String leftValue,
    required String rightValue,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: AppColors.secondary.withValues(alpha: 0.4),
                ),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.dark.withValues(alpha: 0.6),
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  leftValue,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 20,
                color: AppColors.secondary.withValues(alpha: 0.7),
              ),
              Expanded(
                child: Text(
                  rightValue,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTuitionComparisonSection(
    SemesterCurriculumModel? sem1,
    SemesterCurriculumModel? sem2,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.secondary.withValues(alpha: 0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payments_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Tuition & Price Comparison',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Left Side Tuition
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'University Estimate',
                        style: TextStyle(
                          color: AppColors.dark.withValues(alpha: 0.5),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _hydrated1.tuitionPerSemester.isNotEmpty
                            ? '${_hydrated1.tuitionPerSemester} / sem'
                            : widget.university1.tuitionLabel,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (sem1 != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Sem ${_selectedSemesterIndex + 1}: ${sem1.tuitionFee}',
                            style: TextStyle(
                              color: AppColors.dark,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Right Side Tuition
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'University Estimate',
                        style: TextStyle(
                          color: AppColors.dark.withValues(alpha: 0.5),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _hydrated2.tuitionPerSemester.isNotEmpty
                            ? '${_hydrated2.tuitionPerSemester} / sem'
                            : widget.university2.tuitionLabel,
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (sem2 != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Sem ${_selectedSemesterIndex + 1}: ${sem2.tuitionFee}',
                            style: TextStyle(
                              color: AppColors.dark,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSideBySideCourses(
    SemesterCurriculumModel? sem1,
    SemesterCurriculumModel? sem2,
    int semIndex,
  ) {
    final courses1 = sem1?.courses ?? [];
    final courses2 = sem2?.courses ?? [];
    final maxCourseCount = max(courses1.length, courses2.length);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subheader: Semester Titles & Credits
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Left: ${sem1 != null ? "${sem1.courses.length} subjects (${sem1.totalCredits} cr)" : "N/A"}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 18,
                  color: AppColors.secondary,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Right: ${sem2 != null ? "${sem2.courses.length} subjects (${sem2.totalCredits} cr)" : "N/A"}',
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Course Subject Pairs
          if (maxCourseCount == 0)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No subjects recorded for this semester.',
                  style: TextStyle(
                    color: AppColors.dark.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: maxCourseCount,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                color: AppColors.secondary.withValues(alpha: 0.4),
              ),
              itemBuilder: (context, index) {
                final c1 = index < courses1.length ? courses1[index] : null;
                final c2 = index < courses2.length ? courses2[index] : null;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left course
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          color: index.isEven
                              ? Colors.white
                              : AppColors.background.withValues(alpha: 0.4),
                          child: c1 != null
                              ? _buildCourseItem(c1, AppColors.primary)
                              : _buildEmptyCourseSlot(),
                        ),
                      ),
                      // Divider line
                      Container(
                        width: 1,
                        color: AppColors.secondary.withValues(alpha: 0.6),
                      ),
                      // Right course
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          color: index.isEven
                              ? Colors.white
                              : AppColors.background.withValues(alpha: 0.4),
                          child: c2 != null
                              ? _buildCourseItem(c2, const Color(0xFF2E7D32))
                              : _buildEmptyCourseSlot(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(CourseSubjectModel course, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                course.code,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${course.credits} cr',
              style: TextStyle(
                color: AppColors.dark.withValues(alpha: 0.6),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          course.name,
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (course.type.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            course.type,
            style: TextStyle(
              color: AppColors.dark.withValues(alpha: 0.45),
              fontSize: 9.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyCourseSlot() {
    return Center(
      child: Text(
        '—',
        style: TextStyle(
          color: AppColors.dark.withValues(alpha: 0.3),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildCareerComparisonSection() {
    final paths1 = _hydrated1.careerPaths;
    final paths2 = _hydrated2.careerPaths;

    if (paths1.isEmpty && paths2.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.work_outline_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Target Career Pathways',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left careers
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: paths1.map((path) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        path,
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 12),
              // Right careers
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: paths2.map((path) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        path,
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
