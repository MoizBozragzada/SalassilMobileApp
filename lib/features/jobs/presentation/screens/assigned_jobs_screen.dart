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

/// Opened from the Assigned Jobs tab: a search bar and the jobs the courier
/// currently has in progress.
class AssignedJobsScreen extends ConsumerStatefulWidget {
  const AssignedJobsScreen({super.key});

  @override
  ConsumerState<AssignedJobsScreen> createState() => _AssignedJobsScreenState();
}

class _AssignedJobsScreenState extends ConsumerState<AssignedJobsScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(Job job) {
    if (_query.isEmpty) return true;
    final haystack = [
      job.reference,
      job.area,
      job.address,
      job.accountNumber,
      job.routeCode,
      job.kind,
      job.typeLabel,
    ].join(' ').toLowerCase();
    return haystack.contains(_query);
  }

  void _onAction(Job job, String action) {
    if (action == 'View Details') {
      context.push(AppRoutes.jobDetails, extra: job);
    } else if (action == 'View Progress') {
      context.push(AppRoutes.shipmentView, extra: job);
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsProvider);
    final started = ref.watch(startedJobsProvider);
    final routeCode = ref.watch(driverProfileProvider).value?.routeCode ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FC),
      appBar: JobsAppBar(title: 'Assigned Jobs', routeCode: routeCode),
      body: jobsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AsyncErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(jobsProvider),
        ),
        data: (all) {
          final inProgress = all
              .where((j) =>
                  j.status != JobStatus.completed &&
                  (started.contains(j.reference) ||
                      j.status == JobStatus.inProgress))
              .toList();
          final shown = inProgress.where(_matches).toList();

          return RefreshIndicator(
            onRefresh: () => ref.refresh(jobsProvider.future),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(14),
              children: [
                TextField(
                  controller: _search,
                  textInputAction: TextInputAction.search,
                  onChanged: (v) =>
                      setState(() => _query = v.trim().toLowerCase()),
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search by AWB, booking, area or route',
                    hintStyle: const TextStyle(fontSize: 13),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _search.clear();
                              setState(() => _query = '');
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                if (inProgress.isEmpty)
                  const _Empty(
                    icon: Icons.assignment_outlined,
                    text: 'No jobs assigned yet',
                  )
                else if (shown.isEmpty)
                  const _Empty(
                    icon: Icons.search_off,
                    text: 'No jobs match your search',
                  ),
                for (final job in shown) ...[
                  JobCard(
                    job: job,
                    started: true,
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
}

class _Empty extends StatelessWidget {
  const _Empty({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Icon(icon, size: 44, color: AppColors.hint),
          const SizedBox(height: 10),
          Text(text, style: const TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
