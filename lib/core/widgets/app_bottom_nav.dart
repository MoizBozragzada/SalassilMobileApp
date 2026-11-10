import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';

enum NavTab { home, jobs }

/// Bottom bar shared by the main screens. Pass `null` for [current] on
/// screens that belong to no tab (e.g. the driver profile).
class AppBottomNav extends ConsumerWidget {
  const AppBottomNav({super.key, required this.current});

  final NavTab? current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = current != null;
    final onHome = current == NavTab.home;
    return NavigationBar(
      backgroundColor: AppColors.background,
      indicatorColor: Colors.transparent,
      selectedIndex: current?.index ?? 0,
      onDestinationSelected: (i) async {
        if (i == 2) {
          await ref.read(authRepositoryProvider).logout();
          if (context.mounted) context.go(AppRoutes.login);
        } else if (i != current?.index) {
          context.go(i == 0 ? AppRoutes.home : AppRoutes.jobs);
        }
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: active
              ? const Icon(Icons.home, color: AppColors.primary)
              : const Icon(Icons.home_outlined),
          label: 'Home',
        ),
        // The Home design labels this tab "Jobs" with a truck icon; the job
        // screens label it "My Jobs" with a clipboard.
        NavigationDestination(
          icon: Icon(onHome
              ? Icons.local_shipping_outlined
              : Icons.assignment_outlined),
          selectedIcon: const Icon(Icons.assignment, color: AppColors.primary),
          label: onHome ? 'Jobs' : 'My Jobs',
        ),
        const NavigationDestination(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
    );
  }
}
