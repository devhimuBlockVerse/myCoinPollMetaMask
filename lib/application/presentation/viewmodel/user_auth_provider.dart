import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reown_appkit/appkit_modal.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/crypto.dart';

import '../../../framework/utils/customToastMessage.dart';
import '../../../framework/utils/enums/toast_type.dart';
import '../../data/services/api_service.dart';
import '../../module/dashboard_bottom_nav.dart';
import '../models/user_model.dart';
import 'wallet_view_model.dart';

class UserAuthProvider with ChangeNotifier {

  UserAuthProvider() {
    loadUserFromPrefs();
  }

  UserModel? _user;
  String? _token;

  UserModel? get user => _user;
  String? get token => _token;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  void setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userJson = prefs.getString('user');

    if (token != null && userJson != null) {
      _token = token;
      _user = UserModel.fromJson(jsonDecode(userJson));
        notifyListeners();
    } else {
      _token = null;
      _user = null;
       notifyListeners();
    }
  }

  Future<void> setUserAndToken(UserModel user, String token, {String? authMethod}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    await prefs.setString('token', token);


    _user = user;
    _token = token;
     notifyListeners();
  }






}