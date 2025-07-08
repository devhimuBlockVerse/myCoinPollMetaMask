import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/constants/api_constants.dart';
import '../../domain/model/PurchaseLogModel.dart';
import '../../domain/model/ReferralUserListModel.dart';
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

         print('Login successful. Token: $token');

       print('ETH Address from login: ${user.ethAddress}');



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

  Future<List<PurchaseLogModel>> fetchPurchaseLogs({String? walletAddress}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    print('  Token: $token');
    print('  Wallet address: $walletAddress');



    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
       'Authorization': token != null && token.isNotEmpty ? 'Bearer $token' : '',
    };

    final url = Uri.parse(
      walletAddress != null && walletAddress.isNotEmpty
          ? '${ApiConstants.baseUrl}/get-purchase-logs?page=1&search=$walletAddress'
          : '${ApiConstants.baseUrl}/get-purchase-logs?page=1',
    );

    print('  Request URL: $url');
    print('  Headers: $headers');

    try {
      final response = await http.get(url, headers: headers);
      print('  Response status PurchaseLogModel: ${response.statusCode}');
      print('  Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded['data'];
        if (data == null || data is! List) {
          throw Exception("'data' is missing or not a list");
        }
        return data.map<PurchaseLogModel>((e) => PurchaseLogModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch purchase logs: ${response.statusCode}');
      }
    } catch (e) {
      print('  Error fetching logs: $e');
      rethrow;
    }
  }


   Future<List<ReferralUserListModel>> fetchReferralUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('https://app.mycoinpoll.com/api/v1/get-referral-users?page=1');

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List data = decoded['data'] ?? [];
      return data.map((e) => ReferralUserListModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch referral users: ${response.statusCode}');
    }
  }

}

class LoginResponse {
  final UserModel user;
  final String token;

  LoginResponse({required this.user, required this.token});
}
