import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../domain/completed_job.dart';
import '../widgets/completed_job_card.dart';
import '../widgets/jobs_header.dart';

class CompletedJobsScreen extends StatefulWidget {
  const CompletedJobsScreen({super.key});

  @override
  State<CompletedJobsScreen> createState() => _CompletedJobsScreenState();
}

class _CompletedJobsScreenState extends State<CompletedJobsScreen> {
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
    final jobs = sampleCompletedJobs.where(_matches).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FC),
      appBar: JobsAppBar(
        title: 'Completed Jobs',
        routeCode: 'RUH-RET-001',
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
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(14),
        children: [
          RouteCard(
            routeCode: 'RUH-RET-001',
            subtitle:
                'Riyadh Central • ${sampleCompletedJobs.length} Completed Tasks Today',
          ),
          const SizedBox(height: 14),
          if (_searching) ...[
          TextField(
            autofocus: true,
            controller: _search,
            textInputAction: TextInputAction.search,
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 40, color: AppColors.hint),
                  SizedBox(height: 8),
                  Text(
                    'No completed jobs match your search',
                    style: TextStyle(color: AppColors.textMuted),
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
      bottomNavigationBar: const AppBottomNav(current: NavTab.jobs),
    );
  }
}
