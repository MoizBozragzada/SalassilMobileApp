import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/auth_repository.dart';

final tokenStorageProvider = Provider((ref) => TokenStorage());

final apiClientProvider =
    Provider((ref) => ApiClient(ref.watch(tokenStorageProvider)));

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(tokenStorageProvider),
  ),
);

/// Prefilled email when the user previously ticked "Remember me".
final rememberedEmailProvider = FutureProvider<String?>(
  (ref) => ref.watch(authRepositoryProvider).rememberedEmail(),
);
