import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiService {
  // Health Check
  static Future<bool> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.health}'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get all bins
  static Future<List<dynamic>> getBins() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bins}'),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load bins: ${response.statusCode}');
    }
  }

  // Get bins extended (with fill data)
  static Future<List<dynamic>> getBinsExtended() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.binsExtended}'),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load bins extended: ${response.statusCode}');
    }
  }

  // Get single bin
  static Future<Map<String, dynamic>> getBin(String binId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bins}$binId'),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load bin: ${response.statusCode}');
    }
  }

  // Get measurements for a bin
  static Future<List<dynamic>> getMeasurements({
    String? binId,
    int limit = 100,
  }) async {
    String url =
        '${ApiConstants.baseUrl}${ApiConstants.measurements}?limit=$limit';
    if (binId != null) {
      url += '&bin_id=$binId';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load measurements: ${response.statusCode}');
    }
  }

  // Get latest measurement for a bin
  static Future<Map<String, dynamic>?> getLatestMeasurement(
    String binId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.measurements}$binId/latest',
      ),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 404) {
      return null; // No measurements yet
    } else {
      throw Exception(
        'Failed to load latest measurement: ${response.statusCode}',
      );
    }
  }

  // Create bin
  static Future<Map<String, dynamic>> createBin({
    required String name,
    required double heightCm,
    required String location,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bins}'),
      headers: ApiConstants.headers,
      body: json.encode({
        'name': name,
        'height_cm': heightCm,
        'location': location,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create bin: ${response.statusCode}');
    }
  }

  // Create measurement
  static Future<Map<String, dynamic>> createMeasurement({
    required String binId,
    required double fillPercent,
    required double distanceCm,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.measurements}'),
      headers: ApiConstants.headers,
      body: json.encode({
        'bin_id': binId,
        'fill_percent': fillPercent,
        'distance_cm': distanceCm,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create measurement: ${response.statusCode}');
    }
  }

  // Delete bin
  static Future<bool> deleteBin(String binId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.bins}$binId'),
        headers: ApiConstants.headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
