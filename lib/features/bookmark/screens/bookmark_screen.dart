import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/university_model.dart';

class BookmarkScreen extends StatelessWidget {
  final List<UniversityModel> universities;
  final ValueChanged<UniversityModel> onRemoveBookmark;

  const BookmarkScreen({
    super.key,
    required this.universities,
    required this.onRemoveBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 116),
          itemCount: universities.isEmpty ? 4 : universities.length + 3,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Text(
              'Bookmarks',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              );
            }
            if (index == 1) {
              return const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
              'Universities you are keeping an eye on',
              style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              );
            }
            if (index == 2) {
              return const SizedBox(height: 28);
            }
            if (universities.isEmpty) {
              return const _EmptyBookmarks();
            }

            final university = universities[index - 3];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _BookmarkedUniversityCard(
                university: university,
                onRemove: () => onRemoveBookmark(university),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyBookmarks extends StatelessWidget {
  const _EmptyBookmarks();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 112),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 48,
            color: AppColors.primary,
          ),
          SizedBox(height: 18),
          Text(
            'No bookmarks yet',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the bookmark icon on any university\nto save it here for later.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _BookmarkedUniversityCard extends StatelessWidget {
  final UniversityModel university;
  final VoidCallback onRemove;

  const _BookmarkedUniversityCard({
    required this.university,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 142,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              university.imageAsset,
              width: 104,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 104,
                color: AppColors.secondary,
                child: const Icon(Icons.school, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  university.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                _InfoLine(
                  icon: Icons.location_on_outlined,
                  text: university.location,
                ),
                const SizedBox(height: 4),
                _InfoLine(
                  icon: Icons.account_balance_outlined,
                  text: university.campus,
                ),
                const SizedBox(height: 4),
                _InfoLine(
                  icon: Icons.payments_outlined,
                  text: university.tuitionLabel,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            tooltip: 'Remove bookmark',
            icon: const Icon(
              Icons.bookmark_remove_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoLine({
    required this.icon,
    required this.text,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 11),
          ),
        ),
      ],
    );
  }
}
