import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../domain/job.dart';
import '../widgets/job_card.dart';
import '../widgets/jobs_header.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  static const _routeCode = 'RUH-RET-101';

  /// null = all jobs.
  JobType? _filter;

  int _count(JobType? type) =>
      sampleJobs.where((j) => type == null || j.type == type).length;

  @override
  Widget build(BuildContext context) {
    final jobs = sampleJobs.where((j) => _filter == null || j.type == _filter);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FC),
      appBar: const JobsAppBar(
        title: 'My Jobs',
        routeCode: _routeCode,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          RouteCard(
            routeCode: _routeCode,
            subtitle: 'Riyadh Central • ${sampleJobs.length} Active Tasks Today',
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip('All', null),
                const SizedBox(width: 8),
                _chip('Pickups', JobType.pickup),
                const SizedBox(width: 8),
                _chip('Deliveries', JobType.delivery),
              ],
            ),
          ),
          const SizedBox(height: 14),
          for (final job in jobs) ...[
            JobCard(
              job: job,
              onAction: (action) {
                if (action == 'View Details') {
                  context.push(AppRoutes.jobDetails, extra: job);
                  return;
                }
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('$action: ${job.reference}')),
                  );
              },
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: NavTab.jobs),
    );
  }

  Widget _chip(String label, JobType? type) {
    final selected = _filter == type;
    return GestureDetector(
      onTap: () => setState(() => _filter = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? jobMaroon : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textDark,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.25)
                    : const Color(0xFFEFEFF8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_count(type)}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
