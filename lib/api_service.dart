import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class ApiService {
  static const String baseUrl = "http://localhost:5000";
  
  // User Management Endpoints
  static Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/users"));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => User.fromJson(data)).toList();
      } else {
        _handleErrorResponse(response);
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUsers: $e');
      rethrow;
    }
  }

  // For registration
  static Future<User> registerUser(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password
        }),
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return User.fromJson(jsonResponse['user']);
      } else {
        _handleErrorResponse(response);
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error registering user: $e');
      rethrow;
    }
  }

  // For admin user creation
  static Future<User> addUser(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/users"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password
        }),
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return User.fromJson(jsonResponse['user']);
      } else {
        _handleErrorResponse(response);
        throw Exception('Failed to add user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding user: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        _handleErrorResponse(response);
        final error = json.decode(response.body)['error'] ?? 'Login failed';
        throw Exception(error);
      }
    } catch (e) {
      print('Error logging in: $e');
      rethrow;
    }
  }

  static Future<void> updateUser(int id, String name, String email, [String? password]) async {
    try {
      final body = {
        'name': name,
        'email': email,
        if (password != null && password.isNotEmpty) 'password': password
      };

      final response = await http.put(
        Uri.parse("$baseUrl/users/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  static Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/users/$id"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // Helper method to handle error responses
  static void _handleErrorResponse(http.Response response) {
    if (response.body.startsWith('<!DOCTYPE')) {
      throw Exception('Server error: Received HTML page. Check if backend is running correctly.');
    }
    try {
      final error = json.decode(response.body)['error'];
      if (error != null) {
        throw Exception(error);
      }
    } catch (_) {
      // If we can't parse the error, just throw the status code
      throw Exception('Request failed with status ${response.statusCode}');
    }
  }
}