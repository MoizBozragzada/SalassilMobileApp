import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.6, curve: Curves.easeOut),
  );
  late final Animation<double> _scale = Tween<double>(begin: 0.6, end: 1)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  late final Animation<double> _turn = Tween<double>(begin: -0.15, end: 0)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    // Run the animation and the session check together.
    // Every launch starts at the login screen, so drop any saved session.
    await ref.read(authRepositoryProvider).logout();
    await _controller.forward().orCancel;
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandDark,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: RotationTransition(
            turns: _turn,
            child: ScaleTransition(
              scale: _scale,
              child: Image.asset('assets/images/logo.png', width: 220),
            ),
          ),
        ),
      ),
    );
  }
}
