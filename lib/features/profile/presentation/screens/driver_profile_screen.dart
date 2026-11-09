import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../domain/driver_profile.dart';
import '../widgets/profile_widgets.dart';

const _maroon = Color(0xFF9B0A30);
const _green = Color(0xFF12A36B);

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const p = sampleDriverProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FC),
      appBar: AppBar(
        backgroundColor: _maroon,
        foregroundColor: Colors.white,
        centerTitle: false,
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
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
                const Text('Driver Profile',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                Text(
                  '${p.routeCode} • ${p.routeName}',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF6E0721),
              child: Icon(Icons.person_outline, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _identityCard(p),
          const SizedBox(height: 14),
          _territoryCard(p),
          SectionHeader(
            title: 'PERSONAL INFORMATION',
            trailingText: p.verified ? 'Verified' : null,
            trailingIcon: Icons.check_circle_outline,
            trailingColor: _green,
          ),
          ProfileCard(
            child: Column(
              children: [
                InfoRow(
                  left: InfoTile(
                    icon: Icons.badge_outlined,
                    iconColor: _maroon,
                    label: 'First Name',
                    value: p.firstName,
                  ),
                  right: InfoTile(
                    icon: Icons.badge_outlined,
                    iconColor: _maroon,
                    label: 'Last Name',
                    value: p.lastName,
                  ),
                ),
                const SizedBox(height: 10),
                InfoRow(
                  left: InfoTile(
                    icon: Icons.male,
                    iconColor: AppColors.accent,
                    label: 'Gender',
                    value: p.gender,
                  ),
                  right: InfoTile(
                    icon: Icons.cake_outlined,
                    iconColor: const Color(0xFFE0A100),
                    label: 'Date of Birth',
                    value: p.dateOfBirth,
                  ),
                ),
                const SizedBox(height: 10),
                InfoTile(
                  icon: Icons.location_on_outlined,
                  iconColor: _maroon,
                  label: 'Resident City',
                  value: p.residentCity,
                  trailing: SmallChip(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B7A3E),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          p.countryCode,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SectionHeader(
            title: 'EMPLOYMENT DETAILS',
            trailingText: p.department,
          ),
          ProfileCard(
            child: Column(
              children: [
                InfoRow(
                  left: InfoTile(
                    icon: Icons.tag,
                    iconColor: _maroon,
                    label: 'Employee ID',
                    value: p.employeeId,
                  ),
                  right: InfoTile(
                    icon: Icons.assignment_ind_outlined,
                    iconColor: _green,
                    label: 'Status',
                    value: p.status,
                    valueColor: _maroon,
                  ),
                ),
                const SizedBox(height: 10),
                InfoRow(
                  left: InfoTile(
                    icon: Icons.workspace_premium_outlined,
                    iconColor: const Color(0xFF8E24AA),
                    label: 'Position',
                    value: p.position,
                  ),
                  right: InfoTile(
                    icon: Icons.calendar_today_outlined,
                    iconColor: const Color(0xFF3D5AFE),
                    label: 'Joined Date',
                    value: p.joinedDate,
                  ),
                ),
                const SizedBox(height: 10),
                InfoTile(
                  icon: Icons.warehouse_outlined,
                  iconColor: _maroon,
                  label: 'Base Dispatch Hub',
                  value: p.dispatchHub,
                  trailing: SmallChip(
                    child: Text.rich(
                      TextSpan(
                        text: 'Bay ',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMuted),
                        children: [
                          TextSpan(
                            text: p.hubBay,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: null),
    );
  }

  Widget _identityCard(DriverProfile p) {
    return ProfileCard(
      padding: 16,
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF3C5D0), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.fieldFill,
                  child: Icon(Icons.person, size: 38, color: AppColors.accent),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _pill(
                      p.company,
                      const Color(0xFFEFEFF8),
                      AppColors.textDark,
                      icon: Icons.local_shipping,
                      iconColor: _maroon,
                    ),
                    if (p.onDuty)
                      _pill('On Duty', const Color(0xFFE0F6EC), _green,
                          dot: true),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  p.fullName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      p.position.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _maroon,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      p.employeeId,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color bg, Color fg,
      {IconData? icon, Color? iconColor, bool dot = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Icon(Icons.circle, size: 6, color: fg),
            const SizedBox(width: 4),
          ],
          if (icon != null) ...[
            Icon(icon, size: 12, color: iconColor ?? fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style:
                TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg),
          ),
        ],
      ),
    );
  }

  Widget _territoryCard(DriverProfile p) {
    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _maroon.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.explore_outlined,
                    size: 18, color: _maroon),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ASSIGNED TERRITORY',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      '${p.routeCode} (${p.routeName})',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFF8),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.navigation_outlined,
                    size: 18, color: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Map placeholder until a map provider is chosen.
          Container(
            height: 100,
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE6E6EC), Color(0xFFF4F4F8)],
              ),
            ),
            child: SmallChip(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, size: 7, color: _maroon),
                  const SizedBox(width: 6),
                  Text(
                    p.zone,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
