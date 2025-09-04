
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:http/http.dart' as http;

class SentryApiLogger {

  /// GET Request
  static Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final transaction = Sentry.startTransaction('GET ${url.path}', 'http_request');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode >= 400) {
        // Capture API error in Sentry
        await Sentry.captureEvent(
          SentryEvent(
            message: SentryMessage(
                'GET ${url.path} failed with status ${response.statusCode}\nBody: ${response.body}'),
            level: SentryLevel.error,
            tags: {'source': 'api'},
          ),
        );
        transaction.status = const SpanStatus.internalError();
      } else {
        transaction.status = const SpanStatus.ok();
      }

      // Optional: log successful API calls
      await Sentry.logger.info('GET ${url.path} -> ${response.statusCode}');

      return response;
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace,  withScope: (scope) {
        scope.setTag('source', 'api');
      },);

       await Sentry.captureEvent(
        SentryEvent(
          throwable: e,
          level: SentryLevel.error,
          tags: {'source': 'api'},
        ),
      );

      transaction.status = const SpanStatus.internalError();
      rethrow;
    } finally {
      await transaction.finish();
    }
  }


  /// POST request
  static Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) async {
    final transaction = Sentry.startTransaction('POST ${url.path}', 'http_request');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode >= 400) {
        await Sentry.captureEvent(
          SentryEvent(
            message: SentryMessage(
                'POST ${url.path} failed with status ${response.statusCode}\nBody: ${response.body}'),
            level: SentryLevel.error,
            tags: {'source': 'api'},
          ),
        );
        transaction.status = const SpanStatus.internalError();
      } else {
        transaction.status = const SpanStatus.ok();
      }

      await Sentry.logger.info('POST ${url.path} -> ${response.statusCode}');

      return response;
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace,  withScope: (scope) {
        scope.setTag('source', 'api');
      },);
      await Sentry.captureEvent(
        SentryEvent(
          throwable: e,
          level: SentryLevel.error,
          tags: {'source': 'api'},
        ),
      );
      transaction.status = const SpanStatus.internalError();
      rethrow;
    } finally {
      await transaction.finish();
    }
  }
}

class SentryWalletLogger {

  /// Logs a successful initialization of the app and wallet view model.
  static void logSuccessfulInit() {
    Sentry.captureMessage(
      'App and Wallet Initialized Successfully',
      level: SentryLevel.info,
      withScope: (scope) {
        scope.setTag('source', 'init_function');
      },
    );
  }

  /// Logs a successful ECM purchase transaction.
  static void logSuccessfulPurchase({
    required String transactionHash,
    required double ecmAmount,
  }) {
    Sentry.captureMessage(
      'Successful ECM purchase',
      level: SentryLevel.info,
      withScope: (scope) {
        scope.setTag('source', 'Buy_Ecm_Button');
        scope.setExtra('transaction_hash', transactionHash);
        scope.setExtra('ecm_amount', ecmAmount);
      },
    );
  }

  /// Logs a specific error related to the ECM purchase process.
  static void logBuyEcmError({
    required dynamic error,
    required dynamic stackTrace,
    required String ecmAmount,
    required String ethAmount,
  }) {
    Sentry.captureException(
      error,
      stackTrace: stackTrace,
      hint: Hint()..set('description', 'Error during ECM purchase'),
      withScope: (scope) {
        scope.setTag('source', 'Buy_Ecm_Button');
        scope.setExtra('ecm_amount', ecmAmount);
        scope.setExtra('eth_amount', ethAmount);
      },
    );
  }

  /// Adds a breadcrumb to the current Sentry scope to track user actions.
  static void addBreadcrumb(String message, {String category = 'ui.action'}) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        category: category,
        type: 'navigation',
        message: message,
      ),
    );
  }
}