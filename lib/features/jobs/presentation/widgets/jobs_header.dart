import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'job_card.dart';

/// Dark-red app bar shared by the My Jobs and Completed Jobs screens.
class JobsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const JobsAppBar({
    super.key,
    required this.title,
    required this.routeCode,
    this.leadingActions = const [],
  });

  final String title;
  final String routeCode;

  /// Extra buttons shown before the profile avatar.
  final List<Widget> leadingActions;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: jobMaroon,
      foregroundColor: Colors.white,
      centerTitle: false,
      automaticallyImplyLeading: false,
      toolbarHeight: 64,
      titleSpacing: 12,
      title: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () =>
                context.canPop() ? context.pop() : context.go(AppRoutes.home),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, size: 6, color: Color(0xFFFF8FA3)),
                  const SizedBox(width: 4),
                  Text(
                    routeCode,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        ...leadingActions,
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.push(AppRoutes.profile),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF6E0721),
              child: Icon(Icons.person_outline, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}

class RouteCard extends StatelessWidget {
  const RouteCard({super.key, required this.routeCode, required this.subtitle});

  final String routeCode;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFFBE3E8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.alt_route, color: jobMaroon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Route: $routeCode',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.circle, size: 6, color: jobMaroon),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
