import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/jobs/presentation/screens/completed_jobs_screen.dart';
import '../../features/jobs/domain/job.dart';
import '../../features/jobs/presentation/screens/job_details_screen.dart';
import '../../features/jobs/presentation/screens/jobs_screen.dart';
import '../../features/profile/presentation/screens/driver_profile_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const forgot = '/forgot-password';
  static const home = '/home';
  static const jobs = '/jobs';
  static const completedJobs = '/completed-jobs';
  static const profile = '/profile';
  static const jobDetails = '/jobs/details';
}

GoRouter buildRouter() => GoRouter(
      initialLocation: AppRoutes.splash,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (_, _) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (_, _) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.forgot,
          builder: (_, _) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (_, _) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.jobs,
          builder: (_, _) => const JobsScreen(),
        ),
        GoRoute(
          path: AppRoutes.completedJobs,
          builder: (_, _) => const CompletedJobsScreen(),
        ),
        GoRoute(
          path: AppRoutes.jobDetails,
          // The job is passed as `extra`; fall back to the list if missing
          // (e.g. after the app restores a stale route).
          redirect: (_, state) =>
              state.extra is Job ? null : AppRoutes.jobs,
          builder: (_, state) => JobDetailsScreen(job: state.extra! as Job),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (_, _) => const DriverProfileScreen(),
        ),
      ],
    );
