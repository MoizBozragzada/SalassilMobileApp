import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The logo has white lettering, so it sits on a dark brand banner.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.height = 90});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.brandDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        'assets/images/logo.png',
        height: height,
        semanticLabel: 'Salassil Express',
      ),
    );
  }
}
