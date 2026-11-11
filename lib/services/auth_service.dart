
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _api.post(
      '/api/auth/register',
      {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await _api.post(
      '/api/auth/login',
      {
        'email': email,
        'password': password,
      },
    );

    await _saveToken(result['access_token']);

    return result;
  }

  Future<Map<String, dynamic>> googleLogin(
    String idToken,
  ) async {
    final result = await _api.post(
      '/api/auth/google',
      {
        'id_token': idToken,
      },
    );

    await _saveToken(result['access_token']);

    return result;
  }

  Future<void> _saveToken(String token) async {
    await _storage.write(
      key: 'access_token',
      value: token,
    );
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final token = await getToken();

    if (token == null) {
      throw Exception('Please log in again');
    }

    return await _api.get('/api/auth/me', token);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }
}
