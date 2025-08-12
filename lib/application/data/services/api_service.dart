import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/constants/api_constants.dart';
import '../../domain/model/PurchaseLogModel.dart';
import '../../domain/model/ReferralUserListModel.dart';
 import '../../presentation/models/get_purchase_stats.dart';
import '../../presentation/models/get_referral_stats.dart';
import '../../presentation/models/get_staking_history.dart';
import '../../presentation/models/token_model.dart';
import '../../presentation/models/user_model.dart';
import '../../presentation/viewmodel/bottom_nav_provider.dart';

class ApiService {

  Future<List<TokenModel>> fetchTokens() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/tokens');
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        print("Using TOken Login :${response.body}");
        return data.map((e) => TokenModel.fromJson(e)).toList();

      } else {
        throw Exception('Failed to load tokens: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse>  login(String username, String password) async  {
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
      print('>> Status Code: ${response.statusCode}');
      print('>> Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = UserModel.fromJson(data['user']);

         print('Login successful. Token: $token');
         print('ETH Address from login: ${user.ethAddress}');



        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', jsonEncode(user.toJson()));
        await prefs.setString('unique_id', user.uniqueId ?? '');


        return LoginResponse(user: user, token: token);
      } else {
        final error = jsonDecode(response.body);
        throw error['message'] ?? 'Login failed';
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

   Future<String> fetchPurchaseReferral() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {

      print('No token found, returning default referral address.');
      return '0x0000000000000000000000000000000000000000';
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('${ApiConstants.baseUrl}/get-purchase-referral');
    print('Fetching purchase referral from: $url');

    try {
      final response = await http.get(url, headers: headers);
      print(">> Raw Response Body (Referral): ${response.body}");
      print(">> Response Status Code (Referral): ${response.statusCode}");

      if (response.statusCode == 200) {

        String responseBody = response.body.trim();

        if (responseBody.startsWith('0x') && responseBody.length == 42) {
          return responseBody;
        } else if (responseBody.isEmpty || responseBody.toLowerCase() == 'not referred by anyone') {

          print('Referral address is empty or "not referred by anyone".');
          return 'Not referred by anyone';
        }
        else {

          print('Unexpected response format for referral address: $responseBody');

          return 'Not referred by anyone';
        }
      } else {
        print('Failed to fetch referral data. Status: ${response.statusCode}, Body: ${response.body}');
         throw Exception('Failed to fetch referral data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching referral: $e');

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

    final url = Uri.parse('${ApiConstants.baseUrl}/get-referral-users?page=1');

    final response = await http.get(url, headers: headers);
    print(">> Raw Response Body: ${response.body}");
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List data = decoded['data'] ?? [];
      return data.map((e) => ReferralUserListModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch referral users: ${response.statusCode}');
    }
  }

  Future<PurchaseStatsModel> fetchPurchaseStats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('${ApiConstants.baseUrl}/get-purchase-stats');

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return PurchaseStatsModel.fromJson(decoded);
    } else {
      throw Exception('Failed to fetch purchase stats');
    }
  }

  Future<ReferralStatsModel> fetchReferralStats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('${ApiConstants.baseUrl}/get-referral-stats');

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return ReferralStatsModel.fromJson(decoded);
    } else {
      throw Exception('Failed to fetch purchase stats');
    }
  }


  Future<LoginResponse> web3Login( BuildContext context,String message, String address, String signature) async {
     // final prefs = await SharedPreferences.getInstance();
    // final refId = prefs.getString('referralId');

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/web3-login'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'message': message,
        'address': address,
        'signature': signature,
        // 'refId': refId,
      }),
    );
    
    

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      final token = data['token'];
      final user = UserModel.fromJson(data['user']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user', jsonEncode(user.toJson()));
      await prefs.setString('firstName', user.name ?? '');
      await prefs.setString('userName', user.username ?? '');
      await prefs.setString('emailAddress', user.email ?? '');
      await prefs.setString('phoneNumber', user.phone ?? '');
      await prefs.setString('ethAddress', user.ethAddress ?? '');
      await prefs.setString('unique_id', user.uniqueId ?? '');
      if(user.image != null && user.image!.isNotEmpty){
        await prefs.setString('profileImage', user.image!);
      }

      final bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);
      bottomNavProvider.setFullName(user.name ?? '');

      print('>> Payload Web3Login statusCode:  ${response.statusCode}');
      print('>> Web3Login Headers:  ${response.headers}');
      print('>> Web3Login Response Body:  ${response.body}');


      return LoginResponse(user: user, token: token);
    } else {
       throw Exception('Failed to login with Web3: ${response.body}');
    }
  }



}

class LoginResponse {
  final UserModel user;
  final String token;

  LoginResponse({required this.user, required this.token});
}
