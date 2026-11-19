import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../domain/driver_profile.dart';

class ProfileRepository {
  ProfileRepository(this._client);

  final ApiClient _client;

  Future<DriverProfile> fetchProfile() async {
    try {
      final res = await _client.dio.get(ApiConstants.employee);
      final profile = DriverProfile.tryParse(res.data);
      if (profile == null) {
        // Include the raw body so the real response shape is visible.
        throw ApiException('Unexpected profile response: ${res.data}');
      }
      return profile;
    } on DioException catch (e) {
      throw ApiClient.toApiException(e);
    }
  }
}
