import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _analytics.setAnalyticsCollectionEnabled(true);
    await _crashlytics.setCrashlyticsCollectionEnabled(true);
    _isInitialized = true;
  }

  /// Logs a custom event with parameters.
  /// Uses FirebaseAnalytics.logEvent under the hood.
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
    String? screenName,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
      if (kDebugMode) {
        debugPrint('Analytics Event Logged: $name with params: $parameters');
      }
    } catch (e, stack) {
      _logInternalError(e, stack, 'logEvent');
    }
  }

  /// Logs a user action with success/failure and duration.
  /// Recommended for WalletViewModel functions.
  Future<void> logUserAction({
    required String action, // e.g., 'wallet_connect', 'buy_ecm'
    required bool success,
    required int durationMs,
    required String walletAddress, // Anonymized if needed, but public
    Map<String, Object?> extra = const {},
  }) async {
    final params = <String, Object?>{
      'action': action,
      'success': success,
      'duration_ms': durationMs,
      'wallet_address': walletAddress,
      ...extra,
    };
    await logEvent(name: 'user_action', parameters: params);
  }

  /// Logs an error or exception.
  /// Records to Crashlytics and logs as 'error' event to Analytics.
  Future<void> logError({
    required dynamic error,
    required StackTrace stackTrace,
    required String context, // e.g., 'connectWallet'
    Map<String, Object?>? extra,
  }) async {
    try {
      await _crashlytics.recordError(error, stackTrace, reason: context);
      final params = <String, Object?>{
        'error_context': context,
        'error_message': error.toString(),
        'wallet_address': _getCurrentWalletAddress(), // If available
        ...?extra,
      };
      await logEvent(name: 'error_occurred', parameters: params);
      if (kDebugMode) {
        debugPrint('Error Logged: $context - $error\n$stackTrace');
      }
    } catch (e) {
      // Silent fail on logging error
      if (kDebugMode) debugPrint('Failed to log error: $e');
    }
  }

  /// Logs a crash (fatal error).
  Future<void> logCrash({
    required dynamic error,
    required StackTrace stackTrace,
    required String context,
  }) async {
    await _crashlytics.recordFatalError(error);
    await logError(error: error, stackTrace: stackTrace, context: context);
  }

  /// Sets a user property (e.g., wallet address).
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  /// Sets user ID (if available from auth).
  Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
  }

  /// Logs screen view.
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  /// Helper to get current wallet address from SharedPreferences (fallback).
  Future<String?> _getCurrentWalletAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('walletAddress');
  }

  /// Internal error logging for service itself.
  Future<void> _logInternalError(dynamic error, StackTrace stack, String method) async {
    if (kDebugMode) {
      debugPrint('AnalyticsService Internal Error in $method: $error\n$stack');
    }
    // Avoid recursive logging by not calling logError here
  }

  /// Resets analytics data (e.g., on logout).
  Future<void> reset() async {
    await _analytics.resetAnalyticsData();
  }
}

// Extension for easy error checking (e.g., user rejected)
extension ErrorHelpers on dynamic {
  bool get isUserRejected {
    final msg = toString().toLowerCase();
    return msg.contains('user rejected') ||
        msg.contains('user denied') ||
        msg.contains('user canceled') ||
        msg.contains('user cancelled') ||
        msg.contains('modal closed') ||
        msg.contains('wallet modal closed') ||
        msg.contains('no response from user');
  }
}