import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum InstitutionType {
  all(
    label: 'All',
    icon: Icons.apps_rounded,
  ),
  publicState(
    label: 'Public',
    icon: Icons.account_balance_rounded,
  ),
  privateUni(
    label: 'Private',
    icon: Icons.domain_rounded,
  ),
  international(
    label: 'International',
    icon: Icons.language_rounded,
  );

  final String label;
  final IconData icon;

  const InstitutionType({
    required this.label,
    required this.icon,
  });
}

class InstitutionTypeSelector extends StatelessWidget {
  final InstitutionType selectedType;
  final ValueChanged<InstitutionType> onTypeChanged;

  const InstitutionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final types = InstitutionType.values;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: types.map((type) {
        final isSelected = selectedType == type;

        return GestureDetector(
          onTap: () => onTypeChanged(type),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 76,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.secondary.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    type.icon,
                    color: isSelected ? Colors.white : AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  type.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
