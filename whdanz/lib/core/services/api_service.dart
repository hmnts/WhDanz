import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  String? _token;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  String? get token => _token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
        'displayName': displayName,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      if (data['token'] != null) {
        setToken(data['token']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token']);
      }
      return data;
    } else {
      throw ApiException(data['error'] ?? 'Error en el registro');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['token'] != null) {
        setToken(data['token']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token']);
      }
      return data;
    } else {
      throw ApiException(data['error'] ?? 'Credenciales inválidas');
    }
  }

  Future<Map<String, dynamic>> verifyToken() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/verify'),
      headers: _headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      clearToken();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      throw ApiException(data['error'] ?? 'Token inválido');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: _headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw ApiException(data['error'] ?? 'Error al obtener perfil');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? displayName,
    String? bio,
    String? photoURL,
  }) async {
    final Map<String, dynamic> body = {};
    if (displayName != null) body['displayName'] = displayName;
    if (bio != null) body['bio'] = bio;
    if (photoURL != null) body['photoURL'] = photoURL;

    final response = await http.put(
      Uri.parse('$baseUrl/users/profile'),
      headers: _headers,
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw ApiException(data['error'] ?? 'Error al actualizar perfil');
    }
  }

  Future<Map<String, dynamic>> getUser(String uid) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$uid'),
      headers: _headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw ApiException(data['error'] ?? 'Usuario no encontrado');
    }
  }

  Future<void> logout() async {
    clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
