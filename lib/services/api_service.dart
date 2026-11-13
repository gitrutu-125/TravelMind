
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Keep your existing configured IP address.
  static const String baseUrl = 'http://10.214.182.135:8000';

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    late http.Response response;

    try {
      response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      throw Exception(
        'Unable to connect to server. Please check your internet connection and try again.'
      );
    }

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> get(
    String endpoint,
    String token,
  ) async {
    late http.Response response;

    try {
      response = await http
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      throw Exception(
        'Unable to connect to server. Please check your internet connection and try again.'
      );
    }

    return _handleResponse(response);
  }

  // Handle successful and unsuccessful backend responses.
  Map<String, dynamic> _handleResponse(
    http.Response response,
  ) {
    dynamic data;

    try {
      data = jsonDecode(response.body);
    } catch (e) {
      throw Exception('Invalid response received from server.');
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }

      throw Exception('Unexpected response received from server.');
    }

    final message = data is Map
        ? data['detail']?.toString() ?? 'Request failed.'
        : 'Request failed.';

    // Preserve the actual FastAPI validation error.
    throw Exception(message);
  }
}
