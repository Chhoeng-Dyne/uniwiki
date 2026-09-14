import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_universities.dart';
import '../../../data/models/university_model.dart';
import '../widgets/major_selection_modal.dart';
import '../widgets/side_by_side_comparison_view.dart';
import '../widgets/university_search_modal.dart';

class ComparisonScreen extends StatefulWidget {
  final UniversityModel? initialUniversity1;
  final UniversityMajorModel? initialMajor1;
  final UniversityModel? initialUniversity2;
  final UniversityMajorModel? initialMajor2;

  const ComparisonScreen({
    super.key,
    this.initialUniversity1,
    this.initialMajor1,
    this.initialUniversity2,
    this.initialMajor2,
  });

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  UniversityModel? _university1;
  UniversityMajorModel? _major1;

  UniversityModel? _university2;
  UniversityMajorModel? _major2;

  bool _isCompared = false;

  @override
  void initState() {
    super.initState();
    _initDefaults();
  }

  void _initDefaults() {
    // Start empty so user chooses by their own, unless explicitly passed via constructor
    if (widget.initialUniversity1 != null) {
      _university1 = widget.initialUniversity1;
      _major1 = widget.initialMajor1 ?? (_university1!.majors.isNotEmpty ? _university1!.majors.first : null);
    }

    if (widget.initialUniversity2 != null) {
      _university2 = widget.initialUniversity2;
      _major2 = widget.initialMajor2 ?? (_university2!.majors.isNotEmpty ? _university2!.majors.first : null);
    }

    if (_university1 != null && _major1 != null && _university2 != null && _major2 != null) {
      _isCompared = true;
    }
  }

  Future<void> _pickUniversity(int slot) async {
    final selectedUni = await UniversitySearchModal.show(
      context: context,
      universities: mockUniversities,
      selectedUniversity: slot == 1 ? _university1 : _university2,
      title: slot == 1 ? 'Select First University' : 'Select Second University',
    );

    if (selectedUni != null) {
      setState(() {
        if (slot == 1) {
          _university1 = selectedUni;
          _major1 = null; // User chooses by their own
        } else {
          _university2 = selectedUni;
          _major2 = null; // User chooses by their own
        }
        // When selection changes, reset comparison until user taps Compare
        _isCompared = false;
      });
    }
  }

  Future<void> _pickMajor(int slot) async {
    final uni = slot == 1 ? _university1 : _university2;
    if (uni == null || uni.majors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select University $slot first!'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final selectedMajor = await MajorSelectionModal.show(
      context: context,
      university: uni,
      selectedMajor: slot == 1 ? _major1 : _major2,
      title: slot == 1 ? 'Select Major 1' : 'Select Major 2',
    );

    if (selectedMajor != null) {
      setState(() {
        if (slot == 1) {
          _major1 = selectedMajor;
        } else {
          _major2 = selectedMajor;
        }
        // When selection changes, reset comparison until user taps Compare
        _isCompared = false;
      });
    }
  }

  void _swapUniversities() {
    if (_university1 == null && _university2 == null) return;
    setState(() {
      final tempUni = _university1;
      final tempMajor = _major1;

      _university1 = _university2;
      _major1 = _major2;

      _university2 = tempUni;
      _major2 = tempMajor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final canCompare = _university1 != null &&
        _major1 != null &&
        _university2 != null &&
        _major2 != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered Header title
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'University & Major Compare',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Compare courses, subjects & semester tuition side-by-side',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.dark.withValues(alpha: 0.55),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Dual Selection Panel
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // University 1 Selection Card
                      Expanded(
                        child: _buildSelectorCard(
                          slotNumber: 1,
                          university: _university1,
                          major: _major1,
                          accentColor: AppColors.primary,
                          onPickUniversity: () => _pickUniversity(1),
                          onPickMajor: () => _pickMajor(1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // University 2 Selection Card
                      Expanded(
                        child: _buildSelectorCard(
                          slotNumber: 2,
                          university: _university2,
                          major: _major2,
                          accentColor: const Color(0xFF2E7D32),
                          onPickUniversity: () => _pickUniversity(2),
                          onPickMajor: () => _pickMajor(2),
                        ),
                      ),
                    ],
                  ),

                  // Floating Swap Button
                  Positioned(
                    top: 56,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 4,
                      shadowColor: AppColors.dark.withValues(alpha: 0.25),
                      child: InkWell(
                        onTap: _swapUniversities,
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.secondary,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.swap_horiz_rounded,
                            size: 22,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Compare Action Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: canCompare
                      ? () {
                          setState(() => _isCompared = true);
                        }
                      : null,
                  icon: const Icon(
                    Icons.analytics_rounded,
                    size: 20,
                  ),
                  label: const Text(
                    'Compare Majors',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.secondary.withValues(alpha: 0.6),
                    disabledForegroundColor: AppColors.dark.withValues(alpha: 0.4),
                    elevation: canCompare ? 3 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Comparison Results View or Empty Placeholder
              if (_isCompared && canCompare) ...[
                SideBySideComparisonView(
                  key: ValueKey('${_university1!.name}_${_major1!.name}_${_university2!.name}_${_major2!.name}'),
                  university1: _university1!,
                  major1: _major1!,
                  university2: _university2!,
                  major2: _major2!,
                ),
              ] else ...[
                _buildEmptyComparisonState(canCompare),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorCard({
    required int slotNumber,
    required UniversityModel? university,
    required UniversityMajorModel? major,
    required Color accentColor,
    required VoidCallback onPickUniversity,
    required VoidCallback onPickMajor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: university != null
              ? accentColor.withValues(alpha: 0.4)
              : AppColors.secondary.withValues(alpha: 0.7),
          width: university != null ? 1.5 : 1,
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
          // Slot label
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Side $slotNumber',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // University Selection Button
          InkWell(
            onTap: onPickUniversity,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.6),
                ),
              ),
              child: Row(
                children: [
                  if (university != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Image.asset(
                          university.imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.school_rounded,
                            size: 18,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        university.name,
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: accentColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Select University',
                        style: TextStyle(
                          color: AppColors.dark.withValues(alpha: 0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppColors.dark.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Major Selection Button
          InkWell(
            onTap: onPickMajor,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: university != null
                    ? AppColors.background
                    : AppColors.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.6),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 18,
                    color: university != null
                        ? accentColor
                        : AppColors.dark.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      major != null ? major.name : 'Select Major',
                      style: TextStyle(
                        color: major != null
                            ? AppColors.dark
                            : AppColors.dark.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: major != null ? FontWeight.w700 : FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppColors.dark.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyComparisonState(bool canCompare) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.compare_arrows_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select Universities & Majors',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              canCompare
                  ? 'Tap "Compare Majors" above to view side-by-side subjects and semester tuition.'
                  : 'Select a university and major for both sides above, then tap "Compare Majors" to view side-by-side subjects and semester tuition.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.dark.withValues(alpha: 0.55),
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
