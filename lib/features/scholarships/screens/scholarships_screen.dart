import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_scholarships.dart';
import '../../../data/models/scholarship_model.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../widgets/apply_scholarship_modal.dart';
import '../widgets/scholarship_card.dart';

enum ScholarshipFilter { all, saved, closingSoon }

enum ScholarshipSort { daysLeftAsc, daysLeftDesc, discountDesc }

class ScholarshipScreen extends StatefulWidget {
  const ScholarshipScreen({super.key});

  @override
  State<ScholarshipScreen> createState() => _ScholarshipScreenState();
}

class _ScholarshipScreenState extends State<ScholarshipScreen> {
  late List<ScholarshipModel> _scholarships;
  ScholarshipFilter _selectedFilter = ScholarshipFilter.all;
  ScholarshipSort _sortOrder = ScholarshipSort.daysLeftAsc;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  bool _showNotificationPopup = false;
  Timer? _popupTimer;

  @override
  void initState() {
    super.initState();
    _scholarships = List<ScholarshipModel>.from(mockScholarships);
  }

  @override
  void dispose() {
    _popupTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSave(String id) {
    setState(() {
      _scholarships = _scholarships.map((item) {
        if (item.id == id) {
          return item.copyWith(isSaved: !item.isSaved);
        }
        return item;
      }).toList();
    });
  }

  void _openApplyModal(ScholarshipModel scholarship) {
    if (scholarship.isApplied) return;
    ApplyScholarshipModal.show(
      context: context,
      scholarship: scholarship,
      onSubmitted: () => _applyForScholarship(scholarship),
    );
  }

  void _applyForScholarship(ScholarshipModel scholarship) {
    if (scholarship.isApplied) return;

    // 1. Mark as applied so user can only apply once
    setState(() {
      _scholarships = _scholarships.map((item) {
        if (item.id == scholarship.id) {
          return item.copyWith(isApplied: true);
        }
        return item;
      }).toList();
    });

    // 2. Send to Notification Service
    NotificationService.instance.addNotification(
      title: 'Application Started: ${scholarship.discountPercent} Grant',
      message:
          'You initiated application for ${scholarship.provider} at ${scholarship.universityName}. Deadline in ${scholarship.daysLeft} days.',
      actionTag: 'scholarship',
    );

    // 3. Show modern confirmation popup for ONLY 5 seconds
    _popupTimer?.cancel();
    setState(() {
      _showNotificationPopup = true;
    });

    _popupTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showNotificationPopup = false;
        });
      }
    });
  }

  void _showSortOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sort Scholarships',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.timer_outlined, color: AppColors.primary),
                  title: const Text('Deadline: Fewest days left first'),
                  trailing: _sortOrder == ScholarshipSort.daysLeftAsc
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _sortOrder = ScholarshipSort.daysLeftAsc);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_month_outlined, color: AppColors.primary),
                  title: const Text('Deadline: Most days left first'),
                  trailing: _sortOrder == ScholarshipSort.daysLeftDesc
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _sortOrder = ScholarshipSort.daysLeftDesc);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.percent_rounded, color: AppColors.primary),
                  title: const Text('Highest Aid / Discount (100% first)'),
                  trailing: _sortOrder == ScholarshipSort.discountDesc
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _sortOrder = ScholarshipSort.discountDesc);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<ScholarshipModel> get _filteredAndSortedScholarships {
    List<ScholarshipModel> list = _scholarships.where((item) {
      // 1. Filter tab
      switch (_selectedFilter) {
        case ScholarshipFilter.all:
          break;
        case ScholarshipFilter.saved:
          if (!item.isSaved) return false;
          break;
        case ScholarshipFilter.closingSoon:
          if (item.daysLeft > 5) return false;
          break;
      }

      // 2. Search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchProvider = item.provider.toLowerCase().contains(query);
        final matchUniversity = item.universityName.toLowerCase().contains(query);
        final matchDiscount = item.discountPercent.toLowerCase().contains(query);
        if (!matchProvider && !matchUniversity && !matchDiscount) {
          return false;
        }
      }

      return true;
    }).toList();

    // 3. Sort order
    list.sort((a, b) {
      switch (_sortOrder) {
        case ScholarshipSort.daysLeftAsc:
          return a.daysLeft.compareTo(b.daysLeft);
        case ScholarshipSort.daysLeftDesc:
          return b.daysLeft.compareTo(a.daysLeft);
        case ScholarshipSort.discountDesc:
          final aNum = int.tryParse(a.discountPercent.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          final bNum = int.tryParse(b.discountPercent.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          return bNum.compareTo(aNum);
      }
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredAndSortedScholarships;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Heading (Centered)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Scholarship Tracker',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Deadlines and aid, all in one place',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search & Sort row (modern round corner style on the same line)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
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
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) => setState(() => _searchQuery = value),
                              decoration: const InputDecoration(
                                hintText: 'Search provider, university, or %',
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Sort Button (Round Corner Modern Style)
                  GestureDetector(
                    onTap: _showSortOptions,
                    child: Container(
                      height: 48,
                      width: 48,
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
                      child: const Icon(
                        Icons.tune_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3 Sort/Filter Round Corner Buttons (All, Saved, Closing Soon)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  _buildFilterButton('All', ScholarshipFilter.all),
                  const SizedBox(width: 10),
                  _buildFilterButton('Saved', ScholarshipFilter.saved),
                  const SizedBox(width: 10),
                  _buildFilterButton('Closing Soon', ScholarshipFilter.closingSoon),
                ],
              ),
            ),

            // Scholarship Cards List
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.school_outlined,
                              size: 34,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'No scholarships found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Try adjusting your search or switch to "All".',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 116),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return ScholarshipCard(
                          scholarship: item,
                          onToggleSave: () => _toggleSave(item.id),
                          onApply: () => _openApplyModal(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
          // Floating 5-Second Modern Notification Popup
          Positioned(
            left: 16,
            right: 16,
            bottom: 96,
            child: AnimatedSlide(
              offset: _showNotificationPopup
                  ? Offset.zero
                  : const Offset(0, 1.4),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: _showNotificationPopup ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: _showNotificationPopup
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.secondary),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dark.withValues(alpha: 0.22),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Application Sent!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Alert added to your notifications.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _popupTimer?.cancel();
                                setState(() => _showNotificationPopup = false);
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const NotificationsScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              child: const Text(
                                'View',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _popupTimer?.cancel();
                                setState(() => _showNotificationPopup = false);
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white70,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, ScholarshipFilter filter) {
    final bool isSelected = _selectedFilter == filter;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = filter;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.secondary,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.dark,
            ),
          ),
        ),
      ),
    );
  }
}
