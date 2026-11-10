import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../domain/job.dart';
import '../widgets/job_card.dart';

const _crimson = Color(0xFFDC1F3C);

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key, required this.job});

  final Job job;

  bool get _isPickup => job.type == JobType.pickup;

  @override
  Widget build(BuildContext context) {
    final where = _isPickup ? 'Pickup' : 'Delivery';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: false,
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        titleSpacing: 12,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [jobMaroon, _crimson],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () =>
                  context.canPop() ? context.pop() : context.go(AppRoutes.jobs),
              child: const SizedBox(
                width: 36,
                height: 40,
                child: Icon(Icons.chevron_left, size: 30, color: Colors.white),
              ),
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Job Details',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                Text(
                  '${job.reference} • ${job.typeLabel}',
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
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(Icons.person_outline,
                    color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _Section(
            icon: Icons.calendar_month_outlined,
            title: _isPickup ? 'Booking' : 'Shipment',
            titleColor: AppColors.textDark,
            trailing: _StatusChip(job.statusLabel),
            children: [
              _Field(job.referenceLabel, job.reference),
              _Field('ACCOUNT NUMBER', job.accountNumber),
              _Pair(
                _Field('SERVICE CODE', job.serviceCode),
                _Field('DIRECTION', job.direction),
              ),
              _Field('SERVICE SCOPE', job.serviceScope),
            ],
          ),
          const SizedBox(height: 14),
          _Section(
            icon: Icons.location_on_outlined,
            title: where,
            titleColor: jobMaroon,
            children: [
              _Pair(
                _Field('COUNTRY', job.country),
                _Field('CITY', job.city),
              ),
              _Pair(
                _Field('${where.toUpperCase()} AREA', job.areaName),
                _Field('CONTACT NUMBER', job.contactNumber),
              ),
              _Pair(
                _Field('${where.toUpperCase()} DATE', job.date),
                _Field('TIME WINDOW', job.timeWindow),
              ),
              _Field('ADDRESS', job.address),
              _Field('SHORT ADDRESS', job.shortAddress),
            ],
          ),
          const SizedBox(height: 14),
          _Section(
            icon: Icons.inventory_2_outlined,
            title: 'Booking Shipment',
            titleColor: AppColors.textDark,
            children: [
              _Pair(
                _Field('SHIPMENT TYPE', job.shipmentType),
                _Field('PACKAGING TYPE', job.packagingType),
              ),
              _Pair(
                _Field('EXPECTED PACKAGES', job.expectedPackages),
                _Field('EXPECTED SHIPMENT', job.expectedShipment),
              ),
              _Pair(
                _Field('EXPECTED WEIGHT', job.expectedWeight),
                _Field('REMARKS', job.remarks, dot: true),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: NavTab.jobs),
    );
  }
}

/// White card with an icon title, a divider, and spaced children.
class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.titleColor,
    required this.children,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Color titleColor;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: jobMaroon),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFEDEBF7)),
          const SizedBox(height: 14),
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _Pair extends StatelessWidget {
  const _Pair(this.left, this.right);

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value, {this.dot = false});

  final String label;
  final String value;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.5,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
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
                style: const TextStyle(
                    fontSize: 14.5, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.accent,
        ),
      ),
    );
  }
}
