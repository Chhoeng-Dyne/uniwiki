import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_majors.dart';
import '../../../data/mock/mock_universities.dart';
import '../../../data/models/university_model.dart';
import '../widgets/home_header.dart';
import '../widgets/institution_type_selector.dart';
import '../widgets/major_card.dart';
import '../widgets/section_header.dart';
import '../widgets/university_card.dart';
import '../../profile/screens/profile_screen.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../../university/screens/university_screen.dart';
import '../../major/screens/major_universities_screen.dart';
import '../../major/screens/all_majors_screen.dart';
import 'all_universities_screen.dart';

enum SortOption {
  recommended('Recommended (Default)', null),
  nameAsc('Name: A to Z', Icons.sort_by_alpha_rounded),
  nameDesc('Name: Z to A', Icons.sort_by_alpha_rounded),
  tuitionLow('Tuition: Low to High', Icons.arrow_upward_rounded),
  tuitionHigh('Tuition: High to Low', Icons.arrow_downward_rounded),
  majorsCount('Most Majors Offered', Icons.school_rounded);

  final String label;
  final IconData? icon;
  const SortOption(this.label, this.icon);
}

class HomeScreen extends StatefulWidget {
  final bool Function(UniversityModel university) isBookmarked;
  final ValueChanged<UniversityModel> onBookmarkToggle;

