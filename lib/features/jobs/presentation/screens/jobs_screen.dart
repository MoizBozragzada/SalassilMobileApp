import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/async_error_view.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/job.dart';
import '../providers/jobs_provider.dart';
import '../widgets/job_card.dart';
import '../widgets/jobs_header.dart';

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  /// null = all jobs.
  JobType? _filter;

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsProvider);
    final startedJobs = ref.watch(startedJobsProvider);
    final profile = ref.watch(driverProfileProvider).value;
    final routeCode = profile?.routeCode ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FC),
      appBar: JobsAppBar(title: 'My Jobs', routeCode: routeCode),
      body: jobsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AsyncErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(jobsProvider),
        ),
        data: (all) {
          // Completed jobs belong on the Completed Jobs screen.
          final active =
              all.where((j) => j.status != JobStatus.completed).toList();
          final shown = active
              .where((j) => _filter == null || j.type == _filter)
              .toList();
          int count(JobType? t) =>
              active.where((j) => t == null || j.type == t).length;

          return RefreshIndicator(
            onRefresh: () => ref.refresh(jobsProvider.future),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(14),
              children: [
                RouteCard(
                  routeCode: routeCode,
                  subtitle: [
                    if (profile != null && profile.routeName.isNotEmpty)
                      profile.routeName,
                    '${active.length} Active Tasks Today',
                  ].join(' • '),
                ),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _chip('All', null, count(null)),
                      const SizedBox(width: 8),
                      _chip('Pickups', JobType.pickup, count(JobType.pickup)),
                      const SizedBox(width: 8),
                      _chip('Deliveries', JobType.delivery,
                          count(JobType.delivery)),
                    ],
                  ),
                ),
                if (all.length != active.length) ...[
                  const SizedBox(height: 10),
                  Text(
                    '${all.length} jobs received • ${all.length - active.length} '
                    'completed (see Completed Jobs)',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
                const SizedBox(height: 14),
                if (shown.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Column(
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 40, color: AppColors.hint),
                        SizedBox(height: 8),
                        Text('No active jobs',
                            style: TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                for (final job in shown) ...[
                  JobCard(
                    job: job,
                    started: startedJobs.contains(job.reference),
                    onAction: (a) => _onAction(job, a),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(current: NavTab.jobs),
    );
  }

  void _onAction(Job job, String action) {
    if (action == 'View Details') {
      context.push(AppRoutes.jobDetails, extra: job);
    } else if (action == 'Start Job') {
      // Only one job can be in progress at a time.
      final started = ref.read(startedJobsProvider);
      final busy = (ref.read(jobsProvider).value ?? const <Job>[]).any((j) =>
          j.reference != job.reference &&
          j.status != JobStatus.completed &&
          (started.contains(j.reference) || j.status == JobStatus.inProgress));
      if (busy) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Job in progress')));
        return;
      }
      ref.read(startedJobsProvider.notifier).start(job.reference);
      context.push(AppRoutes.shipmentView, extra: job);
    } else if (action == 'View Progress') {
      context.push(AppRoutes.shipmentView, extra: job);
    }
  }

  Widget _chip(String label, JobType? type, int count) {
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
                '$count',
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
