import 'package:logrocket_flutter/logrocket_flutter.dart';

Future<void> logRocketTrackApiEvent(
    String endpoint,
    int statusCode,
    int durationMs, {
      String method = "GET",
      Map<String, dynamic>? extra,
    }) async {
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



}