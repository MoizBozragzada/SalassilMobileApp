import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/jobs_repository.dart';
import '../../domain/job.dart';

final jobsRepositoryProvider =
    Provider((ref) => JobsRepository(ref.watch(apiClientProvider)));

/// References of jobs the courier has started on this device. The jobs API
/// has no "start" call wired up yet, so this is local and resets when the
/// app restarts or another courier signs in.
class StartedJobsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void start(String reference) => state = {...state, reference};
}

final startedJobsProvider =
    NotifierProvider<StartedJobsNotifier, Set<String>>(StartedJobsNotifier.new);

/// The courier's jobs, reloaded each time a jobs screen is opened so jobs
/// added on the website show up. Also refresh with `ref.invalidate`.
final jobsProvider = FutureProvider.autoDispose<List<Job>>(
  (ref) => ref.watch(jobsRepositoryProvider).fetchJobs(),
);
