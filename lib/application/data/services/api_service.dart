import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../clarity/clarity_api_logger.dart';
import '../../../logrocket/logrocket_utils.dart';
import '../../../main.dart' hide logRocketTrackApiEvent;
import '../../../sentry/sentry.dart';
import '../../domain/constants/api_constants.dart';
import '../../domain/model/PurchaseLogModel.dart';
import '../../domain/model/ReferralUserListModel.dart';
import '../../presentation/models/eCommerce_model.dart';
import '../../presentation/models/get_purchase_stats.dart';
import '../../presentation/models/get_referral_stats.dart';
import '../../presentation/models/get_referral_user.dart';
import '../../presentation/models/token_model.dart';
import '../../presentation/models/user_model.dart';
import '../../presentation/viewmodel/bottom_nav_provider.dart';


// class ApiService {
//
//   Future<List<TokenModel>> fetchTokens() async {
//     final url = Uri.parse('${ApiConstants.baseUrl}/tokens');
//     final headers = {
//       'Content-Type': 'application/json',
//     };
//
//     try {
//       final response = await http.get(url, headers: headers);
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//
//         print("Using TOken Login :${response.body}");
//         return data.map((e) => TokenModel.fromJson(e)).toList();
//
//       } else {
//         throw Exception('Failed to load tokens: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<LoginResponse>  login(String username, String password) async  {
//     final url = Uri.parse('${ApiConstants.baseUrl}/auth/login');
//     final headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//     };
//     final body = jsonEncode({
//       "username": username,
//       "password": password,
//     });
//
//     try {
//       final response = await http.post(url, headers: headers, body: body);
//       print('>> Status Code: ${response.statusCode}');
//       print('>> Response Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final token = data['token'];
//         final user = UserModel.fromJson(data['user']);
//
//          print('Login successful. Token: $token');
//          print('ETH Address from login: ${user.ethAddress}');
//
//
//
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', token);
//         await prefs.setString('user', jsonEncode(user.toJson()));
//         await prefs.setString('unique_id', user.uniqueId ?? '');
//
//
//         return LoginResponse(user: user, token: token);
//       } else {
//         final error = jsonDecode(response.body);
//         throw error['message'] ?? 'Login failed';
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<TokenDetails> fetchTokenDetails(String slug) async {
//     final url = Uri.parse('${ApiConstants.baseUrl}/token/$slug');
//     final headers = {'Content-Type': 'application/json'};
//
//     try {
//       final response = await http.get(url, headers: headers);
//       if (response.statusCode == 200) {
//          return tokenDetailsFromJson(response.body);
//       } else {
//         throw Exception('Failed to load token details: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//        rethrow;
//     }
//   }
//
//   Future<List<PurchaseLogModel>> fetchPurchaseLogs({String? walletAddress}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     print('  Token: $token');
//     print('  Wallet address: $walletAddress');
//
//
//
//     final headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//        'Authorization': token != null && token.isNotEmpty ? 'Bearer $token' : '',
//     };
//
//     final url = Uri.parse(
//       walletAddress != null && walletAddress.isNotEmpty
//           ? '${ApiConstants.baseUrl}/get-purchase-logs?page=1&search=$walletAddress'
//           : '${ApiConstants.baseUrl}/get-purchase-logs?page=1',
//     );
//
//
//     try {
//       final response = await http.get(url, headers: headers);
//
//
//       if (response.statusCode == 200) {
//         final decoded = json.decode(response.body);
//         final data = decoded['data'];
//         if (data == null || data is! List) {
//           throw Exception("'data' is missing or not a list");
//         }
//         return data.map<PurchaseLogModel>((e) => PurchaseLogModel.fromJson(e)).toList();
//       } else {
//         throw Exception('Failed to fetch purchase logs: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('  Error fetching logs: $e');
//       rethrow;
//     }
//   }
//
//    Future<String> fetchPurchaseReferral() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     if (token == null || token.isEmpty) {
//       return '0x0000000000000000000000000000000000000000';
//     }
//
//     final headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/get-purchase-referral');
//
//     try {
//       final response = await http.get(url, headers: headers);
//
//       if (response.statusCode == 200) {
//
//         String responseBody = response.body.trim();
//
//         if (responseBody.startsWith('0x') && responseBody.length == 42) {
//           return responseBody;
//         } else if (responseBody.isEmpty || responseBody.toLowerCase() == 'not referred by anyone') {
//
//            return 'Not referred by anyone';
//         }
//         else {
//           return 'Not referred by anyone';
//         }
//       } else {
//          throw Exception('Failed to fetch referral data: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//    Future<List<ReferralUserListModel>> fetchAllReferralUsers() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     final headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//       if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
//     };
//
//     List<ReferralUserListModel> allUsers = [];
//     int page = 1;
//     int lastPage = 1;
//
//     do{
//       final url = Uri.parse('${ApiConstants.baseUrl}/get-referral-users?page=$page');
//
//       final response = await http.get(url,headers: headers);
//       if(response.statusCode == 200) {
//         final decoded = json.decode(response.body);
//         final List data = decoded['data'] ?? [];
//
//         allUsers.addAll(data.map((e) => ReferralUserListModel.fromJson(e)).toList());
//         lastPage = decoded['last_page'] ?? 1;
//         page++;
//
//       }else{
//         throw Exception('Failed to fetch referral users: ${response.statusCode}');
//       }
//     } while (page <= lastPage);
//
//     return allUsers;
//   }
//
//   Future<PurchaseStatsModel> fetchPurchaseStats() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/get-purchase-stats');
//
//     final response = await http.get(url, headers: headers);
//     if (response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       return PurchaseStatsModel.fromJson(decoded);
//     } else {
//       throw Exception('Failed to fetch purchase stats');
//     }
//   }
//
//   Future<ReferralStatsModel> fetchReferralStats() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/get-referral-stats');
//
//     final response = await http.get(url, headers: headers);
//     if (response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       return ReferralStatsModel.fromJson(decoded);
//     } else {
//       throw Exception('Failed to fetch purchase stats');
//     }
//   }
//
//   Future<String> fetchTokenBalanceHuman(String contractAddress, String walletAddress, {int decimals = 18}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token') ?? '';
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/token-balance/$contractAddress/$walletAddress');
//     final headers = {
//       'Accept': 'application/json',
//       if (token.isNotEmpty) 'Authorization': 'Bearer $token',
//     };
//
//     final response = await http.get(url, headers: headers);
//
//     if (response.statusCode == 401 || response.statusCode == 403) {
//       return '0';
//     }
//     if (response.statusCode != 200) {
//       throw Exception('Failed to fetch token balance: ${response.statusCode}');
//     }
//
//     final data = jsonDecode(response.body) as Map<String, dynamic>;
//     final raw = BigInt.parse(data['balance'].toString());
//     final divisor = BigInt.from(10).pow(decimals);
//
//     final integer = raw ~/ divisor;
//     final fraction = (raw % divisor).toString().padLeft(decimals, '0').replaceFirst(RegExp(r'0+$'), '');
//     final human = fraction.isEmpty ? integer.toString() : '$integer.$fraction';
//     print('[TokenBalance] -> parsed: { raw: $raw, human: $human }');
//     return human;
//   }
//
//   Future<Map<String, dynamic>> fetchUserVestingStatus(String userId) async {
//     // Mock for testing
//     await Future.delayed(const Duration(milliseconds: 500));
//     return {
//       'hasStartedSleepPeriod': false,
//       'hasSleepPeriodEnded': false,
//     };
//   }
//
//   Future<void> updateUserVestingStatus(String userId, Map<String, dynamic> status) async {
//     // Mock for testing
//     await Future.delayed(const Duration(milliseconds: 500));
//     print("Mock: Updated vesting status for user $userId: $status");
//   }
//
//   Future<LoginResponse> web3Login( BuildContext context,String message, String address, String signature) async {
//      // final prefs = await SharedPreferences.getInstance();
//     // final refId = prefs.getString('referralId');
//
//     final response = await http.post(
//       Uri.parse('${ApiConstants.baseUrl}/auth/web3-login'),
//       headers: {
//         'Content-Type': 'application/json'
//       },
//       body: jsonEncode({
//         'message': message,
//         'address': address,
//         'signature': signature,
//         // 'refId': refId,
//       }),
//     );
//
//
//
//     if (response.statusCode == 200) {
//
//       final data = jsonDecode(response.body);
//       final token = data['token'];
//       final user = UserModel.fromJson(data['user']);
//
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', token);
//       await prefs.setString('user', jsonEncode(user.toJson()));
//       await prefs.setString('firstName', user.name ?? '');
//       await prefs.setString('userName', user.username ?? '');
//       await prefs.setString('emailAddress', user.email ?? '');
//       await prefs.setString('phoneNumber', user.phone ?? '');
//       await prefs.setString('ethAddress', user.ethAddress ?? '');
//       await prefs.setString('unique_id', user.uniqueId ?? '');
//       if(user.image != null && user.image!.isNotEmpty){
//         await prefs.setString('profileImage', user.image!);
//       }
//
//       await prefs.setString('auth_method', 'web3');
//       final bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);
//       bottomNavProvider.setFullName(user.name ?? '');
//
//       return LoginResponse(user: user, token: token);
//     } else {
//        throw Exception('Failed to login with Web3: ${response.body}');
//     }
//   }
//
//   Future<bool> submitUserFeedback({
//     required String message,
//     required String username,
//     List<String>? base64Images,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/user-app-feedback');
//     final headers = {
//       'Accept': 'application/json',
//       if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     };
//
//     final body = jsonEncode({
//       'message': message,
//       'username': username,
//       if (base64Images != null && base64Images.isNotEmpty) 'images': base64Images,
//     });
//
//     final response = await http.post(url, headers: headers, body: body);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return true;
//     } else {
//       print("Feedback API error: ${response.body}");
//       throw Exception("Failed to submit feedback");
//     }
//   }
//
// }
/// With Sentry
// class ApiService {
//
//   Future<List<TokenModel>> fetchTokens() async {
//     final url = Uri.parse('${ApiConstants.baseUrl}/tokens');
//     final headers = {
//       'Content-Type': 'application/json',
//     };
//
//     try {
//       final response = await SentryApiLogger.get(url, headers: headers);
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//
//         print("Using Token Login :${response.body}");
//         return data.map((e) => TokenModel.fromJson(e)).toList();
//
//       } else {
//         throw Exception('Failed to load tokens: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<LoginResponse>  login(String username, String password) async  {
//     final url = Uri.parse('${ApiConstants.baseUrl}/auth/login');
//     final headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//     };
//     final body = jsonEncode({
//       "username": username,
//       "password": password,
//     });
//
//     try {
//       final response = await SentryApiLogger.post(url, headers: headers, body: body);
//       print('>> Status Code: ${response.statusCode}');
//       print('>> Response Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final token = data['token'];
//         final user = UserModel.fromJson(data['user']);
//
//          print('Login successful. Token: $token');
//          print('ETH Address from login: ${user.ethAddress}');
//
//
//
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', token);
//         await prefs.setString('user', jsonEncode(user.toJson()));
//         await prefs.setString('unique_id', user.uniqueId ?? '');
//
//
//         return LoginResponse(user: user, token: token);
//       } else {
//         final error = jsonDecode(response.body);
//         throw error['message'] ?? 'Login failed';
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<TokenDetails> fetchTokenDetails(String slug) async {
//     final url = Uri.parse('${ApiConstants.baseUrl}/token/$slug');
//     final headers = {'Content-Type': 'application/json'};
//
//     try {
//       final response = await SentryApiLogger.get(url, headers: headers);
//       if (response.statusCode == 200) {
//          return tokenDetailsFromJson(response.body);
//       } else {
//         throw Exception('Failed to load token details: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//        rethrow;
//     }
//   }
//
//   Future<List<PurchaseLogModel>> fetchPurchaseLogs({String? walletAddress}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     print('  Token: $token');
//     print('  Wallet address: $walletAddress');
//
//
//
//     final headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//        'Authorization': token != null && token.isNotEmpty ? 'Bearer $token' : '',
//     };
//
//     final url = Uri.parse(
//       walletAddress != null && walletAddress.isNotEmpty
//           ? '${ApiConstants.baseUrl}/get-purchase-logs?page=1&search=$walletAddress'
//           : '${ApiConstants.baseUrl}/get-purchase-logs?page=1',
//     );
//
//
//     try {
//       final response = await SentryApiLogger.get(url, headers: headers);
//
//
//       if (response.statusCode == 200) {
//         final decoded = json.decode(response.body);
//         final data = decoded['data'];
//         if (data == null || data is! List) {
//           throw Exception("'data' is missing or not a list");
//         }
//         return data.map<PurchaseLogModel>((e) => PurchaseLogModel.fromJson(e)).toList();
//       } else {
//         throw Exception('Failed to fetch purchase logs: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('  Error fetching logs: $e');
//       rethrow;
//     }
//   }
//
//    Future<String> fetchPurchaseReferral() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     if (token == null || token.isEmpty) {
//       return '0x0000000000000000000000000000000000000000';
//     }
//
//     final headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/get-purchase-referral');
//
//     try {
//       final response = await SentryApiLogger.get(url, headers: headers);
//
//       if (response.statusCode == 200) {
//
//         String responseBody = response.body.trim();
//
//         if (responseBody.startsWith('0x') && responseBody.length == 42) {
//           return responseBody;
//         } else if (responseBody.isEmpty || responseBody.toLowerCase() == 'not referred by anyone') {
//
//            return 'Not referred by anyone';
//         }
//         else {
//           return 'Not referred by anyone';
//         }
//       } else {
//          throw Exception('Failed to fetch referral data: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//    Future<List<ReferralUserListModel>> fetchAllReferralUsers() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     final headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//       if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
//     };
//
//     List<ReferralUserListModel> allUsers = [];
//     int page = 1;
//     int lastPage = 1;
//
//     do{
//       final url = Uri.parse('${ApiConstants.baseUrl}/get-referral-users?page=$page');
//
//       final response = await SentryApiLogger.get(url,headers: headers);
//       if(response.statusCode == 200) {
//         final decoded = json.decode(response.body);
//         final List data = decoded['data'] ?? [];
//
//         allUsers.addAll(data.map((e) => ReferralUserListModel.fromJson(e)).toList());
//         lastPage = decoded['last_page'] ?? 1;
//         page++;
//
//       }else{
//         throw Exception('Failed to fetch referral users: ${response.statusCode}');
//       }
//     } while (page <= lastPage);
//
//     return allUsers;
//   }
//
//   Future<PurchaseStatsModel> fetchPurchaseStats() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/get-purchase-stats');
//
//     final response = await SentryApiLogger.get(url, headers: headers);
//     if (response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       return PurchaseStatsModel.fromJson(decoded);
//     } else {
//       throw Exception('Failed to fetch purchase stats');
//     }
//   }
//
//   Future<ReferralStatsModel> fetchReferralStats() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/get-referral-stats');
//
//     final response = await SentryApiLogger.get(url, headers: headers);
//     if (response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       return ReferralStatsModel.fromJson(decoded);
//     } else {
//       throw Exception('Failed to fetch purchase stats');
//     }
//   }
//
//   Future<String> fetchTokenBalanceHuman(String contractAddress, String walletAddress, {int decimals = 18}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token') ?? '';
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/token-balance/$contractAddress/$walletAddress');
//     final headers = {
//       'Accept': 'application/json',
//       if (token.isNotEmpty) 'Authorization': 'Bearer $token',
//     };
//
//     final response = await SentryApiLogger.get(url, headers: headers);
//
//     if (response.statusCode == 401 || response.statusCode == 403) {
//       return '0';
//     }
//     if (response.statusCode != 200) {
//       throw Exception('Failed to fetch token balance: ${response.statusCode}');
//     }
//
//     final data = jsonDecode(response.body) as Map<String, dynamic>;
//     final raw = BigInt.parse(data['balance'].toString());
//     final divisor = BigInt.from(10).pow(decimals);
//
//     final integer = raw ~/ divisor;
//     final fraction = (raw % divisor).toString().padLeft(decimals, '0').replaceFirst(RegExp(r'0+$'), '');
//     final human = fraction.isEmpty ? integer.toString() : '$integer.$fraction';
//     print('[TokenBalance] -> parsed: { raw: $raw, human: $human }');
//     return human;
//   }
//
//   Future<Map<String, dynamic>> fetchUserVestingStatus(String userId) async {
//     // Mock for testing
//     await Future.delayed(const Duration(milliseconds: 500));
//     return {
//       'hasStartedSleepPeriod': false,
//       'hasSleepPeriodEnded': false,
//     };
//   }
//
//   Future<void> updateUserVestingStatus(String userId, Map<String, dynamic> status) async {
//     // Mock for testing
//     await Future.delayed(const Duration(milliseconds: 500));
//     print("Mock: Updated vesting status for user $userId: $status");
//   }
//
//   Future<LoginResponse> web3Login( BuildContext context,String message, String address, String signature) async {
//      // final prefs = await SharedPreferences.getInstance();
//     // final refId = prefs.getString('referralId');
//
//     final response = await SentryApiLogger.post(
//       Uri.parse('${ApiConstants.baseUrl}/auth/web3-login'),
//       headers: {
//         'Content-Type': 'application/json'
//       },
//       body: jsonEncode({
//         'message': message,
//         'address': address,
//         'signature': signature,
//         // 'refId': refId,
//       }),
//     );
//
//
//
//     if (response.statusCode == 200) {
//
//       final data = jsonDecode(response.body);
//       final token = data['token'];
//       final user = UserModel.fromJson(data['user']);
//
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', token);
//       await prefs.setString('user', jsonEncode(user.toJson()));
//       await prefs.setString('firstName', user.name ?? '');
//       await prefs.setString('userName', user.username ?? '');
//       await prefs.setString('emailAddress', user.email ?? '');
//       await prefs.setString('phoneNumber', user.phone ?? '');
//       await prefs.setString('ethAddress', user.ethAddress ?? '');
//       await prefs.setString('unique_id', user.uniqueId ?? '');
//       if(user.image != null && user.image!.isNotEmpty){
//         await prefs.setString('profileImage', user.image!);
//       }
//
//       await prefs.setString('auth_method', 'web3');
//       final bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);
//       bottomNavProvider.setFullName(user.name ?? '');
//
//       return LoginResponse(user: user, token: token);
//     } else {
//        throw Exception('Failed to login with Web3: ${response.body}');
//     }
//   }
//
// }

/// With Clarity
// class ApiService {
//
//   Future<List<TokenModel>> fetchTokens() async {
//     final url = Uri.parse('${ApiConstants.baseUrl}/tokens');
//     final headers = {
//       'Content-Type': 'application/json',
//     };
//
//     try {
//       final response = await ClarityApiLogger.get(url, headers: headers, customProperties: {
//         "api":"fetchTokens"
//       });
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//
//         print("Using TOken Login :${response.body}");
//         return data.map((e) => TokenModel.fromJson(e)).toList();
//
//       } else {
//         throw Exception('Failed to load tokens: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<LoginResponse>  login(String username, String password) async  {
//     final url = Uri.parse('${ApiConstants.baseUrl}/auth/login');
//     final headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//     };
//     final body = jsonEncode({
//       "username": username,
//       "password": password,
//     });
//
//     try {
//       final response = await ClarityApiLogger.post(url, headers: headers, body: body,
//         customProperties: {"api": "login", "username": username},
//       );
//       print('>> Status Code: ${response.statusCode}');
//       print('>> Response Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final token = data['token'];
//         final user = UserModel.fromJson(data['user']);
//
//         print('Login successful. Token: $token');
//         print('ETH Address from login: ${user.ethAddress}');
//
//
//
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', token);
//         await prefs.setString('user', jsonEncode(user.toJson()));
//         await prefs.setString('unique_id', user.uniqueId ?? '');
//
//
//         return LoginResponse(user: user, token: token);
//       } else {
//         final error = jsonDecode(response.body);
//         throw error['message'] ?? 'Login failed';
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<TokenDetails> fetchTokenDetails(String slug) async {
//     final url = Uri.parse('${ApiConstants.baseUrl}/token/$slug');
//     final headers = {'Content-Type': 'application/json'};
//
//     try {
//       final response = await ClarityApiLogger.get(url, headers: headers,customProperties: {"api": "fetchTokenDetails", "tokenSlug": slug},);
//       if (response.statusCode == 200) {
//         return tokenDetailsFromJson(response.body);
//       } else {
//         throw Exception('Failed to load token details: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<List<PurchaseLogModel>> fetchPurchaseLogs({String? walletAddress}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     print('  Token: $token');
//     print('  Wallet address: $walletAddress');
//
//
//
//     final headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//       'Authorization': token != null && token.isNotEmpty ? 'Bearer $token' : '',
//     };
//
//     final url = Uri.parse(
//       walletAddress != null && walletAddress.isNotEmpty
//           ? '${ApiConstants.baseUrl}/get-purchase-logs?page=1&search=$walletAddress'
//           : '${ApiConstants.baseUrl}/get-purchase-logs?page=1',
//     );
//
//
//     try {
//       final response = await ClarityApiLogger.get(url, headers: headers,customProperties: {
//         "api": "fetchPurchaseLogs",
//         "walletAddress": walletAddress ?? "",
//       });
//
//
//       if (response.statusCode == 200) {
//         final decoded = json.decode(response.body);
//         final data = decoded['data'];
//         if (data == null || data is! List) {
//           throw Exception("'data' is missing or not a list");
//         }
//         return data.map<PurchaseLogModel>((e) => PurchaseLogModel.fromJson(e)).toList();
//       } else {
//         throw Exception('Failed to fetch purchase logs: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('  Error fetching logs: $e');
//       rethrow;
//     }
//   }
//
//   Future<String> fetchPurchaseReferral() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     if (token == null || token.isEmpty) {
//       return '0x0000000000000000000000000000000000000000';
//     }
//
//     final headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/get-purchase-referral');
//
//     try {
//       final response = await ClarityApiLogger.get(url, headers: headers,customProperties: {"api":"fetchPurchaseReferral"});
//
//       if (response.statusCode == 200) {
//
//         String responseBody = response.body.trim();
//
//         if (responseBody.startsWith('0x') && responseBody.length == 42) {
//           return responseBody;
//         } else if (responseBody.isEmpty || responseBody.toLowerCase() == 'not referred by anyone') {
//
//           return 'Not referred by anyone';
//         }
//         else {
//           return 'Not referred by anyone';
//         }
//       } else {
//         throw Exception('Failed to fetch referral data: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<List<ReferralUserListModel>> fetchAllReferralUsers() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     final headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//       if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
//     };
//
//     List<ReferralUserListModel> allUsers = [];
//     int page = 1;
//     int lastPage = 1;
//
//     do{
//       final url = Uri.parse('${ApiConstants.baseUrl}/get-referral-users?page=$page');
//
//       final response = await ClarityApiLogger.get(url,headers: headers,customProperties: {"api": "fetchAllReferralUsers", "page": page},);
//       if(response.statusCode == 200) {
//         final decoded = json.decode(response.body);
//         final List data = decoded['data'] ?? [];
//
//         allUsers.addAll(data.map((e) => ReferralUserListModel.fromJson(e)).toList());
//         lastPage = decoded['last_page'] ?? 1;
//         page++;
//
//       }else{
//         throw Exception('Failed to fetch referral users: ${response.statusCode}');
//       }
//     } while (page <= lastPage);
//
//     return allUsers;
//   }
//
//   Future<PurchaseStatsModel> fetchPurchaseStats() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/get-purchase-stats');
//
//     final response = await ClarityApiLogger.get(url, headers: headers,customProperties: {"api": "fetchPurchaseStats"},);
//     if (response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       return PurchaseStatsModel.fromJson(decoded);
//     } else {
//       throw Exception('Failed to fetch purchase stats');
//     }
//   }
//
//   Future<ReferralStatsModel> fetchReferralStats() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/get-referral-stats');
//
//     final response = await ClarityApiLogger.get(url, headers: headers,customProperties: {"api": "fetchReferralStats"},);
//     if (response.statusCode == 200) {
//       final decoded = json.decode(response.body);
//       return ReferralStatsModel.fromJson(decoded);
//     } else {
//       throw Exception('Failed to fetch purchase stats');
//     }
//   }
//
//   Future<String> fetchTokenBalanceHuman(String contractAddress, String walletAddress, {int decimals = 18}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token') ?? '';
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/token-balance/$contractAddress/$walletAddress');
//     final headers = {
//       'Accept': 'application/json',
//       if (token.isNotEmpty) 'Authorization': 'Bearer $token',
//     };
//
//     final response = await ClarityApiLogger.get(url, headers: headers,customProperties: {"api": "fetchTokenBalanceHuman"},);
//
//     if (response.statusCode == 401 || response.statusCode == 403) {
//       return '0';
//     }
//     if (response.statusCode != 200) {
//       throw Exception('Failed to fetch token balance: ${response.statusCode}');
//     }
//
//     final data = jsonDecode(response.body) as Map<String, dynamic>;
//     final raw = BigInt.parse(data['balance'].toString());
//     final divisor = BigInt.from(10).pow(decimals);
//
//     final integer = raw ~/ divisor;
//     final fraction = (raw % divisor).toString().padLeft(decimals, '0').replaceFirst(RegExp(r'0+$'), '');
//     final human = fraction.isEmpty ? integer.toString() : '$integer.$fraction';
//     print('[TokenBalance] -> parsed: { raw: $raw, human: $human }');
//     return human;
//   }
//
//
//
//   Future<LoginResponse> web3Login( BuildContext context,String message, String address, String signature) async {
//     // final prefs = await SharedPreferences.getInstance();
//     // final refId = prefs.getString('referralId');
//
//     final response = await ClarityApiLogger.post(
//       Uri.parse('${ApiConstants.baseUrl}/auth/web3-login'),
//       headers: {
//         'Content-Type': 'application/json'
//       },
//       body: jsonEncode({
//         'message': message,
//         'address': address,
//         'signature': signature,
//         // 'refId': refId,
//       }),
//       customProperties: {"api": "web3Login", "address": address},
//     );
//
//
//
//     if (response.statusCode == 200) {
//
//       final data = jsonDecode(response.body);
//       final token = data['token'];
//       final user = UserModel.fromJson(data['user']);
//
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', token);
//       await prefs.setString('user', jsonEncode(user.toJson()));
//       await prefs.setString('firstName', user.name ?? '');
//       await prefs.setString('userName', user.username ?? '');
//       await prefs.setString('emailAddress', user.email ?? '');
//       await prefs.setString('phoneNumber', user.phone ?? '');
//       await prefs.setString('ethAddress', user.ethAddress ?? '');
//       await prefs.setString('unique_id', user.uniqueId ?? '');
//       if(user.image != null && user.image!.isNotEmpty){
//         await prefs.setString('profileImage', user.image!);
//       }
//
//       await prefs.setString('auth_method', 'web3');
//       final bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);
//       bottomNavProvider.setFullName(user.name ?? '');
//
//       return LoginResponse(user: user, token: token);
//     } else {
//       throw Exception('Failed to login with Web3: ${response.body}');
//     }
//   }
//
//   Future<bool> submitUserFeedback({
//     required String message,
//     required String username,
//     List<String>? base64Images,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     final url = Uri.parse('${ApiConstants.baseUrl}/user-app-feedback');
//     final headers = {
//       'Accept': 'application/json',
//       if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     };
//
//     final body = jsonEncode({
//       'message': message,
//       'username': username,
//       if (base64Images != null && base64Images.isNotEmpty) 'images': base64Images,
//     });
//
//     final response = await http.post(url, headers: headers, body: body);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return true;
//     } else {
//       print("Feedback API error: ${response.body}");
//       throw Exception("Failed to submit feedback");
//     }
//   }
//
// }

/// logRockets
class ApiService {
  /// ✅ Helper to track API calls
  Future<void> _trackApiEvent(
      String endpoint,
      int statusCode,
      DateTime start, {
        String method = "GET",
        Map<String, dynamic>? extra,
      }) async {
    final duration = DateTime.now().difference(start).inMilliseconds;
    await logRocketTrackApiEvent(
      endpoint,
      statusCode,
      duration,
      method: method,
      extra: extra,
    );
  }


  Future<List<TokenModel>> fetchTokens() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/tokens');
    final headers = {
      'Content-Type': 'application/json',
    };
    final start = DateTime.now();

    try {
      final response = await http.get(url, headers: headers);

      //LogRockets
      await _trackApiEvent("/tokens", response.statusCode, start, method: "GET");


      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        print("Using TOken Login :${response.body}");
        return data.map((e) => TokenModel.fromJson(e)).toList();

      } else {
        throw Exception('Failed to load tokens: ${response.reasonPhrase}');
      }
    } catch (e) {
      await _trackApiEvent("/tokens", 500, start, method: "GET", extra: {"error": e.toString()});

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
    final start = DateTime.now();

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('>> Status Code: ${response.statusCode}');
      print('>> Response Body: ${response.body}');

       //LogRockets
      await _trackApiEvent("/auth/login", response.statusCode, start, method: "POST", extra: {"username": username});




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

        await updateLogRocketUser(
          (user.uniqueId ?? user.id).toString(),
          user.ethAddress ?? 'unknown',
          user.username ?? 'unknown',
        );



        return LoginResponse(user: user, token: token);
      } else {
        final error = jsonDecode(response.body);
        throw error['message'] ?? 'Login failed';
      }
    } catch (e) {
      await _trackApiEvent("/auth/login", 500, start, method: "POST", extra: {"error": e.toString()});

      rethrow;
    }
  }

  Future<TokenDetails> fetchTokenDetails(String slug) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/token/$slug');
    final headers = {'Content-Type': 'application/json'};
    final start = DateTime.now();

    try {
      final response = await http.get(url, headers: headers);
      await _trackApiEvent("/token/$slug", response.statusCode, start);

      if (response.statusCode == 200) {
        return tokenDetailsFromJson(response.body);
      } else {
        throw Exception('Failed to load token details: ${response.reasonPhrase}');
      }
    } catch (e) {
      await _trackApiEvent("/token/$slug", 500, start, extra: {"error": e.toString()});

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
    final start = DateTime.now();


    try {
      final response = await http.get(url, headers: headers);
      await _trackApiEvent("/get-purchase-logs", response.statusCode, start);


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
      await _trackApiEvent("/get-purchase-logs", 500, start, extra: {"error": e.toString()});

      rethrow;
    }
  }

  Future<String> fetchPurchaseReferral() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      return '0x0000000000000000000000000000000000000000';
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final start = DateTime.now();

    final url = Uri.parse('${ApiConstants.baseUrl}/get-purchase-referral');

    try {
      final response = await http.get(url, headers: headers);
      await _trackApiEvent("/get-purchase-referral", response.statusCode, start);

      if (response.statusCode == 200) {

        String responseBody = response.body.trim();

        if (responseBody.startsWith('0x') && responseBody.length == 42) {
          return responseBody;
        } else if (responseBody.isEmpty || responseBody.toLowerCase() == 'not referred by anyone') {

          return 'Not referred by anyone';
        }
        else {
          return 'Not referred by anyone';
        }
      } else {
        throw Exception('Failed to fetch referral data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      await _trackApiEvent("/get-purchase-referral", 500, start, extra: {"error": e.toString()});

      rethrow;
    }
  }

  Future<List<ReferralUserListModel>> fetchAllReferralUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    List<ReferralUserListModel> allUsers = [];
    int page = 1;
    int lastPage = 1;

    do{
      final start = DateTime.now();
      final url = Uri.parse('${ApiConstants.baseUrl}/get-referral-users?page=$page');

      try{
        final response = await http.get(url,headers: headers);
        await _trackApiEvent("/get-referral-users?page=$page", response.statusCode, start);

        if(response.statusCode == 200) {
          final decoded = json.decode(response.body);
          final List data = decoded['data'] ?? [];

          allUsers.addAll(data.map((e) => ReferralUserListModel.fromJson(e)).toList());
          lastPage = decoded['last_page'] ?? 1;
          page++;

        }else{
          throw Exception('Failed to fetch referral users: ${response.statusCode}');
        }
      }catch(e){
        await _trackApiEvent("/get-referral-users?page=$page", 500, start, extra: {"error": e.toString()});
        rethrow;

      }

    } while (page <= lastPage);

    return allUsers;
  }

  Future<PurchaseStatsModel> fetchPurchaseStats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('${ApiConstants.baseUrl}/get-purchase-stats');
    final start = DateTime.now();


    try{
      final response = await http.get(url, headers: headers);
      await _trackApiEvent("/get-purchase-stats", response.statusCode, start);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return PurchaseStatsModel.fromJson(decoded);
      } else {
        throw Exception('Failed to fetch purchase stats');
      }
    }catch(e){
      await _trackApiEvent("/get-purchase-stats", 500, start, extra: {"error": e.toString()});
      rethrow;
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
    final start = DateTime.now();

    try{
      final response = await http.get(url, headers: headers);
      await _trackApiEvent("/get-referral-stats", response.statusCode, start);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return ReferralStatsModel.fromJson(decoded);
      } else {
        throw Exception('Failed to fetch purchase stats');
      }
    }catch(e){
      await _trackApiEvent("/get-referral-stats", 500, start, extra: {"error": e.toString()});
      rethrow;

    }

  }

  Future<String> fetchTokenBalanceHuman(String contractAddress, String walletAddress, {int decimals = 18}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final start = DateTime.now();

    final url = Uri.parse('${ApiConstants.baseUrl}/token-balance/$contractAddress/$walletAddress');
    final headers = {
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    try{
      final response = await http.get(url, headers: headers);
      await _trackApiEvent("/token-balance/$contractAddress/$walletAddress", response.statusCode, start);

      if (response.statusCode == 401 || response.statusCode == 403) {
        return '0';
      }
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch token balance: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final raw = BigInt.parse(data['balance'].toString());
      final divisor = BigInt.from(10).pow(decimals);

      final integer = raw ~/ divisor;
      final fraction = (raw % divisor).toString().padLeft(decimals, '0').replaceFirst(RegExp(r'0+$'), '');
      final human = fraction.isEmpty ? integer.toString() : '$integer.$fraction';
      print('[TokenBalance] -> parsed: { raw: $raw, human: $human }');
      return human;
    }catch(e){
      await _trackApiEvent("/token-balance/$contractAddress/$walletAddress", 500, start, extra: {"error": e.toString()});
      rethrow;
    }

  }


  Future<LoginResponse> web3Login( BuildContext context,String message, String address, String signature) async {
    // final prefs = await SharedPreferences.getInstance();
    // final refId = prefs.getString('referralId');
    final start = DateTime.now();

    try{
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

      await _trackApiEvent("/auth/web3-login", response.statusCode, start, method: "POST", extra: {"address": address});


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

        await prefs.setString('auth_method', 'web3');
        final bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);
        bottomNavProvider.setFullName(user.name ?? '');


        // Update LogRocket user
        await updateLogRocketUser(
          (user.uniqueId ?? user.id).toString(),
          user.ethAddress ?? 'unknown',
          user.username ?? 'unknown',
        );



        return LoginResponse(user: user, token: token);
      } else {
        throw Exception('Failed to login with Web3: ${response.body}');
      }
    }catch(e){
      await _trackApiEvent("/auth/web3-login", 500, start, method: "POST", extra: {"error": e.toString()});
      rethrow;
    }

  }

  Future<bool> submitUserFeedback({
    required String message,
    required String username,
    List<String>? base64Images,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('${ApiConstants.baseUrl}/user-app-feedback');
    final headers = {
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'message': message,
      'username': username,
      if (base64Images != null && base64Images.isNotEmpty) 'images': base64Images,
    });
    final start = DateTime.now();


    try{
      final response = await http.post(url, headers: headers, body: body);
      await _trackApiEvent("/user-app-feedback", response.statusCode, start, method: "POST", extra: {"username": username});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Feedback API error: ${response.body}");
        throw Exception("Failed to submit feedback");
      }
    }catch(e){
      await _trackApiEvent("/user-app-feedback", 500, start, method: "POST", extra: {"error": e.toString()});
      rethrow;
    }
  }

}

class LoginResponse {
  final UserModel user;
  final String token;

  LoginResponse({required this.user, required this.token});
}
