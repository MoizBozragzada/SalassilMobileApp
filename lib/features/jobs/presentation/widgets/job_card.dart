import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/job.dart';

const jobMaroon = Color(0xFF9B0A30);

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job, required this.onAction});

  final Job job;

  /// Called with the name of the tapped action.
  final void Function(String action) onAction;

  @override
  Widget build(BuildContext context) {
    final isPickup = job.type == JobType.pickup;
    final primaryAction =
        job.status == JobStatus.inProgress ? 'Continue Job' : 'Start Job';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Tag(
                label: isPickup ? 'Pickup' : 'Delivery',
                icon: isPickup
                    ? Icons.inventory_2_outlined
                    : Icons.local_shipping_outlined,
                fg: isPickup ? AppColors.accent : jobMaroon,
                bg: isPickup
                    ? const Color(0xFFE6E9FB)
                    : const Color(0xFFFBE3E8),
              ),
              const SizedBox(width: 6),
              _Tag(
                label: job.statusLabel,
                fg: AppColors.textMuted,
                bg: const Color(0xFFEFEFF8),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            job.referenceLabel,
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          Text(
            job.reference,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2FC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: jobMaroon),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        job.area,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• ${job.zone}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _detailLine(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => onAction(primaryAction),
                    icon: const Icon(Icons.play_arrow_outlined, size: 18),
                    label: Text(
                      primaryAction,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: jobMaroon,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  onPressed: () => onAction('View Details'),
                  icon: const Icon(Icons.visibility_outlined, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFE6E9FB),
                    foregroundColor: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailLine() {
    const base = TextStyle(fontSize: 11, color: AppColors.textMuted);
    final highlight = job.detailHighlight;
    if (highlight == null || !job.detail.contains(highlight)) {
      return Text('${job.kind} • ${job.detail}', style: base);
    }
    return Text.rich(
      TextSpan(
        text: '${job.kind} • ',
        style: base,
        children: [
          TextSpan(
            text: highlight,
            style: const TextStyle(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.fg, required this.bg, this.icon});

  final String label;
  final Color fg;
  final Color bg;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style:
                TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: fg),
          ),
        ],
      ),
    );
  }
}
