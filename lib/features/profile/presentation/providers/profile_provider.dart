import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/profile_repository.dart';
import '../../domain/driver_profile.dart';

final profileRepositoryProvider =
    Provider((ref) => ProfileRepository(ref.watch(apiClientProvider)));

/// The signed-in courier's profile, shared by the dashboard and profile
/// screens. Refresh with `ref.invalidate(driverProfileProvider)`.
final driverProfileProvider = FutureProvider<DriverProfile>(
  (ref) => ref.watch(profileRepositoryProvider).fetchProfile(),
);
