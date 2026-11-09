import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../domain/job.dart';
import '../widgets/job_card.dart';

const _lavender = Color(0xFFF2F2FC);
const _routeName = 'Riyadh Central';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key, required this.job});

  final Job job;

  bool get _isPickup => job.type == JobType.pickup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FC),
      appBar: AppBar(
        backgroundColor: jobMaroon,
        foregroundColor: Colors.white,
        centerTitle: false,
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        titleSpacing: 12,
        title: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () =>
                  context.canPop() ? context.pop() : context.go(AppRoutes.jobs),
              child: const SizedBox(
                width: 36,
                height: 40,
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Job Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                Text(
                  '• ${job.reference} • ${job.typeLabel.toUpperCase()}',
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.push(AppRoutes.profile),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF6E0721),
                child:
                    Icon(Icons.person_outline, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _Tag(
                      job.typeLabel,
                      icon: _isPickup
                          ? Icons.inventory_2_outlined
                          : Icons.local_shipping_outlined,
                    ),
                    const SizedBox(width: 6),
                    _Tag(job.statusLabel),
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
                const SizedBox(height: 2),
                Text(
                  job.reference,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _card(
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBE3E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.alt_route, color: jobMaroon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Route: ${job.routeCode}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.circle, size: 6, color: jobMaroon),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${job.zone} • $_routeName',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.accent),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'SCHEDULE',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 80,
                      child: Text(
                        job.schedule,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: jobMaroon,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _card(_coreDetails()),
          const SizedBox(height: 14),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: NavTab.jobs),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _coreDetails() {
    final dateLabel = _isPickup ? 'PICKUP DATE' : 'DELIVERY DATE';
    final timeLabel = _isPickup ? 'PICKUP TIME' : 'DELIVERY TIME';
    final refShort = _isPickup ? 'BOOKING NO.' : 'AWB NO.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.inventory_2_outlined, size: 20, color: jobMaroon),
            SizedBox(width: 8),
            Text('Core Booking Details',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Field(
                icon: Icons.receipt_long_outlined,
                label: refShort,
                value: job.reference,
                bold: true,
              ),
            ),
            Expanded(
              child: _Field(
                icon: Icons.chat_outlined,
                label: 'BOOKING REMARKS',
                value: job.remarks,
                dot: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _Field(
          icon: Icons.location_city_outlined,
          label: 'CITY NAME',
          value: job.city,
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _lavender,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _Field(
                  icon: Icons.alt_route,
                  label: 'OPERATIONAL ROUTE CODE',
                  value: job.routeCode,
                  bold: true,
                ),
              ),
              Text(
                '${job.zone} • ${job.area.split(',').first}',
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _Field(
                icon: Icons.inventory_outlined,
                label: 'PACKAGING TYPE',
                value: job.packaging,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFF8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                job.packageSummary,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Field(
                icon: Icons.calendar_today_outlined,
                label: dateLabel,
                value: job.date,
              ),
            ),
            Expanded(
              child: _Field(
                icon: Icons.schedule,
                label: timeLabel,
                value: job.time,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const _Label(icon: Icons.support_agent, text: 'ASSIGNED BY'),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _lavender,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: const Color(0xFFD8C8F7),
                child: Text(
                  _initials(job.assignedBy),
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  job.assignedBy,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              Text(
                job.assignedHub,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// "Dispatch Ops - Sarah Al-Mansoor" -> "SA" (first two letters of the
  /// person's name, taken after the dash).
  static String _initials(String text) {
    final name = text.contains('-') ? text.split('-').last.trim() : text.trim();
    final words = name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    return words.take(2).map((w) => w[0].toUpperCase()).join();
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 9,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.icon,
    required this.label,
    required this.value,
    this.bold = false,
    this.dot = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool bold;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(icon: icon, text: label),
        const SizedBox(height: 4),
        Row(
          children: [
            if (dot) ...[
              const Icon(Icons.circle, size: 7, color: jobMaroon),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label, {this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: AppColors.accent),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
