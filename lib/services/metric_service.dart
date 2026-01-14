import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/configure_global.dart';

class TrainingMetricService {
  /// Creates a new Training Metric
  /// Returns the same object sent to the API
  Future<Map<String, dynamic>> createTrainingMetric({
    required String accessToken,
    required DateTime referenceDate,
    required int effort,
    required int heartBeat,
    required int weight,
    required int sleepTime,
  }) async {
    final url = Uri.parse(
      '${ConfigureGlobal.apiBaseUrl}/api/TrainingMetric',
    );

    final body = {
      'referenceDate': referenceDate.toUtc().toIso8601String(),
      'effort': effort,
      'heartBeat': heartBeat,
      'weight': weight,
      'sleepTime': sleepTime,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // API returns the same object
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token.');
    } else {
      throw Exception(
        'Failed to create TrainingMetric. '
            'Status code: ${response.statusCode} | Body: ${response.body}',
      );
    }
  }
}
