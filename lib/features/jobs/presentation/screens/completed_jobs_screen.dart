import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/async_error_view.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/completed_job.dart';
import '../../domain/job.dart';
import '../providers/jobs_provider.dart';
import '../widgets/completed_job_card.dart';
import '../widgets/jobs_header.dart';

class CompletedJobsScreen extends ConsumerStatefulWidget {
  const CompletedJobsScreen({super.key});

  @override
  ConsumerState<CompletedJobsScreen> createState() =>
      _CompletedJobsScreenState();
}

class _CompletedJobsScreenState extends ConsumerState<CompletedJobsScreen> {
  final _search = TextEditingController();
  String _query = '';
  bool _searching = false;

  void _toggleSearch() {
    setState(() {
      _searching = !_searching;
      if (!_searching) {
        _search.clear();
        _query = '';
      }
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(CompletedJob job) {
    if (_query.isEmpty) return true;
    final haystack = [
      job.reference,
      job.area,
      job.zone,
      job.note,
      job.paymentLabel,
      job.paymentValue,
      job.paymentBadge,
      job.alert,
    ].whereType<String>().join(' ').toLowerCase();
    return haystack.contains(_query);
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsProvider);
    final profile = ref.watch(driverProfileProvider).value;
    final routeCode = profile?.routeCode ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FC),
      appBar: JobsAppBar(
        title: 'Completed Jobs',
        routeCode: routeCode,
        leadingActions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _toggleSearch,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: _searching
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.15),
                child: Icon(
                  _searching ? Icons.close : Icons.search,
                  size: 18,
                  color: _searching ? const Color(0xFF9B0A30) : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: jobsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AsyncErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(jobsProvider),
        ),
        data: (all) {
          final completed = [
            for (final j in all)
              if (j.status == JobStatus.completed) CompletedJob.fromJob(j),
          ];
          final jobs = completed.where(_matches).toList();

          return RefreshIndicator(
            onRefresh: () => ref.refresh(jobsProvider.future),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(14),
              children: [
                RouteCard(
                  routeCode: routeCode,
                  subtitle: [
                    if (profile != null && profile.routeName.isNotEmpty)
                      profile.routeName,
                    '${completed.length} Completed Tasks',
                  ].join(' • '),
                ),
                const SizedBox(height: 14),
                if (_searching) ...[
                  TextField(
                    autofocus: true,
                    controller: _search,
                    textInputAction: TextInputAction.search,
                    onChanged: (v) =>
                        setState(() => _query = v.trim().toLowerCase()),
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search by AWB, booking, area or zone',
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
                ],
                if (jobs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off,
                            size: 40, color: AppColors.hint),
                        const SizedBox(height: 8),
                        Text(
                          completed.isEmpty
                              ? 'No completed jobs yet'
                              : 'No completed jobs match your search',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                for (final job in jobs) ...[
                  CompletedJobCard(
                    job: job,
                    onAction: (action) => ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text('$action: ${job.reference}')),
                      ),
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
