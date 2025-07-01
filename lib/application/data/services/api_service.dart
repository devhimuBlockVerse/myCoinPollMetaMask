import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/constants/api_constants.dart';
import '../../presentation/models/get_lessons.dart';
import '../../presentation/models/token_model.dart';
import '../../presentation/models/user_model.dart';

class ApiService {

  Future<LoginResponse> login(String username, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/auth/login');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "username": username,
      "password": password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = UserModel.fromJson(data['user']);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', jsonEncode(user.toJson()));

        return LoginResponse(user: user, token: token);
      } else {
        final error = jsonDecode(response.body);
        throw error['message'] ?? 'Login failed';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TokenModel>> fetchTokens() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/tokens');
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => TokenModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load tokens: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }





}

class LoginResponse {
  final UserModel user;
  final String token;

  LoginResponse({required this.user, required this.token});
}
