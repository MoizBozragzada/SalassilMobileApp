import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class JobSummaryTile extends StatelessWidget {
  const JobSummaryTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.highlighted,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  /// Optional count pill shown before the chevron.
  final String? badge;

  /// Red styling (active jobs) versus purple (completed jobs).
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tint = highlighted ? AppColors.primary : AppColors.accent;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: highlighted ? 3 : 0.5,
      shadowColor: AppColors.accent.withValues(alpha: 0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: tint),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              if (badge != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        highlighted ? AppColors.primary : AppColors.fieldFill,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: highlighted ? Colors.white : AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
