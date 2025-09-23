import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logrocket_flutter/logrocket_flutter.dart';

Future<void> logRocketTrackApiEvent(
    String endpoint,
    int statusCode,
    int durationMs, {
      String method = "GET",
      Map<String, dynamic>? extra,
    }) async {
  /// LogRocket event
  final event = LogRocketCustomEventBuilder("API_REQUEST")
    ..putString("endpoint", endpoint)
    ..putString("method", method)
    ..putInt("status", statusCode)
    ..putInt("duration_ms", durationMs);

  if (extra != null) {
    extra.forEach((key, value) {
      if (value is String) event.putString(key, value);
      if (value is int) event.putInt(key, value);
      if (value is double) event.putDouble(key, value);
      if (value is bool) event.putBool(key, value);
    });
  }

  await LogRocket.track(event);

  ///Firebase Analytics event
  try{
    final analyticsParams = {
      'endpoint': endpoint,
      'method': method,
      'status': statusCode.toString(),
      'duration_ms': durationMs.toString(),
      if (extra != null) ...extra.map((key, value) => MapEntry(key, value.toString())),
    };
    await FirebaseAnalytics.instance.logEvent(name: 'api_request' , parameters: analyticsParams);
  }catch(e){
    print("Error sending API_REQUEST to Firebase Analytics: $e");
  }
}

Future<void> logRocketTrackBlockChainEvent(
    String eventName,
    String functionName,
    String contractAddress,
    bool success,
    int durationMs,{
      String? transactionHash,
      Map<String, dynamic>? extra,
    })async{

  /// LogRocket event
  final event = LogRocketCustomEventBuilder(eventName)
    ..putString("function", functionName)
    ..putString("contract", contractAddress)
    ..putBool("success", success)
    ..putInt("duration_ms", durationMs);

  if (transactionHash != null) {
    event.putString("tx_hash", transactionHash);
  }

  if (extra != null) {
    extra.forEach((key, value) {
      if (value is String) event.putString(key, value);
      if (value is int) event.putInt(key, value);
      if (value is double) event.putDouble(key, value);
      if (value is bool) event.putBool(key, value);
    });
  }

  await LogRocket.track(event);

  /// Firebase Analytics event
  try{
    final analyticsParams = {
      'function': functionName,
      'contract': contractAddress,
      'success': success.toString(),
      'duration_ms': durationMs.toString(),
      if (transactionHash != null) 'tx_hash': transactionHash,
      if (extra != null) ...extra.map((key, value) => MapEntry(key, value.toString())),
    };

    await FirebaseAnalytics.instance.logEvent(
        name: eventName.toLowerCase().replaceAll(' ', '_'),
        parameters: analyticsParams);
  }catch(e){
    print("Error sending $eventName to Firebase Analytics: $e");
  }
}