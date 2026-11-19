import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../domain/job.dart';

class JobsRepository {
  JobsRepository(this._client);

  final ApiClient _client;

  Future<List<Job>> fetchJobs() async {
    try {
      final res = await _client.dio.get(ApiConstants.jobs);
      final jobs = Job.parseList(res.data);
      if (jobs == null) {
        // Include the raw body so the real response shape is visible.
        throw ApiException('Unexpected jobs response: ${res.data}');
      }
      return jobs;
    } on DioException catch (e) {
      throw ApiClient.toApiException(e);
    }
  }
}
