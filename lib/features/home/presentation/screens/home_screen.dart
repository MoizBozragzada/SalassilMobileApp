import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../widgets/driver_card.dart';
import '../widgets/job_summary_tile.dart';

/// Courier dashboard shown after login.
///
/// The driver and job figures are static placeholders until the backend
/// endpoints for them are available.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Salassil Express',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            Text(
              'DASHBOARD',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
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
                radius: 18,
                backgroundColor: AppColors.primary,
                child:
                    Icon(Icons.person_outline, color: Colors.white, size: 20),
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
            name: 'Tariq Mehmood',
            id: 'SE-8842',
            role: 'Master Courier • DXB',
            shift: 'Shift A (07:00-16:00)',
            route: 'RUH-RET-001',
            onDuty: true,
          ),
          const SizedBox(height: 16),
          JobSummaryTile(
            icon: Icons.assignment_outlined,
            title: 'My Jobs',
            subtitle: 'Active delivery routes today',
            highlighted: true,
            onTap: () => context.push(AppRoutes.jobs),
          ),
          const SizedBox(height: 12),
          JobSummaryTile(
            icon: Icons.verified_outlined,
            title: 'Completed Jobs',
            subtitle: 'Deliveries fulfilled today',
            highlighted: false,
            onTap: () => context.push(AppRoutes.completedJobs),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: NavTab.home),
    );
  }
}
