import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final String _baseUrl = dotenv.get('API_URL');

  static Future<void> requestCode(String phone) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/request-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
    if (response.statusCode != 200) throw Exception('Failed to send code');
  }

  static Future<String> verifyCode(String phone, String code) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'code': code}),
    );
    if (response.statusCode != 200) throw Exception('Invalid code');
    final data = jsonDecode(response.body);
    return data['access_token'];
  }
}