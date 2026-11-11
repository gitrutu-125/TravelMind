
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android emulator:
  static const String baseUrl = 'http://192.168.43.135:8000';

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    final message = data is Map
        ? data['detail']?.toString() ?? 'Request failed'
        : 'Request failed';

    throw Exception(message);
  }

  Future<Map<String, dynamic>> get(
    String endpoint,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(data);
    }

    final message = data is Map
        ? data['detail']?.toString() ?? 'Request failed'
        : 'Request failed';

    throw Exception(message);
  }
}
