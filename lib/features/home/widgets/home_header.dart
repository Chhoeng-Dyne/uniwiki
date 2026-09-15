import 'package:flutter/material.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/app_notification.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSortTap;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;
  final VoidCallback? onClearSearch;
  final bool isSorted;

  const HomeHeader({
    super.key,
    required this.userName,
    this.onProfileTap,
    this.onNotificationTap,
    this.onSortTap,
    this.onSearchChanged,
    this.searchController,
    this.onClearSearch,
    this.isSorted = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasSearchText = searchController?.text.isNotEmpty ?? false;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        // Modern multi-tone royal gradient matching the app palette with high vibrancy and depth
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D233A), // Deep regal navy
            Color(0xFF163E70), // Rich royal sapphire
            Color(0xFF2865AB), // Luminous ocean cobalt
          ],
          stops: [0.0, 0.48, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33112D4E),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Stack(
          children: [
            // Ambient Geometric Shape 1 (Top-right luminous soft orb)
            Positioned(
              top: -50,
              right: -35,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.16),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Ambient Geometric Shape 2 (Bottom-left subtle azure glow)
            Positioned(
              bottom: -40,
              left: -40,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF64B5F6).withValues(alpha: 0.18),
                      const Color(0xFF64B5F6).withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Large Watermark Logo blended into background gradient
            Positioned.fill(
              child: Align(
                alignment: const Alignment(0.0, -0.1),
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.22,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 270,
                      height: 270,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),



            // Main Content Layout (Preserves exact dimensions for content stability)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 52, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: User Avatar Greeting & Notification Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onProfileTap,
                          child: Row(
                            children: [
                              // Frosted Glass Avatar
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.36),
                                      Colors.white.withValues(alpha: 0.12),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.75),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  userName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Notification Button with live reactive badge
                      ValueListenableBuilder<List<AppNotification>>(
                        valueListenable: NotificationService.instance.notificationsListenable,
                        builder: (context, _, _) {
                          final unreadCount = NotificationService.instance.unreadCount;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: onNotificationTap,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.14),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.28),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.notifications_none_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(3.5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF4D4F),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 1.5),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 17,
                                      minHeight: 17,
                                    ),
                                    child: Text(
                                      '$unreadCount',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Tagline
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        'Find your right fit university',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.92),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Search + Sort Row (Clean Floating Inputs)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search_rounded,
                                color: AppColors.primary,
                                size: 21,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  onChanged: onSearchChanged,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.dark,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Search university, major, location...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 13,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              if (hasSearchText)
                                GestureDetector(
                                  onTap: onClearSearch,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 14,
                                      color: AppColors.dark,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: onSortTap,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: isSorted ? AppColors.secondary : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: isSorted
                                ? Border.all(color: Colors.white, width: 1.8)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: isSorted
                                    ? AppColors.primary.withValues(alpha: 0.35)
                                    : Colors.black.withValues(alpha: 0.10),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.sort_rounded,
                                color: isSorted ? AppColors.primary : AppColors.dark,
                                size: 21,
                              ),
                              if (isSorted)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

