import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class SalassilApp extends StatefulWidget {
  const SalassilApp({super.key});

  @override
  State<SalassilApp> createState() => _SalassilAppState();
}

class _SalassilAppState extends State<SalassilApp> {
  late final GoRouter _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Salassil Express',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
