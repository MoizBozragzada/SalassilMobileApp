import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../domain/job.dart';
import '../widgets/job_card.dart';
import '../widgets/job_dialogs.dart';

const _red = Color(0xFFDC1F3C);

/// Placeholder consignment figures until the backend provides them.
const _total = 150;
const _inProgress = 45;
const _delivered = 80;
const _pending = 25;

/// Opened by Start Job: consignment summary plus quick actions for the job.
class ShipmentViewScreen extends StatelessWidget {
  const ShipmentViewScreen({super.key, required this.job});

  final Job job;

  void _soon(BuildContext context, String what) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$what: coming soon')));
  }

  Future<void> _exception(BuildContext context) async {
    final result = await showExceptionDialog(context, job);
    // Not sent anywhere yet: there is no exceptions endpoint.
    if (result != null && context.mounted) {
      _soon(context, 'Exception "${result.$1}"');
    }
  }

  Future<void> _endJob(BuildContext context) async {
    final createManifest = await showEndJobDialog(context, job);
    if (createManifest && context.mounted) _soon(context, 'Create manifest');
  }

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
            const Text('Shipment view screen',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
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
          const _StatCard(
            icon: Icons.inventory_2_outlined,
            iconBg: Color(0xFFE6E9FB),
            iconColor: AppColors.accent,
            label: 'TOTAL',
            labelColor: AppColors.textMuted,
            subtitle: 'Total consignments assigned',
            value: _total,
            valueColor: AppColors.textDark,
          ),
          const SizedBox(height: 10),
          const _StatCard(
            icon: Icons.local_shipping_outlined,
            iconBg: Color(0xFFFBE3E8),
            iconColor: jobMaroon,
            label: 'IN PROGRESS',
            labelColor: AppColors.textMuted,
            subtitle: 'Out for delivery / transit',
            value: _inProgress,
            valueColor: AppColors.textMuted,
          ),
          const SizedBox(height: 10),
          const _StatCard(
            icon: Icons.check_circle_outline,
            iconBg: Color(0xFFFBE3E8),
            iconColor: _red,
            label: 'DELIVERED',
            labelColor: _red,
            subtitle: 'Successful proof of POD',
            value: _delivered,
            valueColor: jobMaroon,
          ),
          const SizedBox(height: 10),
          const _StatCard(
            icon: Icons.pending_actions_outlined,
            iconBg: Color(0xFFE6E9FB),
            iconColor: AppColors.accent,
            label: 'PENDING',
            labelColor: AppColors.textMuted,
            subtitle: 'Awaiting hub / client pickup',
            value: _pending,
            valueColor: AppColors.textDark,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 18, 4, 8),
            child: Text(
              'QUICK ACTIONS',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
              ),
            ),
          ),
          _WideAction(
            icon: Icons.qr_code_scanner,
            iconBg: const Color(0xFFE6E9FB),
            iconColor: _red,
            title: 'Scan',
            subtitle: 'Barcode & consignment scan',
            onTap: () => _soon(context, 'Scan'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _HalfAction(
                  icon: Icons.map_outlined,
                  iconBg: const Color(0xFFE6E9FB),
                  iconColor: AppColors.accent,
                  title: 'Map',
                  subtitle: 'Live navigation',
                  onTap: () => context.push(AppRoutes.jobProgress, extra: job),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HalfAction(
                  icon: Icons.info_outline,
                  iconBg: const Color(0xFFE6E9FB),
                  iconColor: AppColors.accent,
                  title: 'View Details',
                  subtitle: 'Consignment log',
                  onTap: () => context.push(AppRoutes.jobDetails, extra: job),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _HalfAction(
                  icon: Icons.edit_note,
                  iconBg: const Color(0xFFFBE3E8),
                  iconColor: jobMaroon,
                  title: 'Create Manifest',
                  subtitle: 'Batch records',
                  onTap: () => _soon(context, 'Create manifest'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HalfAction(
                  icon: Icons.warning_amber_rounded,
                  iconBg: const Color(0xFFFBE3E8),
                  iconColor: _red,
                  title: 'Exception',
                  subtitle: 'Report issue',
                  titleColor: _red,
                  onTap: () => _exception(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _WideAction(
            icon: Icons.outlined_flag,
            iconBg: const Color(0xFFFBE3E8),
            iconColor: _red,
            title: 'End Job',
            subtitle: 'Complete route & submit',
            onTap: () => _endJob(context),
          ),
          const SizedBox(height: 14),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: NavTab.home),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    required this.subtitle,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final String subtitle;
  final int value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          _IconBox(icon: icon, bg: iconBg, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w800,
                    color: labelColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _WideAction extends StatelessWidget {
  const _WideAction({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Card(
      onTap: onTap,
      child: Row(
        children: [
          _IconBox(icon: icon, bg: iconBg, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _HalfAction extends StatelessWidget {
  const _HalfAction({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color? titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Card(
      onTap: onTap,
      padding: 12,
      child: Row(
        children: [
          _IconBox(icon: icon, bg: iconBg, color: iconColor, size: 34),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: titleColor ?? AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({
    required this.icon,
    required this.bg,
    required this.color,
    this.size = 42,
  });

  final IconData icon;
  final Color bg;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, size: size * 0.5, color: color),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.onTap, this.padding = 14});

  final Widget child;
  final VoidCallback? onTap;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: AppColors.accent.withValues(alpha: 0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(padding: EdgeInsets.all(padding), child: child),
      ),
    );
  }
}
