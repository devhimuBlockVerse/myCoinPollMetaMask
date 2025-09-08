// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:clarity_flutter/clarity_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ClarityApiLogger {
//   /// GET request with optional custom properties
//   static Future<http.Response> get(
//       Uri url, {
//         Map<String, String>? headers,
//         Map<String, dynamic>? customProperties,
//       }) async {
//     return _sendRequest(
//       method: 'GET',
//       url: url,
//       headers: headers,
//       customProperties: customProperties,
//     );
//   }
//
//   /// POST request with optional custom properties
//   static Future<http.Response> post(
//       Uri url, {
//         Map<String, String>? headers,
//         Object? body,
//         Map<String, dynamic>? customProperties,
//       }) async {
//     return _sendRequest(
//       method: 'POST',
//       url: url,
//       headers: headers,
//       body: body,
//       customProperties: customProperties,
//     );
//   }
//
//   /// Internal request handler
//   static Future<http.Response> _sendRequest({
//     required String method,
//     required Uri url,
//     Map<String, String>? headers,
//     Object? body,
//     Map<String, dynamic>? customProperties,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('unique_id') ?? 'guest';
//
//     final start = DateTime.now();
//
//     // Combine default + custom properties
//     final eventProperties = {
//       "method": method,
//       "url": url.toString(),
//       "userId": userId,
//       if (customProperties != null) ...customProperties,
//     };
//
//     try {
//       // Track request start
//       _sendClarityEvent(
//         event: "API_REQUEST_START",
//         properties: eventProperties,
//       );
//
//
//       // Make actual request
//       final response = await (method == 'POST'
//           ? http.post(url, headers: headers, body: body)
//           : http.get(url, headers: headers));
//
//       final duration = DateTime.now().difference(start).inMilliseconds;
//
//       // Track request success
//       _sendClarityEvent(
//         event: "API_REQUEST_SUCCESS",
//         properties: {
//           ...eventProperties,
//           "status": response.statusCode,
//           "duration_ms": duration,
//         },
//       );
//
//       return response;
//     } catch (e,stack) {
//       final duration = DateTime.now().difference(start).inMilliseconds;
//
//       // Track request failure
//       _sendClarityEvent(
//         event: "API_REQUEST_FAILURE",
//         properties: {
//           ...eventProperties,
//           "error": e.toString(),
//           "stack": stack.toString(),
//           "duration_ms": duration,
//         },
//       );
//
//       rethrow;
//     }
//   }
//
//
//
//
//
//
//   /// Core function to send events to Clarity
//   static void _sendClarityEvent({
//     required String event,
//     Map<String, dynamic>? properties,
//   }) {
//     final eventData = jsonEncode({
//       "event": event,
//       "properties": properties ?? {},
//       "timestamp": DateTime.now().toIso8601String(),
//     });
//
//     Clarity.sendCustomEvent(eventData);
//   }
//
// }
