import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../profile/domain/driver_profile.dart';
import '../widgets/driver_card.dart';
import '../widgets/job_summary_tile.dart';

const _maroon = Color(0xFF9B0A30);

/// Courier dashboard shown after login.
///
/// Driver details come from the placeholder profile until the backend
/// endpoint is available.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Coming soon')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const p = sampleDriverProfile;
    final initials = '${p.firstName[0]}${p.lastName[0]}'.toUpperCase();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        centerTitle: false,
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        titleSpacing: 12,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.dashboard_outlined, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Dashboard',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 6),
                    Text(
                      '• ${p.routeCode}',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const Text(
                  'Salassil Express Courier',
                  style: TextStyle(fontSize: 10, color: Color(0xFFFFB3C1)),
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
                radius: 18,
                backgroundColor: const Color(0xFF6E0721),
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DriverCard(
            onTap: () => context.push(AppRoutes.profile),
            name: p.fullName,
            id: p.employeeId,
            role: '${p.position} • DXB',
            shift: 'Shift A (07:00-16:00)',
            routeCode: p.routeCode,
            routeName: p.routeName,
            onDuty: p.onDuty,
          ),
          const SizedBox(height: 16),
          JobSummaryTile(
            icon: Icons.assignment_outlined,
            title: 'My Jobs',
            subtitle: 'Active delivery routes today',
            highlighted: true,
            onTap: () => context.push(AppRoutes.jobs),
          ),
          const SizedBox(height: 14),
          JobSummaryTile(
            icon: Icons.verified_outlined,
            title: 'Completed Jobs',
            subtitle: 'Deliveries fulfilled today',
            highlighted: false,
            onTap: () => context.push(AppRoutes.completedJobs),
          ),
          const SizedBox(height: 14),
          JobSummaryTile(
            icon: Icons.bar_chart,
            title: 'Analytics',
            subtitle: 'Performance & trip metrics',
            highlighted: true,
            onTap: () => _comingSoon(context),
          ),
          const SizedBox(height: 14),
          JobSummaryTile(
            icon: Icons.warning_amber_rounded,
            title: 'Report a Problem',
            subtitle: 'Submit issue or vehicle feedback',
            highlighted: false,
            onTap: () => _comingSoon(context),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: NavTab.home),
    );
  }
}
