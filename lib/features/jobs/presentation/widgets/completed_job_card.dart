import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/completed_job.dart';
import '../../domain/job.dart';
import 'job_card.dart';

const _softBlue = Color(0xFFE6E9FB);
const _softRed = Color(0xFFFBE3E8);
const _infoBox = Color(0xFFF2F2FC);

class CompletedJobCard extends StatelessWidget {
  const CompletedJobCard({super.key, required this.job, required this.onAction});

  final CompletedJob job;
  final void Function(String action) onAction;

  bool get _isException => job.outcome == CompletedOutcome.exception;

  @override
  Widget build(BuildContext context) {
    final isPickup = job.type == JobType.pickup;
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
                bg: isPickup ? _softBlue : _softRed,
              ),
              const SizedBox(width: 6),
              _isException
                  ? const _Tag(
                      label: 'Exception',
                      icon: Icons.error_outline,
                      fg: jobMaroon,
                      bg: _softRed,
                      outlined: true,
                    )
                  : const _Tag(
                      label: 'Delivered',
                      fg: AppColors.textMuted,
                      bg: Color(0xFFEFEFF8),
                    ),
              const Spacer(),
              if (_isException) ...[
                const Icon(Icons.schedule,
                    size: 13, color: AppColors.textMuted),
                const SizedBox(width: 3),
              ],
              Text(
                job.timeText,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isException ? _softRed : _softBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _isException
                      ? Icons.warning_amber_rounded
                      : Icons.verified_outlined,
                  color: _isException ? jobMaroon : AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_isException) ...[
            _location(),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _softRed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_busy, size: 16, color: jobMaroon),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      job.alert ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: jobMaroon,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SoftButton('View Details', Icons.info_outline,
                      () => onAction('View Details')),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SoftButton('Dispatch', Icons.headset_mic_outlined,
                      () => onAction('Dispatch')),
                ),
              ],
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _infoBox,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _location(),
                  if (job.note != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.draw_outlined,
                            size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(
                          job.note!,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                  if (job.paymentLabel != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          job.paymentLabel!,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted),
                        ),
                        if (job.paymentBadge != null)
                          _paymentBadge(job.paymentBadge!)
                        else if (job.paymentValue != null)
                          Text(
                            job.paymentValue!,
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => onAction('View Electronic POD & Receipt'),
                icon: const Icon(Icons.receipt_long_outlined, size: 18),
                label: const Text(
                  'View Electronic POD & Receipt',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: jobMaroon,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _location() {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, size: 16, color: jobMaroon),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            job.area,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '• ${job.zone}',
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }

  /// "SAR 145.00 (POS Card)": the amount is bold, the bracket part is muted.
  Widget _paymentBadge(String text) {
    final split = text.indexOf(' (');
    final amount = split == -1 ? text : text.substring(0, split);
    final method = split == -1 ? '' : text.substring(split);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text.rich(
        TextSpan(
          text: amount,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          children: [
            TextSpan(
              text: method,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.fg,
    required this.bg,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final Color fg;
  final Color bg;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: outlined ? Border.all(color: fg.withValues(alpha: 0.5)) : null,
      ),
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

class _SoftButton extends StatelessWidget {
  const _SoftButton(this.label, this.icon, this.onTap);

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _softBlue,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