  const HomeScreen({
    super.key,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  SortOption _selectedSort = SortOption.recommended;
  InstitutionType _selectedInstitutionType = InstitutionType.all;
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Parse dollar value from tuitionLabel for price sorting
  int _parseTuition(String label) {
    try {
      final match = RegExp(r'\$(\d+)').firstMatch(label);
      if (match != null) {
        return int.parse(match.group(1)!);
      }
    } catch (_) {}
    return 0;
  }

  bool _matchesInstitutionType(UniversityModel uni, InstitutionType type) {
    switch (type) {
      case InstitutionType.all:
        return true;
      case InstitutionType.publicState:
        // Public state universities in Cambodia
        final n = uni.name.toLowerCase();
        return n.contains('royal') ||
            n.contains('institute of technology') ||
            n.contains('national university') ||
            n.contains('health sciences') ||
            n.contains('digital technology');
      case InstitutionType.privateUni:
        // Private universities in Cambodia
        final n = uni.name.toLowerCase();
        return n.contains('puthisastra') ||
            n.contains('norton') ||
            n.contains('beltei') ||
            n.contains('paññāsāstra') ||
            n.contains('university of cambodia') ||
            n.contains('kirirom');
      case InstitutionType.international:
        // International universities or foreign dual-degree institutions
        final n = uni.name.toLowerCase();
        return n.contains('international') ||
            n.contains('american') ||
            n.contains('limkokwing') ||
            n.contains('kirirom');
    }
  }

  bool _matchesCategory(UniversityModel uni, String category) {
    if (category == 'All') return true;
    final cat = category.toLowerCase();

    return uni.majors.any((m) {
      final name = m.name.toLowerCase();
      final faculty = m.faculty.toLowerCase();

      if (cat == 'it') {
        return name.contains('computer') || name.contains('software') || name.contains('data') || name.contains('digital') || name.contains('tech');
      } else if (cat == 'business') {
        return name.contains('business') || name.contains('management') || name.contains('marketing') || name.contains('entrepreneurship');
      } else if (cat == 'engineering') {
        return name.contains('engineering') || name.contains('civil') || name.contains('electrical') || name.contains('chemical') || name.contains('architecture');
      } else if (cat == 'health') {
        return name.contains('medicine') || name.contains('doctor') || name.contains('pharmacy') || name.contains('dentistry') || name.contains('nursing') || name.contains('health');
      } else if (cat == 'law') {
        return name.contains('law') || name.contains('legal') || name.contains('governance');
      } else if (cat == 'education') {
        return name.contains('education') || name.contains('teaching') || name.contains('tefl') || name.contains('languages');
      } else if (cat == 'design') {
        return name.contains('design') || name.contains('multimedia') || name.contains('animation') || name.contains('fashion');
      } else if (cat == 'languages') {
        return name.contains('english') || name.contains('language') || name.contains('literature') || name.contains('translation');
      } else if (cat == 'agriculture') {
        return name.contains('agronomy') || name.contains('veterinary') || name.contains('agriculture') || name.contains('forestry') || name.contains('fisheries');
      } else if (cat == 'tourism') {
        return name.contains('tourism') || name.contains('hospitality') || name.contains('hotel');
      }
      return name.contains(cat) || faculty.contains(cat);
    });
  }

  List<UniversityModel> get _processedUniversities {
    // 1. Filter by institution type and category
    var list = mockUniversities
        .where((u) => _matchesInstitutionType(u, _selectedInstitutionType))
        .where((u) => _matchesCategory(u, _selectedCategory))
        .toList();

    // 2. Filter by search query
    final query = _searchQuery.toLowerCase().trim();
    if (query.isNotEmpty) {
      list = list.where((uni) {
        final nameMatches = uni.name.toLowerCase().contains(query);
        final locMatches = uni.location.toLowerCase().contains(query) || uni.address.toLowerCase().contains(query);
        final majorMatches = uni.majors.any((m) => m.name.toLowerCase().contains(query));
        return nameMatches || locMatches || majorMatches;
      }).toList();
    }

    // 3. Apply sorting
    switch (_selectedSort) {
      case SortOption.nameAsc:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.tuitionLow:
        list.sort((a, b) => _parseTuition(a.tuitionLabel).compareTo(_parseTuition(b.tuitionLabel)));
        break;
      case SortOption.tuitionHigh:
        list.sort((a, b) => _parseTuition(b.tuitionLabel).compareTo(_parseTuition(a.tuitionLabel)));
        break;
      case SortOption.majorsCount:
        list.sort((a, b) => b.majors.length.compareTo(a.majors.length));
        break;
      case SortOption.recommended:
        // preserve natural list order
        break;
    }

    return list;
  }

  void _showSortBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
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
              const SizedBox(height: 18),

              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort Universities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  if (_selectedSort != SortOption.recommended)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSort = SortOption.recommended;
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Options
              ...SortOption.values.map((option) {
                final isSelected = _selectedSort == option;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        setState(() {
                          _selectedSort = option;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.10)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: isSelected
                              ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
                              : null,
                        ),
                        child: Row(
                          children: [
                            if (option.icon != null) ...[
                              Icon(
                                option.icon,
                                size: 18,
                                color: isSelected ? AppColors.primary : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Text(
                                option.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? AppColors.primary : AppColors.dark,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 20,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final processedUnis = _processedUniversities;
    final isSearching = _searchQuery.isNotEmpty;
    final isFiltered = _selectedCategory != 'All' ||
        _selectedSort != SortOption.recommended;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false, // header handles its own top padding for gradient
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 116),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with real-time search and sort
              HomeHeader(
                userName: 'Pu Do',
                searchController: _searchController,
                isSorted: _selectedSort != SortOption.recommended,
                onProfileTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
                onNotificationTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
                onSortTap: _showSortBottomSheet,
                onSearchChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                onClearSearch: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Active Filter / Sort Chips Bar
                    if (isFiltered || isSearching) ...[
                      Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  if (_selectedSort != SortOption.recommended)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                        child: _ActiveFilterChip(
                                          label: _selectedSort.label,
                                          icon: _selectedSort.icon ?? Icons.sort_rounded,
                                          onRemove: () {
                                          setState(() {
                                            _selectedSort = SortOption.recommended;
                                          });
                                        },
                                      ),
                                    ),
                                  if (_selectedCategory != 'All')
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: _ActiveFilterChip(
                                        label: 'Category: $_selectedCategory',
                                        icon: Icons.filter_alt_rounded,
                                        onRemove: () {
                                          setState(() {
                                            _selectedCategory = 'All';
                                          });
                                        },
                                      ),
                                    ),
                                  if (isSearching)
                                    _ActiveFilterChip(
                                      label: '"$_searchQuery"',
                                      icon: Icons.search_rounded,
                                      onRemove: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = '';
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _selectedSort = SortOption.recommended;
                                _selectedInstitutionType = InstitutionType.all;
                                _selectedCategory = 'All';
                              });
                            },
                            child: const Text(
                              'Clear All',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // When Searching: Show Search Results directly
                    if (isSearching) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Search Results',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                          ),
                          Text(
                            '${processedUnis.length} found',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      if (processedUnis.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.search_off_rounded, size: 40, color: Colors.grey),
                              const SizedBox(height: 12),
                              Text(
                                'No universities found for "$_searchQuery"',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.dark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Try checking the spelling or searching another major or province.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: processedUnis.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final uni = processedUnis[index];
                            return _SearchResultTile(
                              university: uni,
                              isBookmarked: widget.isBookmarked(uni),
                              onBookmarkTap: () => widget.onBookmarkToggle(uni),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => UniversityScreen(
                                      university: uni,
                                      isBookmarked: widget.isBookmarked(uni),
                                      onBookmarkToggle: widget.onBookmarkToggle,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                    ] else ...[
                      // Normal Home View (Categories, Popular University, Top Major)

                      // 1. Institution Types Segmented Switcher & Category Filter
                      const SectionHeader(
                        title: 'Categories',
                      ),
                      const SizedBox(height: 8),
                      InstitutionTypeSelector(
                        selectedType: _selectedInstitutionType,
                        onTypeChanged: (type) {
                          setState(() {
                            _selectedInstitutionType = type;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // 2. Popular University
                      SectionHeader(
                        title: 'Popular University',
                        onSeeAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => AllUniversitiesScreen(
                                universities: mockUniversities,
                                isBookmarked: widget.isBookmarked,
                                onBookmarkToggle: widget.onBookmarkToggle,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      if (processedUnis.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Center(
                            child: Text(
                              'No universities found for the selected filters',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 222,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: processedUnis.length,
                            itemBuilder: (context, index) {
                              final uni = processedUnis[index];

                              return UniversityCard(
                                university: uni,
                                isBookmarked: widget.isBookmarked(uni),
                                onBookmarkTap: () => widget.onBookmarkToggle(uni),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => UniversityScreen(
                                        university: uni,
                                        isBookmarked: widget.isBookmarked(uni),
                                        onBookmarkToggle: widget.onBookmarkToggle,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 24),

                      // 3. Top Major
                      SectionHeader(
                        title: 'Top Major',
                        onSeeAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const AllMajorsScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 182,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mockMajors.length,
                          itemBuilder: (context, index) {
                            final major = mockMajors[index];

                            return MajorCard(
                              major: major,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => MajorUniversitiesScreen(
                                      major: major,
                                      allUniversities: mockUniversities,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
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

class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onRemove;

  const _ActiveFilterChip({
    required this.label,
    required this.icon,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final UniversityModel university;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.university,
    required this.isBookmarked,
    required this.onBookmarkTap,
    required this.onTap,
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
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    university.imageAsset,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 72,
                      height: 72,
                      color: AppColors.secondary,
                      child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        university.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              university.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        university.tuitionLabel,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                  icon: Icon(
                    isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: isBookmarked ? AppColors.primary : Colors.grey,
                    size: 20,
                  ),
                  onPressed: onBookmarkTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
