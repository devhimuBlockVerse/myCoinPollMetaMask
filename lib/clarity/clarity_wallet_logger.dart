// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:clarity_flutter/clarity_flutter.dart'; // hypothetical Clarity package
// import 'package:web3dart/web3dart.dart';
//
// import '../application/presentation/viewmodel/wallet_view_model.dart';
//
// class WalletViewModelLogger {
//   final WalletViewModel walletViewModel;
//   final String userId;
//
//   WalletViewModelLogger(this.walletViewModel, this.userId);
//
//   /// General wrapper for logging, timing, error handling, and optional retries
//   Future<T> execute<T>(
//       String functionName,
//       Future<T> Function() action, {
//         Map<String, dynamic>? args,
//         int retries = 1,
//       }) async {
//     for (int attempt = 1; attempt <= retries; attempt++) {
//       final stopwatch = Stopwatch()..start();
//       try {
//         debugPrint("Executing WalletViewModel.$functionName, attempt $attempt, args: $args");
//         final result = await action();
//
//         stopwatch.stop();
//         debugPrint("WalletViewModel.$functionName succeeded in ${stopwatch.elapsedMilliseconds}ms.");
//
//         // Clarity.sendCustomEvent(
//         //     'WalletViewModel.$functionName.success: ${{
//         //       'result': result,
//         //       'args': args,
//         //       'duration_ms': stopwatch.elapsedMilliseconds,
//         //       'attempt': attempt,
//         //     }}'
//         // );
//         _sendClarityEvent(
//           action: functionName,
//           args: args,
//           result: result,
//           durationMs: stopwatch.elapsedMilliseconds,
//           attempt: attempt,
//           success: true,
//         );
//
//         return result;
//       } catch (e, stack) {
//         stopwatch.stop();
//         debugPrint("Error in WalletViewModel.$functionName (attempt $attempt): $e");
//         // Clarity.sendCustomEvent(
//         //     'WalletViewModel.$functionName.error: ${{
//         //       'error': e.toString(),
//         //       'stack': stack.toString(),
//         //       'args': args,
//         //       'duration_ms': stopwatch.elapsedMilliseconds,
//         //       'attempt': attempt,
//         //     }}'
//         // );
//         _sendClarityEvent(
//           action: functionName,
//           args: args,
//           error: e.toString(),
//           stack: stack.toString(),
//           durationMs: stopwatch.elapsedMilliseconds,
//           attempt: attempt,
//           success: false,
//         );
//         if (attempt == retries) rethrow;
//       }
//     }
//     throw Exception("execute failed after $retries attempts");
//   }
//
//
//
//
//   /// Core functions
//   Future<void> init(BuildContext context) async {
//     await execute('init', () => walletViewModel.init(context));
//   }
//
//   Future<bool> connectWallet(BuildContext context) async {
//     return await execute('connectWallet', () => walletViewModel.connectWallet(context)) ?? false;
//   }
//
//   Future<void> disconnectWallet(BuildContext context) async {
//     await execute('disconnectWallet', () => walletViewModel.disconnectWallet(context));
//   }
//
//   Future<void> fetchConnectedWalletData({bool isReconnecting = false}) async {
//     await execute(
//       'fetchConnectedWalletData',
//           () => walletViewModel.fetchConnectedWalletData(isReconnecting: isReconnecting),
//       args: {'isReconnecting': isReconnecting},
//     );
//   }
//
//   Future<bool> openWalletModal(BuildContext context) async {
//     return await execute('openWalletModal', () => walletViewModel.openWalletModal(context)) ?? false;
//   }
//
//   Future<void> rehydrate() async {
//     await execute('rehydrate', () => walletViewModel.rehydrate());
//   }
//
//   Future<void> reset() async {
//     await execute('reset', () => walletViewModel.reset());
//   }
//
//   /// Balance & token info
//   Future<String?> getMinimumStake() async {
//     return await execute('getMinimumStake', () => walletViewModel.getMinimunStake());
//   }
//
//   Future<String?> getMaximumStake() async {
//     return await execute('getMaximumStake', () => walletViewModel.getMaximumStake());
//   }
//
//   Future<String?> getTotalSupply() async {
//     return await execute('getTotalSupply', () => walletViewModel.getTotalSupply());
//   }
//
//   Future<int?> getTokenDecimals({required String contractAddress}) async {
//     return await execute(
//       'getTokenDecimals',
//           () => walletViewModel.getTokenDecimals(contractAddress: contractAddress),
//       args: {'contractAddress': contractAddress},
//     );
//   }
//
//   Future<String?> getBalance({String? forAddress}) async {
//     return await execute(
//       'getBalance',
//           () => walletViewModel.getBalance(forAddress: forAddress),
//       args: {'forAddress': forAddress},
//     );
//   }
//
//   Future<String?> fetchLatestETHPrice({bool forceLoad = false}) async {
//     return await execute(
//       'fetchLatestETHPrice',
//           () => walletViewModel.fetchLatestETHPrice(forceLoad: forceLoad),
//       args: {'forceLoad': forceLoad},
//       retries: 3, // retry network call up to 3 times
//     );
//   }
//
//   /// Token purchase and staking
//   Future<String?> buyECMWithETH({
//     required EtherAmount ethAmount,
//     required EthereumAddress referralAddress,
//     required BuildContext context,
//   }) async {
//     return await execute(
//       'buyECMWithETH',
//           () => walletViewModel.buyECMWithETH(
//         ethAmount: ethAmount,
//         referralAddress: referralAddress,
//         context: context,
//       ),
//       args: {
//         'ethAmount': ethAmount.getValueInUnit(EtherUnit.ether),
//         'referralAddress': referralAddress.hex,
//       },
//       retries: 3, // retry in case of transient failures
//     );
//   }
//
//   Future<String?> stakeNow({
//     required BuildContext context,
//     required double amount,
//     required int planIndex,
//     String referrerAddress = '0x0000000000000000000000000000000000000000',
//   }) async {
//     return await execute(
//       'stakeNow',
//           () => walletViewModel.stakeNow(context, amount, planIndex, referrerAddress: referrerAddress),
//       args: {
//         'amount': amount,
//         'planIndex': planIndex,
//         'referrerAddress': referrerAddress,
//       },
//       retries: 2,
//     );
//   }
//
//   Future<String?> unstake(int stakeId) async {
//     return await execute('unstake', () => walletViewModel.unstake(stakeId), args: {'stakeId': stakeId});
//   }
//
//   Future<String?> forceUnstake(int stakeId) async {
//     return await execute('forceUnstake', () => walletViewModel.forceUnstake(stakeId), args: {'stakeId': stakeId});
//   }
//
//   /// Vesting functions
//   Future<void> getVestingInformation() async {
//     await execute('getVestingInformation', () => walletViewModel.getVestingInformation());
//   }
//
//   Future<void> claimECM(BuildContext context) async {
//     await execute('claimECM', () => walletViewModel.claimECM(context));
//   }
//
//   Future<void> refreshVesting() async {
//     await execute('refreshVesting', () => walletViewModel.refreshVesting());
//   }
//
//
//   void _sendClarityEvent({
//     required String action,
//     Map<String, dynamic>? args,
//     dynamic result,
//     String? error,
//     String? stack,
//     required int durationMs,
//     required int attempt,
//     required bool success,
//   }) {
//     final eventData = jsonEncode({
//       "action": action,
//       "userId": userId,
//       "success": success,
//       "args": args ?? {},
//       "result": result,
//       "error": error,
//       "stack": stack,
//       "duration_ms": durationMs,
//       "attempt": attempt,
//       "timestamp": DateTime.now().toIso8601String(),
//     });
//
//     Clarity.sendCustomEvent(eventData);
//     debugPrint("Clarity Event Sent: $eventData");
//   }
//
// //void _sendClarityEvent({
// //   required String action,
// //   Map<String, dynamic>? args,
// //   dynamic result,
// //   String? error,
// //   String? stack,
// //   required int durationMs,
// //   required int attempt,
// //   required bool success,
// // }) {
// //   // Friendly mapping of internal function names to readable event names
// //   final friendlyNames = {
// //     'init': 'Wallet: Initialize',
// //     'connectWallet': 'Wallet: Connect',
// //     'disconnectWallet': 'Wallet: Disconnect',
// //     'fetchConnectedWalletData': 'Wallet: Fetch Connected Data',
// //     'openWalletModal': 'Wallet: Open Modal',
// //     'rehydrate': 'Wallet: Rehydrate',
// //     'reset': 'Wallet: Reset',
// //     'getMinimumStake': 'Wallet: Get Minimum Stake',
// //     'getMaximumStake': 'Wallet: Get Maximum Stake',
// //     'getTotalSupply': 'Wallet: Get Total Supply',
// //     'getTokenDecimals': 'Wallet: Get Token Decimals',
// //     'getBalance': 'Wallet: Get Balance',
// //     'fetchLatestETHPrice': 'Wallet: Fetch ETH Price',
// //     'buyECMWithETH': 'Wallet: Buy ECM With ETH',
// //     'stakeNow': 'Wallet: Stake Now',
// //     'unstake': 'Wallet: Unstake',
// //     'forceUnstake': 'Wallet: Force Unstake',
// //     'getVestingInformation': 'Wallet: Get Vesting Info',
// //     'claimECM': 'Wallet: Claim ECM',
// //     'refreshVesting': 'Wallet: Refresh Vesting',
// //   };
// //
// //   final eventName = friendlyNames[action] ?? action;
// //
// //   final eventData = jsonEncode({
// //     "eventName": eventName,
// //     "userId": userId,
// //     "success": success,
// //     "args": args ?? {},
// //     "result": result,
// //     "error": error,
// //     "stack": stack,
// //     "duration_ms": durationMs,
// //     "attempt": attempt,
// //     "timestamp": DateTime.now().toIso8601String(),
// //   });
// //
// //   Clarity.sendCustomEvent(eventData);
// //   debugPrint("Clarity Event Sent: $eventData");
// // }
// }
//
//
// class WalletClarityLogger {
//   /// Logs a wallet-related event to Clarity
//   static void logEvent({
//     required String action,
//     required String userId,
//     Map<String, dynamic>? additionalData,
//   }) {
//     final eventData = jsonEncode({
//       "action": action,
//       "userId": userId,
//       "timestamp": DateTime.now().toIso8601String(),
//       if (additionalData != null) ...additionalData,
//     });
//
//     // Send the event to Clarity
//     Clarity.sendCustomEvent(eventData);
//
//     debugPrint("Clarity Event Sent: $eventData");
//   }
//
//   /// Helper to track buy action
//   static void logBuy({
//     required String userId,
//     required EtherAmount ethAmount,
//     required EthereumAddress referralAddress,
//   }) {
//     logEvent(
//       action: "buyECMWithETH",
//       userId: userId,
//       additionalData: {
//         "ethAmount": ethAmount.getValueInUnit(EtherUnit.ether),
//         "referralAddress": referralAddress.hex,
//       },
//     );
//   }
//
//   /// Helper to track staking action
//   static void logStake({
//     required String userId,
//     required double amount,
//     required int planIndex,
//     String referrerAddress = '0x0000000000000000000000000000000000000000',
//   }) {
//     logEvent(
//       action: "stakeNow",
//       userId: userId,
//       additionalData: {
//         "amount": amount,
//         "planIndex": planIndex,
//         "referrerAddress": referrerAddress,
//       },
//     );
//   }
//
//   /// Helper to track unstake action
//   static void logUnstake({
//     required String userId,
//     required int stakeId,
//   }) {
//     logEvent(
//       action: "unstake",
//       userId: userId,
//       additionalData: {"stakeId": stakeId},
//     );
//   }
//
//   /// Helper to track force unstake action
//   static void logForceUnstake({
//     required String userId,
//     required int stakeId,
//   }) {
//     logEvent(
//       action: "forceUnstake",
//       userId: userId,
//       additionalData: {"stakeId": stakeId},
//     );
//   }
// }
