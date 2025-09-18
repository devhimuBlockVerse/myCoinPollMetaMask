import 'dart:async';
import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mycoinpoll_metamask/logrocket/logrocket_utils.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/crypto.dart';
import '../../../framework/utils/customToastMessage.dart';
import '../../../framework/utils/enums/toast_type.dart';
import '../../domain/constants/api_constants.dart';
import 'dart:typed_data';
import '../../module/userDashboard/view/dashboard/dashboard_screen.dart';
import '../../module/userDashboard/view/vesting/helper/vesting_info.dart';

bool isUserRejectedError(Object error) {
  if (error == null) return false;

  final msg = error.toString().toLowerCase();

  // Common user rejection / cancellation phrases
  final userRejectedPatterns = [
    "user rejected",
    "user denied",
    "user canceled",
    "user cancelled",
    "transaction declined",
    "request rejected",
    "rejected by user",
    "rejected request",
    "action rejected",
    "cancelled",
    "request already pending",
    "modal closed",
    "wallet modal closed",
    "no response from user",
    "user closed",
    "unauthorized",
    "transport error",
    "failed to fetch",
  ];

  // RPC-specific rejection codes
  final rpcErrorPatterns = [
    "rpc error:.*4001",
  ];

  // App/session kill indicators
  final appKilledPatterns = [
    "session disconnected",
    "wallet disconnected",
    "connection lost",
    "app terminated",
    "app closed",
    "background kill",
  ];

  // Check if any pattern matches
  bool matches(List<String> patterns) {
    for (var pattern in patterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(msg)) {
        return true;
      }
    }
    return false;
  }

  return matches(userRejectedPatterns) ||
      matches(rpcErrorPatterns) ||
      matches(appKilledPatterns);
}

// class WalletViewModel extends ChangeNotifier with WidgetsBindingObserver{
//
//   bool _hasMaterial(BuildContext context) {
//     return Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) != null;
//   }
//   void setupLifecycleObserver() {
//     WidgetsBinding.instance.addObserver(_LifecycleHandler(
//         onDetached: _handleAppDetached, onPause: _handleAppPause,
//         onResume: _handleAppResume)
//     );
//   }
//
//
//   ///Ensures context is valid and modal is re-initialized if needed
//   ReownAppKitModal? appKitModal;
//   bool _isSessionSettling = false;
//   String _walletAddress = '';
//   bool _isLoading = false;
//   bool _isConnected = false;
//   String? _balance;
//   String? _minimumStake;
//   String? _maximumStake;
//   double _ethPrice = 0.0;
//
//   Web3Client? _web3Client;
//   bool _isModalEventsSubscribed = false;
//   bool _walletConnectedManually = false;
//   bool _modalHasMaterialContext = false;
//   String? _lastKnowChainId;
//   String? _lastTransactionHash;
//   BuildContext? _lastContext;
//   String? _authToken;
//
//   BigInt? rawPrice;
//
//   // Getters
//   bool get walletConnectedManually => _walletConnectedManually;
//   String? get lastTransactionHash => _lastTransactionHash;
//   double get ethPrice => _ethPrice;
//
//   String? get balance => _balance;
//   String? get minimumStake => _minimumStake;
//   String? get maximumStake => _maximumStake;
//   String get walletAddress => _walletAddress;
//   bool get isConnected => _isConnected;
//   bool get isLoading => _isLoading;
//   bool get isSessionSettling => _isSessionSettling;
//   String? get authToken => _authToken;
//
//
//   Timer? _vestingTimer;
//   String? _userWalletBalance;
//   String? _vestingContractBalance;
//   bool _isUserBalanceLoading = false;
//   bool _isVestingBalanceLoading = false;
//
//
//   bool _isReconnecting = false;
//   Timer? _sessionHealthTimer;
//   Timer? _reconnectionTimer;
//   int _reconnectionAttempts = 0;
//   static const int MAX_RECONNECTION_ATTEMPTS = 3;
//   static const Duration SESSION_HEALTH_CHECK_INTERVAL = Duration(seconds: 30);
//   static const Duration RECONNECTION_DELAY = Duration(seconds: 3);
//
//
//
//   // Enhanced session validation
//   bool get isSessionValid {
//     return appKitModal?.session != null &&
//         _isConnected &&
//         _walletAddress.isNotEmpty &&
//         _lastKnowChainId != null;
//   }
//
//
//   String? get userWalletBalance => _userWalletBalance;
//   String? get vestingContractBalance => _vestingContractBalance;
//   bool get isUserBalanceLoading => _isUserBalanceLoading;
//   bool get isVestingBalanceLoading => _isVestingBalanceLoading;
//
//   static const String ALCHEMY_URL_V2 = "https://eth-sepolia.g.alchemy.com/v2/Z-5ts6Ke8ik_CZOD9mNqzh-iekLYPySe"; // Test/**/
//    // static const String ALCHEMY_URL_V2 = "https://mainnet.infura.io/v3/8e59f629376f4c459566f61b213bb3f4"; /// MAIN
//
//    static const String SALE_CONTRACT_ADDRESS = '0x732c5dFF0db1070d214F72Fc6056CF8B48692506'; // Test
//    // static const String SALE_CONTRACT_ADDRESS = '0xf19A1ca2441995BB02090F57046147f36555b0aC';
//
//    static const String ECM_TOKEN_CONTRACT_ADDRESS = '0x4C324169890F42c905f3b8f740DBBe7C4E5e55C0'; // Test
//    // static const String ECM_TOKEN_CONTRACT_ADDRESS = '0x6f9c25edc02f21e9df8050a3e67947c99b88f0b2';
//
//   static const String STAKING_CONTRACT_ADDRESSLIVE = '0x878323894bE6c7E019dBA7f062e003889C812715'; /// statke , unstake TEST
//   // static const String STAKING_CONTRACT_ADDRESSLIVE = '0x6c6a6450b95d15Fbd80356EFe0b7DaE27ea00092'; /// statke , unstake ,getMinimunStake , maximumStake
//
//   static const String AGGREGATO_RADDRESS = '0x694AA1769357215DE4FAC081bf1f309aDC325306'; // Test
//   // static const String AGGREGATO_RADDRESS = '0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419';
//
//
//
//   static const String EXITING_VESTING_ADDRESS = '0x6EB1b13f3A71b0dfDC2F2e4E9490468aB3BAB266';
//
//
//
//
//   static const double ECM_PRICE_USD = 1.2;
//   static const int ECM_DECIMALS = 18;
//   static const int AGGREGATOR_DECIMALS = 8;
//
//   static const String API_ENDPOINT = 'https://app.mycoinpoll.com/api/v1';
//
//
//   Future<void> setAuthToken(String token) async {
//     _authToken = token;
//     notifyListeners();
//   }
//
//
//   WalletViewModel() {
//     _web3Client = Web3Client(ALCHEMY_URL_V2, Client());
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   String? _vestingAddress;
//   String? _vestingStatus; // 'locked' | 'process' | null
//
//   final VestingInfo vestInfo = VestingInfo(
//     start: 0,
//     cliff: 0,
//     duration: 0,
//     end: 0,
//     released: 0.0,
//     claimable: 0.0,
//     totalVestingAmount: 0.0,
//   );
//
// // Getters for the new properties
//   String? get vestingAddress => _vestingAddress;
//   String? get vestingStatus => _vestingStatus;
//
//   @override
//   void dispose() {
//     _vestingTimer?.cancel();
//     _sessionHealthTimer?.cancel();
//     _reconnectionTimer?.cancel();
//      _web3Client?.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//
//     appKitModal?.onModalConnect.unsubscribeAll();
//     appKitModal?.onModalUpdate.unsubscribeAll();
//     appKitModal?.onModalDisconnect.unsubscribeAll();
//     appKitModal?.onSessionExpireEvent.unsubscribeAll();
//     appKitModal?.onSessionUpdateEvent.unsubscribeAll();
//     super.dispose();
//   }
//
//   Future<void> init(BuildContext context) async {
//     if (_isLoading) return;
//     _isLoading = true;
//     notifyListeners();
//
//     try{
//       if (appKitModal == null) {
//         // _lastContext = context;
//         appKitModal = ReownAppKitModal(
//
//           context: context,
//           // projectId: 'f3d7c5a3be3446568bcc6bcc1fcc6389',
//           projectId: 'ec1aaae5ff0cfc95b21c0a59b7a2fe91',
//            metadata: const PairingMetadata(
//             name: "MyWallet",
//             description: "Example Description",
//             url: 'https://mycoinpoll.com/',
//             icons: ['https://example.com/logo.png'],
//             redirect: Redirect(
//               native: 'MyCoin Poll',
//               universal: 'https://reown.com/exampleapp',
//               linkMode: true,
//             ),
//           ),
//
//           logLevel: LogLevel.error,
//           enableAnalytics: false,
//           featuresConfig: FeaturesConfig(
//             email: false,
//             socials: [
//               AppKitSocialOption.Google,
//               AppKitSocialOption.Discord,
//               AppKitSocialOption.Facebook,
//               AppKitSocialOption.GitHub,
//               AppKitSocialOption.X,
//               AppKitSocialOption.Apple,
//               AppKitSocialOption.Twitch,
//               AppKitSocialOption.Farcaster,
//             ],
//             showMainWallets: true,
//           ),
//         );
//
//         await appKitModal!.init();
//         final hasMaterial = Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) != null;
//         _modalHasMaterialContext = hasMaterial;
//
//
//       }
//
//       if (!_isModalEventsSubscribed) {
//         final prefs = await SharedPreferences.getInstance();
//         _subscribeToModalEvents(prefs);
//         _isModalEventsSubscribed = true;
//       }
//
//       // await fetchLatestETHPrice();
//
//       await _hydrateFromExistingSession();
//
//
//     }catch(e,stack){
//
//       await fetchLatestETHPrice();
//     }finally{
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> ensureModalWithValidContext(BuildContext context) async {
//
//     if (appKitModal == null || !_hasMaterial(context)) {
//       _lastContext = context;
//       await init(context);
//     }
//   }
//
//   void _subscribeToModalEvents(SharedPreferences prefs) {
//     // Clear all existing subscriptions first
//     appKitModal!.onModalConnect.unsubscribeAll();
//     appKitModal!.onModalUpdate.unsubscribeAll();
//     appKitModal!.onModalDisconnect.unsubscribeAll();
//     appKitModal!.onSessionExpireEvent.unsubscribeAll();
//     appKitModal!.onSessionUpdateEvent.unsubscribeAll();
//
//     // Simple connection handler - only update state, don't fetch data immediately
//     appKitModal!.onModalConnect.subscribe((_) async {
//       debugPrint("Modal connected event triggered");
//
//       // Update basic state
//       _isConnected = true;
//       _reconnectionAttempts = 0;
//
//       // Get basic info from session
//       _lastKnowChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
//       final address = _getFirstAddressFromSession();
//
//       if (address != null) {
//         _walletAddress = address;
//         // Save to prefs
//         await prefs.setBool('isConnected', true);
//         await prefs.setString('walletAddress', _walletAddress);
//       }
//
//       // Don't fetch data here - let the UI handle it
//       notifyListeners();
//     });
//
//     // Simple update handler - minimal processing
//     appKitModal!.onModalUpdate.subscribe((_) async {
//       debugPrint("Modal update event triggered");
//
//       // Only update if something actually changed
//       final newChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
//       final newAddress = _getFirstAddressFromSession();
//
//       bool shouldNotify = false;
//
//       if (newChainId != _lastKnowChainId) {
//         _lastKnowChainId = newChainId;
//         shouldNotify = true;
//       }
//
//       if (newAddress != null && newAddress != _walletAddress) {
//         _walletAddress = newAddress;
//         await prefs.setString('walletAddress', _walletAddress);
//         shouldNotify = true;
//       }
//
//       if (shouldNotify) {
//         notifyListeners();
//       }
//     });
//
//     // Simple disconnect handler - don't clear everything immediately
//     appKitModal!.onModalDisconnect.subscribe((_) async {
//       debugPrint("Modal disconnect event triggered");
//
//       // Only clear if we're actually disconnected
//       if (appKitModal?.session == null) {
//         await _handleDisconnect(prefs);
//       }
//     });
//
//     // Simple session expire handler
//     appKitModal!.onSessionExpireEvent.subscribe((_) async {
//       debugPrint("Session expire event triggered");
//       await _handleDisconnect(prefs);
//     });
//
//     // Simple session update handler - minimal processing
//     appKitModal!.onSessionUpdateEvent.subscribe((_) async {
//       debugPrint("Session update event triggered");
//
//
//       final newChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
//       final newAddress = _getFirstAddressFromSession();
//
//       bool shouldNotify = false;
//
//       if (newChainId != _lastKnowChainId) {
//         _lastKnowChainId = newChainId;
//         shouldNotify = true;
//       }
//
//       if (newAddress != null && newAddress != _walletAddress) {
//         _walletAddress = newAddress;
//         await prefs.setString('walletAddress', _walletAddress);
//         shouldNotify = true;
//       }
//
//       if (shouldNotify) {
//         notifyListeners();
//       }
//     });
//   }
//
//   Future<void> _handleDisconnect(SharedPreferences prefs) async {
//     // Only disconnect if we're actually disconnected
//     if (appKitModal?.session != null) {
//       debugPrint("Session still exists, not clearing state");
//       return;
//     }
//
//     debugPrint("Actually disconnecting - clearing state");
//
//     final prevAddress = _walletAddress;
//     if (prevAddress.isNotEmpty) {
//       await prefs.remove('web3_sig_$prevAddress');
//       await prefs.remove('web3_msg_$prevAddress');
//     }
//
//     _lastKnowChainId = null;
//     _isConnected = false;
//     _walletAddress = '';
//
//     _reconnectionTimer?.cancel();
//
//     await _removePersistedConnection();
//     await _clearWalletAndStageInfo();
//     await fetchLatestETHPrice();
//
//     notifyListeners();
//   }
//   /// Connect the wallet using the ReownAppKitModal UI.
//
//   Future<bool> connectWallet(BuildContext context) async {
//     if (_isLoading || _isReconnecting) return false;
//
//     _walletConnectedManually = true;
//     _isLoading = true;
//     notifyListeners();
//     final start = DateTime.now();
//
//     try {
//       // Ensure modal is initialized
//       if (appKitModal == null) {
//         await init(context);
//       }
//
//       // Check if already connected
//       if (_isConnected && appKitModal?.session != null) {
//         debugPrint("Already connected, skipping connection");
//         return true;
//       }
//
//       // Open modal and wait for connection
//       await appKitModal!.openModalView();
//
//       // Wait for connection with reasonable timeout
//       final connected = await _waitForConnection(timeout: const Duration(seconds: 2));
//       if (!connected) {
//         debugPrint("Connection timeout");
//         return false;
//       }
//
//       // await logRocketTrackBlockChainEvent(
//       //   "WALLET_ACTION",
//       //   "connectWallet",
//       //   "",
//       //   true,
//       //   DateTime.now().difference(start).inMilliseconds,
//       //   extra: {"walletAddress": _walletAddress},
//       // );
//
//       return true;
//
//     } catch (e,stack) {
//       // await logRocketTrackBlockChainEvent(
//       //   "WALLET_ACTION",
//       //   "connectWallet",
//       //   "",
//       //   false,
//       //   DateTime.now().difference(start).inMilliseconds,
//       //   extra: {"error": e.toString()},
//       // );
//        return _handleConnectionError(e);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<bool> openWalletModal(BuildContext context) async {
//     // 1) Always (re)create with the current valid context
//     await init(context);
//
//     try {
//       await appKitModal!.openModalView();
//       return true;
//     } catch (_) {
//
//       await reset();
//       await init(context);
//       await appKitModal!.openModalView();
//       return true;
//     }
//   }
//
//   bool _handleConnectionError(dynamic error) {
//     // logErrorToUxCam(error, StackTrace.current, "connectWallet(): Wallet Connection error");
//
//     final errorMsg = error.toString().toLowerCase();
//
//     if (errorMsg.contains("user rejected") ||
//         errorMsg.contains("user denied") ||
//         errorMsg.contains("user canceled") ||
//         errorMsg.contains("user cancelled") ||
//         errorMsg.contains("modal closed") ||
//         errorMsg.contains("wallet modal closed") ||
//         errorMsg.contains("no response from user")) {
//       ToastMessage.show(
//         message: "Connection Cancelled",
//         subtitle: "You cancelled the wallet connection.",
//         type: MessageType.info,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       return false;
//     } else {
//
//       ToastMessage.show(
//         message: "Connection Failed",
//         subtitle: "Please try connecting again.",
//         type: MessageType.error,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       return false;
//     }
//   }
//   /// Disconnect from the wallet and clear stored wallet info.
//   Future<void> disconnectWallet(BuildContext context) async {
//     if (appKitModal == null) return;
//     _isLoading = true;
//     _vestingTimer?.cancel();
//     notifyListeners();
//     try {
//       final prevAddress = _walletAddress;
//
//       if (_isConnected && appKitModal!.session != null) {
//         await appKitModal!.disconnect();
//       }
//
//       final prefs = await SharedPreferences.getInstance();
//       if (prevAddress.isNotEmpty) {
//         await prefs.remove('web3_sig_$prevAddress');
//         await prefs.remove('web3_msg_$prevAddress');
//       }
//
//       _lastKnowChainId = null;
//
//       await _removePersistedConnection();
//       await _clearWalletAndStageInfo(shouldNotify: false);
//        await fetchLatestETHPrice();
//     } catch (e, stack) {
//
//     } finally {
//
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//
//   Future<void> rehydrate() async {
//     if (_isLoading || _isSessionSettling) return;
//     _isLoading = true;
//     notifyListeners();
//     try {
//       await _hydrateFromExistingSession();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//   ///LifeCycle Functions
//
//   Future<void> _handleAppResume() async {
//     debugPrint("App resumed - checking wallet connection...");
//
//     if (appKitModal == null) {
//       debugPrint("AppKitModal is null, initializing...");
//       if (_lastContext != null) {
//         await init(_lastContext!);
//       }
//       return;
//     }
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final isConnected = prefs.getBool('isConnected') ?? false;
//
//       if (isConnected) {
//         debugPrint("Previous connection found, rehydrating...");
//         await _hydrateFromExistingSession();
//
//       } else {
//         debugPrint("No previous connection found");
//       }
//     } catch (e, stack) {
//
//
//       debugPrint("App resume error: $e\n$stack");
//     } finally {
//       notifyListeners();
//     }
//   }
//
//   Future<void> _handleAppPause() async {
//     debugPrint("App paused - saving session state...");
//
//     if (_isConnected && appKitModal?.session != null) {
//       final prefs = await SharedPreferences.getInstance();
//       final sessionJson = appKitModal!.session!.toJson();
//       await prefs.setString('walletSession', jsonEncode(sessionJson));
//       await prefs.setBool('isConnected', true);
//       await prefs.setString('walletAddress', _walletAddress);
//       if (_lastKnowChainId != null) {
//         await prefs.setString('chainId', _lastKnowChainId!);
//       }
//
//     }
//   }
//
//   Future<void> _handleAppDetached() async {
//     debugPrint("App detached - cleaning up...");
//      _reconnectionTimer?.cancel();
//   }
//
//   Future<void> _hydrateFromExistingSession() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final wasConnected = prefs.getBool('isConnected') ?? false;
//       final savedAddress = prefs.getString('walletAddress');
//
//       if (wasConnected && savedAddress != null && appKitModal?.session != null) {
//         debugPrint("Restoring existing wallet session");
//         _isConnected = true;
//         _walletAddress = savedAddress;
//
//         _lastKnowChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
//
//         await fetchConnectedWalletData();
//         await fetchLatestETHPrice();
//
//         notifyListeners();
//       }
//     } catch (e,stack) {
//
//       debugPrint("Error hydrating session: $e");
//     }
//   }
//
//   String? _getFirstAddressFromSession() {
//     final s = appKitModal?.session;
//     if (s == null) return null;
//     try {
//       final values = s.namespaces?.values;
//       if (values == null) return null;
//       for (final ns in values) {
//         if (ns.accounts.isNotEmpty) {
//           final parts = ns.accounts.first.split(':'); // eip155:11155111:0x...
//           if (parts.length >= 3) return parts[2];
//         }
//       }
//     } catch (e,stack) {
//
//
//     }
//     return null;
//   }
//
//   String? _getChainIdFromSession() {
//     final s = appKitModal?.session;
//     if (s == null) return null;
//     try {
//       final values = s.namespaces?.values;
//       if (values == null) return null;
//       for (final ns in values) {
//         if (ns.accounts.isNotEmpty) {
//           final parts = ns.accounts.first.split(':'); // eip155:11155111:0x...
//           if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
//         }
//       }
//     } catch (e, stack) {
//
//     }
//     return null;
//   }
//
//   String? getChainIdForRequests() {
//     return appKitModal?.selectedChain?.chainId ?? _lastKnowChainId ?? _getChainIdFromSession();
//   }
//
//   Future<void> _removePersistedConnection() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('isConnected');
//     await prefs.remove('walletAddress');
//     await prefs.remove('chainId');
//     await prefs.remove('walletSession');
//   }
//
//   Future<void> _clearWalletAndStageInfo({bool shouldNotify = true}) async {
//     _walletAddress = '';
//     _isConnected = false;
//     _balance = null;
//     _minimumStake = null;
//     _maximumStake = null;
//     _ethPrice = 0.0;
//
//
//
//     print("Wallet state and storage have been reset.");
//     if (shouldNotify) {
//       notifyListeners();
//     }
//   }
//
//   Future<void> reset() async {
//     _walletAddress = '';
//     _isConnected = false;
//     _balance = null;
//     _minimumStake = null;
//     _maximumStake = null;
//     _ethPrice = 0.0;
//
//     _walletConnectedManually = false;
//     _isModalEventsSubscribed = false;
//     _lastKnowChainId = null;
//
//      await _removePersistedConnection();
//
//     appKitModal?.onModalConnect.unsubscribeAll();
//     appKitModal?.onModalUpdate.unsubscribeAll();
//     appKitModal?.onModalDisconnect.unsubscribeAll();
//     appKitModal?.onSessionExpireEvent.unsubscribeAll();
//     appKitModal?.onSessionUpdateEvent.unsubscribeAll();
//
//     appKitModal = null;
//     print("Wallet state and storage have been reset.");
//     notifyListeners();
//   }
//
//   Future<void> fetchConnectedWalletData({bool isReconnecting = false}) async {
//      if (appKitModal == null || appKitModal!.session == null || appKitModal!.selectedChain == null) {
//       _clearWalletSpecificInfo(shouldNotify: !isReconnecting);
//       return;
//     }
//
//     if (!_isConnected) {
//       _clearWalletSpecificInfo(shouldNotify: !isReconnecting);
//       return;
//     }
//
//     final chainID = getChainIdForRequests();
//     if (chainID == null) {
//       await _clearWalletAndStageInfo(shouldNotify: !isReconnecting);
//       return;
//     }
//
//     final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//
//     final currentSessionAddress = appKitModal!.session!.getAddress(nameSpace);
//     if (currentSessionAddress == null || currentSessionAddress.isEmpty) {
//       await _clearWalletAndStageInfo(shouldNotify: !isReconnecting);
//       return;
//     }
//
//     _walletAddress = currentSessionAddress;
//
//     if (!isReconnecting && !_isLoading) {
//       _isLoading = true;
//       notifyListeners();
//     }
//     try {
//       debugPrint("Fetching connected wallet data for address: $_walletAddress");
//
//       // Fetch balance first
//       await getBalance();
//       await fetchLatestETHPrice();
//       await Future.wait([
//           getMinimunStake(),
//         getMaximumStake(),
//         getVestingInformation(),
//         getExistingVestingInformation()
//       ]);
//
//     } catch (e, stack) {
//
//       _clearWalletSpecificInfo(shouldNotify: true);
//     } finally {
//       if (!isReconnecting) {
//         _isLoading = false;
//         notifyListeners();
//       }
//     }
//   }
//
//   void _clearWalletSpecificInfo({bool shouldNotify = true}) {
//     _balance = null;
//     _minimumStake = null;
//     _maximumStake = null;
//     if (shouldNotify) {
//       notifyListeners();
//     }
//   }
//
//   Future<int> getTokenDecimals({required String contractAddress}) async {
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final abiData = jsonDecode(abiString);
//       final contract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(abiData), 'ECommerceCoin'),
//         EthereumAddress.fromHex(contractAddress),
//       );
//
//       final decimalsResult = await _web3Client!.call(
//         contract: contract,
//         function: contract.function('decimals'),
//         params: [],
//       );
//
//       final decimals = (decimalsResult[0] as BigInt).toInt();
//
//       // Validate the decimals value
//       if (decimals < 0 || decimals > 18) {
//         debugPrint("Invalid decimals returned from contract: $decimals, using default of 18");
//         return 18; // Return a safe default
//       }
//
//       debugPrint("Token decimals: $decimals");
//       return decimals;
//     } catch (e, stack) {
//
//        return 18;
//     }
//   }
//
//
//   Future<String> getMinimunStake() async {
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final decimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS);
//       print("Decimals for staking: $decimals");
//
//       final stakingContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'eCommerce Coin',
//         ),
//         EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE),
//       );
//
//       final minimumStakeResult = await _web3Client!.call(
//         contract: stakingContract,
//         function: stakingContract.function('minimumStake'),
//         params: [],
//       );
//       final min = (minimumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
//       _minimumStake = min.toDouble().toStringAsFixed(0);
//       print("Raw minimumStakeResult: ${minimumStakeResult[0]}");
//       return _minimumStake!;
//     } catch (e, stack) {
//
//       _minimumStake = null;
//       rethrow;
//     }
//   }
//
//   Future<String> getMaximumStake() async {
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final decimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS);
//
//
//       final stakingContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'eCommerce Coin',
//         ),
//         EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE),
//       );
//
//       final maximumStakeResult = await _web3Client!.call(
//         contract: stakingContract,
//         function: stakingContract.function('maximumStake'),
//         params: [],
//       );
//
//
//       final max = (maximumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
//       _maximumStake = max.toDouble().toStringAsFixed(0);
//       return _maximumStake!;
//     } catch (e, stack) {
//
//       _maximumStake = null;
//       rethrow;
//     }
//   }
//
//
//   Future<String> fetchLatestETHPrice({bool forceLoad = false}) async {
//     print('### fetchLatestETHPrice() called');
//     print('### forceLoad: $forceLoad');
//     const cacheDurationMs = 3 * 60 * 1000; // 3 minutes
//     final prefs = await SharedPreferences.getInstance();
//     final lastUpdated = prefs.getInt('ethPriceLastUpdated') ?? 0;
//     final cachedPrice = prefs.getString('ethPriceUSD');
//     final cachedRawPrice = prefs.getString('ethPriceRaw');
//
//
//     if (!forceLoad && cachedPrice != null && cachedRawPrice != null && DateTime.now().millisecondsSinceEpoch - lastUpdated < cacheDurationMs) {
//       _ethPrice = double.parse(cachedPrice);
//       rawPrice = BigInt.parse(cachedRawPrice);
//
//       notifyListeners();
//       return cachedPrice;
//     }
//
//     final start = DateTime.now();
//
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/AggregatorABI.json");
//       final abiData = jsonDecode(abiString);
//       const aggregatorAddress = AGGREGATO_RADDRESS;
//       final contract = DeployedContract(
//         ContractAbi.fromJson(
//             jsonEncode(abiData),
//             'EACAggregatorProxy'
//         ),
//         EthereumAddress.fromHex(aggregatorAddress),
//       );
//       final result = await _web3Client!.call(
//         contract: contract,
//         function: contract.function('latestAnswer'),
//          params: [],
//       );
//       print('##### fetchLatestETHPrice ####');
//       print('Test result: $result');
//
//       final newRawPrice = result[0] as BigInt;
//       print('RAW_PRICE : $rawPrice');
//       rawPrice = newRawPrice;
//
//
//
//       final ethUsdPrice = newRawPrice.toDouble() / 1e8;
//       final ethPerEcm = ECM_PRICE_USD / ethUsdPrice;
//        final price = ethPerEcm.toStringAsFixed(8);
//
//       print('RAW_PRICE 8 Decimal: $price');
//
//       await prefs.setString('ethPriceUSD', price);
//       await prefs.setInt('ethPriceLastUpdated', DateTime.now().millisecondsSinceEpoch);
//       await prefs.setString('ethPriceRaw', newRawPrice.toString());
//
//       await logRocketTrackBlockChainEvent(
//         "ECM_LATEST_PRICE",
//         "latestAnswer",
//         AGGREGATO_RADDRESS,
//         true,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "ethPriceUSD": ethUsdPrice.toString(),
//           "ecmPriceETH": price,
//         },
//       );
//
//       _ethPrice = double.parse(price);
//        notifyListeners();
//       return price;
//     } catch (e,stack) {
//       await logRocketTrackBlockChainEvent(
//         "ECM_LATEST_PRICE",
//         "latestAnswer",
//         AGGREGATO_RADDRESS,
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {"error": e.toString()},
//       );
//       if (cachedPrice != null) return cachedPrice;
//       throw Exception('Failed to fetch ETH price');
//     }
//   }
//
//   Future<String> getBalance({String? forAddress}) async {
//     final String? addressToQuery = forAddress ?? _walletAddress;
//
//     if (_web3Client == null) {
//       debugPrint("Web3Client not initialized for getBalance.");
//       throw Exception("Web3Client not initialized.");
//     }
//
//     if (addressToQuery == null || addressToQuery.isEmpty) {
//       debugPrint("No valid address provided to getBalance. User wallet: $_walletAddress, Optional param: $forAddress");
//       if (forAddress == null) {
//         _balance = "0";
//         notifyListeners();
//       }
//       return "0";
//     }
//     final start = DateTime.now();
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final abiData = jsonDecode(abiString);
//
//       final ecmTokenContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'ECommerceCoin',
//         ),
//         EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
//       );
//
//       // Get token decimals
//       final decimalsResult = await _web3Client!.call(
//         contract: ecmTokenContract,
//         function: ecmTokenContract.function('decimals'),
//         params: [],
//       );
//       final int tokenDecimals = (decimalsResult[0] as BigInt).toInt();
//       debugPrint("Token decimals: $tokenDecimals");
//
//       // Get balance
//       final balanceOfResult = await _web3Client!.call(
//         contract: ecmTokenContract,
//         function: ecmTokenContract.function('balanceOf'),
//         params: [EthereumAddress.fromHex(addressToQuery)],
//       );
//
//       final rawBalanceBigInt = balanceOfResult[0] as BigInt;
//       debugPrint('>>> Raw token balance for $addressToQuery: $rawBalanceBigInt');
//
//       String formattedBalance;
//       if (tokenDecimals == 18) {
//         formattedBalance = EtherAmount.fromBigInt(EtherUnit.wei, rawBalanceBigInt)
//             .getValueInUnit(EtherUnit.ether)
//             .toString();
//       } else {
//         final divisor = BigInt.from(10).pow(tokenDecimals);
//         final wholePart = rawBalanceBigInt ~/ divisor;
//         final fractionalPart = rawBalanceBigInt % divisor;
//         formattedBalance = "$wholePart.${fractionalPart.toString().padLeft(tokenDecimals, '0')}";
//         formattedBalance = formattedBalance.replaceAll(RegExp(r'\.0*$'), '')
//             .replaceAll(RegExp(r'(\.\d*?[1-9])0+$'), r'$1');
//       }
//
//
//       await logRocketTrackBlockChainEvent(
//         "WALLET_BALANCE",
//         "balanceOf",
//         ECM_TOKEN_CONTRACT_ADDRESS,
//         true,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "address": addressToQuery,
//           "balance": formattedBalance,
//         },
//       );
//
//       // Update the appropriate balance variable
//       if (forAddress == null) {
//         _balance = formattedBalance;
//         notifyListeners();
//       } else if (forAddress == _vestingAddress) {
//         _vestingContractBalance = formattedBalance;
//       } else {
//         _userWalletBalance = formattedBalance;
//       }
//
//       return formattedBalance;
//
//     } catch (e, stack) {
//        await logRocketTrackBlockChainEvent(
//         "WALLET_BALANCE",
//         "balanceOf",
//         ECM_TOKEN_CONTRACT_ADDRESS,
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "address": addressToQuery,
//         },
//       );
//        // Set default values on error`
//       if (forAddress == null) {
//         _balance = "0";
//         notifyListeners();
//       }
//       return "0";
//     }
//   }
//
//   bool isValidECMAmount(double ecmAmount) {
//     return ecmAmount >= 50;
//   }
//
//   BigInt? convertECMtoWei(double ecmAmount) {
//     try {
//       // Validation checks
//       if (ecmAmount <= 0) {
//         return null;
//       }
//
//
//       if (rawPrice == null) {
//         debugPrint("⛔️ Conversion failed: rawPrice is null.");
//         return null;
//       }
//
//       // Convert ECM amount to Wei (18 decimals)
//       final BigInt ecmAmountWei = BigInt.from(ecmAmount * 1e18);
//
//       // Convert ECM price USD to Wei (18 decimals)
//       final BigInt ecmPriceUSDWei = BigInt.from(ECM_PRICE_USD * 1e18);
//
//       // Calculate total USD needed = ECM amount * ECM price
//       final BigInt usdNeeded = (ecmAmountWei * ecmPriceUSDWei) ~/ BigInt.from(10).pow(ECM_DECIMALS);
//
//       // ETH price in USD (scaled properly with oracle decimals)
//       final BigInt ethPriceUSDWei = rawPrice! * BigInt.from(10).pow(ECM_DECIMALS - AGGREGATOR_DECIMALS);
//
//       // Calculate ETH needed in Wei
//       final BigInt ethNeededWei = (usdNeeded * BigInt.from(10).pow(ECM_DECIMALS) + ethPriceUSDWei - BigInt.one) ~/ ethPriceUSDWei;
//
//       debugPrint("✅ ECM to Wei conversion successful:");
//       debugPrint("  ECM Amount: $ecmAmount");
//       debugPrint("  ETH Needed (Wei): $ethNeededWei");
//       debugPrint("  ETH Needed (ETH): ${ethNeededWei / BigInt.from(10).pow(18)}");
//
//       return ethNeededWei;
//     } catch (e) {
//       return null;
//     }
//   }
//
//   Future<String?> buyECMWithETH({
//     required EtherAmount ethAmount,
//     required EthereumAddress referralAddress,
//     required BuildContext context
//   }) async {
//     final chainID = getChainIdForRequests();
//     print("buyECMWithETH Chaid Id ${chainID}");
//
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null || chainID == null) {
//       throw Exception("Wallet not Connected or selected chain not available.");
//     }
//     _isLoading = true;
//     notifyListeners();
//     final start = DateTime.now();
//
//     try {
//        final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//       final walletAddress = EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!);
//       final ethBalance = await _web3Client!.getBalance(walletAddress);
//
//       print("ethBalance : ${ethBalance}");
//       print("walletAddress : ${walletAddress}");
//
//       if(ethBalance.getInWei < ethAmount.getInWei){
//         ToastMessage.show(
//           message: "Insufficient ETH Balance",
//           subtitle: "Your ETH balance is too low for this purchase.",
//           type: MessageType.error,
//           duration: CustomToastLength.LONG,
//           gravity: CustomToastGravity.BOTTOM,
//         );
//         throw Exception("INSUFFICIENT_ETH_BALANCE");
//       }
//
//       final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final saleContract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(abiData),
//            'ECMCoinICO'),
//         EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
//       );
//
//
//       final result = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: saleContract,
//         functionName: 'buyECMWithETH',
//         transaction: Transaction(
//           from: walletAddress,
//           value: ethAmount,
//         ),
//         parameters: [referralAddress],
//       );
//       print('Transaction Hash: $result');
//       print("ethAmount.getInWei ${ethAmount.getInWei}");
//
//       print("Result : ethAmount ${ethAmount}");
//       print("Result : walletAddress ${walletAddress}");
//
//
//
//
//        //Poll until TX is confirmed
//        TransactionReceipt? receipt;
//        for (var i = 0; i < 20; i++) {
//          receipt = await _web3Client!.getTransactionReceipt(result);
//          if (receipt != null) break;
//          await Future.delayed(const Duration(seconds: 3));
//        }
//
//        if(receipt == null){
//          throw Exception("Failed to get transaction receipt.");
//        }
//        _lastTransactionHash = result;
//        if (receipt.status != true) {
//          ToastMessage.show(
//            message: "Purchase Failed",
//            subtitle: "Minimum 50 ECM tokens per purchase required.",
//            type: MessageType.error,
//            duration: CustomToastLength.LONG,
//            gravity: CustomToastGravity.BOTTOM,
//          );
//          return null;
//        }
//
//        // Parse transaction logs
//       final payload = await _parseTransactionLogs(receipt, saleContract ,walletAddress);
//       // Send Payload to API
//        await _sendPurchaseDataToApi(payload);
//
//
//        await logRocketTrackBlockChainEvent(
//          "TRANSACTION",
//          "buyECMWithETH",
//          SALE_CONTRACT_ADDRESS,
//          true,
//          DateTime.now().difference(start).inMilliseconds,
//          transactionHash: result,
//          extra: {
//            "walletAddress": walletAddress.hex,
//            "ethAmount": ethAmount.getInWei.toString(),
//            "referralAddress": referralAddress.hex,
//            "ecmAmount": payload['amount'].toString(),
//          },
//        );
//
//        ToastMessage.show(
//          message: "Purchase Successful",
//          subtitle: "ECM purchase completed successfully. Transaction hash: $result",
//          type: MessageType.success,
//          duration: CustomToastLength.LONG,
//          gravity: CustomToastGravity.BOTTOM,
//        );
//
//        await Future.wait([
//          fetchConnectedWalletData(),
//          fetchLatestETHPrice(),
//        ]);
//        return result;
//
//     } catch (e,stack) {
//       print("Error buying ECM with ETH: $e");
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "buyECMWithETH",
//         SALE_CONTRACT_ADDRESS,
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//         },
//       );
//
//       if (e.toString().contains("INSUFFICIENT_ETH_BALANCE")) {
//          return Future.error(e);
//       }
//       final isUserRejected = isUserRejectedError(e);
//
//       ToastMessage.show(
//         message: isUserRejected ? "Transaction Cancelled" : "Transaction Failed",
//         subtitle: isUserRejected
//             ? "You cancelled the transaction."
//             : "Could not complete the purchase. Please try again.",
//         type: isUserRejected ? MessageType.info : MessageType.error,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<Map<String, dynamic>> _parseTransactionLogs(
//       TransactionReceipt receipt,
//       DeployedContract contract,
//       EthereumAddress walletAddress,
//       ) async {
//     final payload = {
//       'hash': '0x${bytesToHex(receipt.transactionHash, include0x: false)}',
//       'buyer': walletAddress.hex,
//       'referrer': '',
//       'vestingWallet': '',
//       'amount': 0.0,
//       'paymentAmountETH': 0.0,
//       'ethUsdPriceUsed': 0.0,
//       'ecmPriceUSDUsed': 0.0,
//       'baseECM': 0.0,
//       'bonusECM': 0.0,
//       'referralECM': 0.0,
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//       'referralAddress': '',
//       'referee': '',
//       'refVesting': '',
//       'referralAmount': 0.0,
//     };
//
//     final saleAddrLc = SALE_CONTRACT_ADDRESS.toLowerCase();
//     final ecmPurchasedEvent = contract.event('ECMPurchased');
//     final referralRewardEvent = contract.event('ReferralRewardPaid');
//
//     for (final log in receipt.logs) {
//
//        if ((log.address?.hex.toLowerCase() ?? '') != saleAddrLc) continue;
//       try {
//         final logSignature = log.topics![0];
//         final eventSignature = bytesToHex(ecmPurchasedEvent.signature, include0x: true);
//
//         if (logSignature == eventSignature) {
//            final decoded = ecmPurchasedEvent.decodeResults(log.topics!, log.data!);
//
//           print("✅ ECMPurchased decoded event: $decoded");
//
//           // Map values into payload
//           payload['buyer'] = decoded[0].toString();
//           payload['referrer'] = decoded[1].toString();
//           payload['vestingWallet'] = decoded[2].toString();
//           payload['amount'] = (decoded[3] as BigInt).toDouble() / 1e18;
//           payload['paymentAmountETH'] = (decoded[4] as BigInt).toDouble() / 1e18;
//           payload['ethUsdPriceUsed'] = (decoded[5] as BigInt).toDouble() / 1e8;
//           payload['ecmPriceUSDUsed'] = (decoded[6] as BigInt).toDouble() / 1e18;
//           payload['baseECM'] = (decoded[7] as BigInt).toDouble() / 1e18;
//           payload['bonusECM'] = (decoded[8] as BigInt).toDouble() / 1e18;
//           payload['referralECM'] = (decoded[9] as BigInt).toDouble() / 1e18;
//         }
//       } catch (e,stackTrace) {
//         print('Error decoding ECMPurchased log: $e');
//
//       }
//
//       try {
//         final logSignature = log.topics![0];
//         final referralSignature = bytesToHex(referralRewardEvent.signature, include0x: true);
//
//         if (logSignature == referralSignature) {
//           final decodedReferral = referralRewardEvent.decodeResults(log.topics!, log.data!);
//           print("✅ ReferralRewardPaid decoded: $decodedReferral");
//
//           payload['referralAddress'] = decodedReferral[0].toString();
//           payload['referee'] = decodedReferral[1].toString();
//           payload['refVesting'] = decodedReferral[2].toString();
//           payload['referralAmount'] = (decodedReferral[3] as BigInt).toDouble() / 1e18;
//         }
//       } catch (e, stackTrace) {
//        }
//     }
//
//     return payload;
//   }
//
//   Future<void> _sendPurchaseDataToApi(Map<String, dynamic> payload) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     final headers = {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//       if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
//     };
//
//     const payloadApi = API_ENDPOINT;
//
//     final response = await http.post(
//       Uri.parse('$payloadApi/purchase-ecm-completed'),
//       headers: headers,
//       body: jsonEncode(payload),
//     );
//     print("API Response: ${response.statusCode} ${response.body}");
//
//     if(response.statusCode != 201){
//       throw Exception('Failed to send purchase data to API: ${response.statusCode}- ${response.body}');
//     }else{
//       debugPrint("✅ Purchase data sent successfully: ${response.body}");
//     }
//
//   }
//
//   Future<String?> stakeNow(BuildContext context, double amount, int planIndex, {String referrerAddress = '0x0000000000000000000000000000000000000000'}) async {
//     final chainID = getChainIdForRequests();
//
//     /// Modal Check
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null || chainID == null) {
//       ToastMessage.show(
//         message: "Wallet Error",
//         subtitle: "Please connect your wallet before staking.",
//         type: MessageType.error,
//       );
//       throw Exception("Wallet not connected or chain not selected.");
//     }
//
//     if (amount <= 0 || planIndex < 0) {
//       ToastMessage.show(
//         message: "Invalid Input",
//         subtitle: "Please enter a valid amount and select a plan",
//         type: MessageType.info,
//       );
//       return null;
//     }
//
//     _isLoading = true;
//     notifyListeners();
//     final start = DateTime.now();
//
//     try {
//       /// Contract data setup
//
//       final tokenAbiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final stakingAbiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//       print(">> ABIs loaded.");
//
//       final ecmTokenContract = DeployedContract(
//           ContractAbi.fromJson(jsonEncode(jsonDecode(tokenAbiString)),
//               'eCommerce Coin'
//               // 'ECommerceCoin'
//           ),
//           EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS));
//
//       final stakingContract = DeployedContract(
//           ContractAbi.fromJson(jsonEncode(jsonDecode(stakingAbiString)), 'eCommerce Coin'),
//           EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE));
//
//       final stakeFunction = stakingContract.function('stake');
//       print('>> Staking function: ${stakeFunction.name}');
//
//       for (int i = 0; i < stakeFunction.parameters.length; i++) {
//         final param = stakeFunction.parameters[i];
//
//       }
//
//       final tokenDecimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS);
//       final multiplier = Decimal.parse('1e$tokenDecimals');
//       final stakeAmount = (Decimal.parse(amount.toString()) * multiplier).toBigInt();
//
//
//       /// Approval Transaction
//       ToastMessage.show(
//         message: "Step 1 of 2: Approval",
//         subtitle: "Please approve the token spending in your wallet.",
//         type: MessageType.info,
//         duration: CustomToastLength.LONG,
//       );
//
//       final approveStart = DateTime.now();
//       final dynamic approveTxResult = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: ecmTokenContract,
//         functionName: 'approve',
//         transaction: Transaction(from: EthereumAddress.fromHex(_walletAddress)),
//         parameters: [
//           EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE),
//           stakeAmount,
//         ],
//       );
//
//       String approveTxHash;
//       if (approveTxResult is String) {
//         approveTxHash = approveTxResult;
//       } else if (approveTxResult is Uint8List) {
//         approveTxHash = bytesToHex(approveTxResult);
//       } else {
//         throw Exception("Unexpected type for approve transaction hash: ${approveTxResult.runtimeType}");
//       }
//
//
//       /// Wait for approval confirmation
//
//       final approveReceipt = await _waitForTransaction(approveTxHash);
//       if (approveReceipt == null) {
//         throw Exception("Approval transaction failed or timed out.");
//       }
//
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "approve",
//         ECM_TOKEN_CONTRACT_ADDRESS,
//         true,
//         DateTime.now().difference(approveStart).inMilliseconds,
//         transactionHash: approveTxHash,
//         extra: {
//           "walletAddress": _walletAddress,
//           "stakeAmount": stakeAmount.toString(),
//         },
//       );
//       ToastMessage.show(
//         message: "Approval Successful!",
//         subtitle: "Now confirming the stake transaction.",
//         type: MessageType.success,
//       );
//
//       /// Stake Transaction
//       ToastMessage.show(
//         message: "Step 2 of 2: Staking",
//         subtitle: "Please confirm the transaction in your wallet.",
//         type: MessageType.info,
//         duration: CustomToastLength.LONG,
//       );
//       final stakeStart = DateTime.now();
//       final dynamic stakeTxResult = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: stakingContract,
//         functionName: 'stake',
//         transaction: Transaction(from: EthereumAddress.fromHex(_walletAddress)),
//         parameters: [
//           stakeAmount,
//           BigInt.from(planIndex),
//           EthereumAddress.fromHex(referrerAddress),
//         ],
//       );
//
//       String stakeTxHash;
//       if (stakeTxResult is String) {
//         stakeTxHash = stakeTxResult;
//       } else if (stakeTxResult is Uint8List) {
//         stakeTxHash = bytesToHex(stakeTxResult);
//       } else {
//         throw Exception("Unexpected type for stake transaction hash: ${stakeTxResult.runtimeType}");
//       }
//
//       final stakeReceipt = await _waitForTransaction(stakeTxHash);
//       if (stakeReceipt == null) {
//         throw Exception("Stake transaction failed or timed out.");
//       }
//
//       /// Post-Transaction & Event Parsing
//       final stakeEvent = stakingContract.event('Staked');
//       print(">> Parsing logs for 'Staked' event...");
//
//       bool successShown = false;
//       final stakeEventSignatureHex = bytesToHex(stakeEvent.signature);
//       for (final log in stakeReceipt.logs) {
//         try {
//           if (log.topics != null && log.topics!.isNotEmpty) {
//             final firstTopic = log.topics!.first;
//
//
//             if (firstTopic == null) {
//               continue;
//             }
//
//             String firstTopicHex;
//
//
//             if (firstTopic is Uint8List) {
//               firstTopicHex = bytesToHex(firstTopic as Uint8List);
//             } else if (firstTopic is List<int>) {
//               firstTopicHex = bytesToHex(Uint8List.fromList(firstTopic as List<int>));
//             } else if (firstTopic is String) {
//
//               final bytes = hexToBytes(firstTopic);
//               firstTopicHex = bytesToHex(bytes);
//             } else {
//               continue;
//             }
//
//             final stakeEventHex = bytesToHex(stakeEvent.signature);
//
//
//             if (firstTopicHex.toLowerCase() == stakeEventHex.toLowerCase()) {
//               print(">> Matched 'Staked' event log");
//
//               final decodedLog = stakeEvent.decodeResults(log.topics!, log.data!);
//               final payload = {
//                 'hash': bytesToHex(stakeReceipt.transactionHash),
//                 'staker': (decodedLog[0] as EthereumAddress).hex,
//                 'stakeId': (decodedLog[1] as BigInt).toString(),
//                 'amount': EtherAmount.fromUnitAndValue(EtherUnit.wei, decodedLog[2] as BigInt)
//                     .getValueInUnit(EtherUnit.ether)
//                     .toString(),
//                 'planIndex': (decodedLog[3] as BigInt).toString(),
//                 'endTime': (decodedLog[4] as BigInt).toString(),
//               };
//
//               await logRocketTrackBlockChainEvent(
//                 "TRANSACTION",
//                 "stake",
//                 STAKING_CONTRACT_ADDRESSLIVE,
//                 true,
//                 DateTime.now().difference(stakeStart).inMilliseconds,
//                 transactionHash: stakeTxHash,
//                 extra: {
//                   "walletAddress": _walletAddress,
//                   "stakeAmount": stakeAmount.toString(),
//                   "planIndex": planIndex.toString(),
//                   "referrerAddress": referrerAddress,
//                   "stakeId": payload['stakeId'],
//                 },
//               );
//
//               final apiUrl = '${ApiConstants.baseUrl}/staking-created';
//               final prefs = await SharedPreferences.getInstance();
//               final token = prefs.getString('token');
//
//               try {
//                 final response = await http.post(
//                   Uri.parse(apiUrl),
//                   headers: {
//                     'Content-Type': 'application/json',
//                     'Accept': 'application/json',
//                     if (token != null) 'Authorization': 'Bearer $token',
//                   },
//                   body: jsonEncode(payload),
//                 );
//                  print(">> Response body: ${response.body}");
//                 final postToken = prefs.getString('token');
//                 print(">> Token AFTER response: $postToken");
//
//                 if (response.statusCode != 200 && response.statusCode != 201) {
//                   throw Exception("Failed to sync stake to backend: ${response.statusCode}");
//                 }
//               } catch (e) {
//                 print(">> HTTP POST failed: $e");
//               }
//
//               ToastMessage.show(
//                 message: "Staking Successful!",
//                 subtitle: "Your tokens have been staked.",
//                 type: MessageType.success,
//                 duration: CustomToastLength.LONG,
//               );
//
//               await fetchConnectedWalletData();
//               successShown = true;
//               return bytesToHex(stakeReceipt.transactionHash);
//             }
//           } else {
//             print(">> Skipping log with empty or null topics.");
//           }
//         } catch (e, stackTrace) {
//           print(">> Error decoding log: $e");
//          }
//       }
//
//       if (!successShown) {
//         await logRocketTrackBlockChainEvent(
//           "TRANSACTION",
//           "stake",
//           STAKING_CONTRACT_ADDRESSLIVE,
//           true,
//           DateTime.now().difference(stakeStart).inMilliseconds,
//           transactionHash: stakeTxHash,
//           extra: {
//             "walletAddress": _walletAddress,
//             "stakeAmount": stakeAmount.toString(),
//             "planIndex": planIndex.toString(),
//             "note": "No Staked event found",
//           },
//         );
//
//         ToastMessage.show(
//           message: "Staking Success (No Event Found)",
//           subtitle: "Stake transaction confirmed, but event not parsed.",
//           type: MessageType.success,
//         );
//         await fetchConnectedWalletData();
//         return bytesToHex(stakeReceipt.transactionHash);
//       }
//
//       return null;
//     } catch (e, stackTrace) {
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "stake",
//         STAKING_CONTRACT_ADDRESSLIVE,
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//           "stakeAmount": amount.toString(),
//           "planIndex": planIndex.toString(),
//         },
//       );
//       final isUserRejected = isUserRejectedError(e);
//       ToastMessage.show(
//         message: isUserRejected ? "Transaction Cancelled" : "Staking Failed",
//         subtitle: isUserRejected
//             ? "You cancelled the transaction in your wallet."
//             : "An error occurred during staking.",
//         type: isUserRejected ? MessageType.info : MessageType.error,
//         duration: CustomToastLength.LONG,
//       );
//       return null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//
//   }
//
//   Future<String?> forceUnstake(int stakeId)async{
//     final chainID = getChainIdForRequests();
//
//     if (!_isConnected || appKitModal?.session == null || chainID == null) {
//       ToastMessage.show(message: "Connect wallet first.", type: MessageType.error);
//       return null;
//     }
//     _isLoading = true;
//     notifyListeners();
//     final start = DateTime.now();
//
//     try{
//
//       final stakingAbiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//       final stakingContract = DeployedContract(
//         ContractAbi.fromJson(stakingAbiString, 'eCommerce Coin'),
//         EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE),
//       );
//
//       /// Call forceUnstake function on contract
//       final txResult = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: stakingContract,
//         functionName: 'forceUnstake',
//         transaction: Transaction(
//           from: EthereumAddress.fromHex(_walletAddress),
//         ),
//         parameters: [BigInt.from(stakeId)],
//
//       );
//
//       final txHash = txResult is String ? txResult : bytesToHex(txResult);
//       final receipt = await _waitForTransaction(txHash);
//       if(receipt == null) throw Exception("Transaction failed or time out");
//
//
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "forceUnstake",
//         STAKING_CONTRACT_ADDRESSLIVE,
//         true,
//         DateTime.now().difference(start).inMilliseconds,
//         transactionHash: txHash,
//         extra: {
//           "walletAddress": _walletAddress,
//           "stakeId": stakeId.toString(),
//         },
//       );
//
//       /// Parse logs for Unstaked and ReferralCommissionPaid events
//       final unstakedEvent = stakingContract.event('Unstaked');
//       final referralEvent = stakingContract.event('ReferralCommissionPaid');
//
//       for (final log in receipt.logs){
//         try{
//           if(log.topics == null || log.data == null) continue;
//           final topics = log.topics!;
//           final data = log.data!;
//
//           if(topics.isEmpty) continue;
//
//           /// Check Event Signature match
//           final topic0 = topics[0];
//           late final String topic0Hex;
//
//           if (topic0 is Uint8List) {
//             topic0Hex = bytesToHex(topic0 as Uint8List);
//           } else if (topic0 is List<int>) {
//             topic0Hex = bytesToHex(Uint8List.fromList(topic0 as List<int>));
//           } else if (topic0 is String) {
//             final decoded = hexToBytes(topic0);
//             topic0Hex = bytesToHex(decoded);
//           } else {
//             continue;
//           }
//
//
//           final unstakedSig  = bytesToHex(unstakedEvent.signature);
//           final referralSig = bytesToHex(referralEvent.signature);
//
//           if(topic0Hex.toLowerCase() == unstakedSig.toLowerCase()){
//             final decoded = unstakedEvent.decodeResults(topics, data);
//             await unStakeCreate(txHash, decoded);
//           }else if (topic0Hex.toLowerCase() == referralSig.toLowerCase()) {
//             final decoded = referralEvent.decodeResults(topics, data);
//             await unStakeReferral(txHash, decoded);
//           }
//         }catch(e, stackTrace){
//           print("Error decoding log: $e");
//          }
//       }
//
//
//       await fetchConnectedWalletData();
//       await getBalance();
//       ToastMessage.show(message: "Force unstake successful!", type: MessageType.success);
//       return txHash;
//     }catch(e, stackTrace){
//
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "forceUnstake",
//         STAKING_CONTRACT_ADDRESSLIVE,
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//           "stakeId": stakeId.toString(),
//         },
//       );
//
//        final isUserRejected = isUserRejectedError(e);
//       ToastMessage.show(
//         message: isUserRejected ? "Transaction Cancelled" : "Force Unstake Failed",
//         subtitle: isUserRejected
//             ? "You cancelled the transaction in your wallet."
//             : "An error occurred during force unstake.",
//         type: isUserRejected ? MessageType.info : MessageType.error,
//         duration: CustomToastLength.LONG,
//       );
//
//       return null;
//     }finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//
//   }
//
//   Future<String?> unstake(int stakeId) async {
//     final chainID = getChainIdForRequests();
//
//     if (!_isConnected || appKitModal?.session == null || chainID == null) {
//       ToastMessage.show(message: "Connect wallet first.", type: MessageType.error);
//       return null;
//     }
//
//     _isLoading = true;
//     notifyListeners();
//     final start = DateTime.now();
//
//     try {
//
//       final stakingAbiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//       final stakingContract = DeployedContract(
//         ContractAbi.fromJson(stakingAbiString, 'eCommerce Coin'),
//         EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE),
//       );
//
//       final txResult = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: stakingContract,
//         functionName: 'unstake',
//         transaction: Transaction(
//           from: EthereumAddress.fromHex(_walletAddress),
//         ),
//         parameters: [BigInt.from(stakeId)],
//       );
//
//       final txHash = txResult is String ? txResult : bytesToHex(txResult);
//       final receipt = await _waitForTransaction(txHash);
//       if (receipt == null) throw Exception("Transaction failed or timed out");
//
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "unstake",
//         STAKING_CONTRACT_ADDRESSLIVE,
//         true,
//         DateTime.now().difference(start).inMilliseconds,
//         transactionHash: txHash,
//         extra: {
//           "walletAddress": _walletAddress,
//           "stakeId": stakeId.toString(),
//         },
//       );
//
//       final unstakedEvent = stakingContract.event('Unstaked');
//       final referralEvent = stakingContract.event('ReferralCommissionPaid');
//
//       for (final log in receipt.logs) {
//         try {
//           if (log.topics == null || log.data == null) continue;
//           final topics = log.topics!;
//           final data = log.data!;
//
//           if (topics.isEmpty) continue;
//
//           final topic0 = topics[0];
//           late final String topic0Hex;
//
//           if (topic0 is Uint8List) {
//             topic0Hex = bytesToHex(topic0 as List<int>);
//           } else if (topic0 is List<int>) {
//             topic0Hex = bytesToHex(Uint8List.fromList(topic0 as List<int>));
//           } else if (topic0 is String) {
//             final decoded = hexToBytes(topic0);
//             topic0Hex = bytesToHex(decoded);
//           } else {
//             continue;
//           }
//
//           final unstakedSig = bytesToHex(unstakedEvent.signature);
//           final referralSig = bytesToHex(referralEvent.signature);
//
//           if (topic0Hex.toLowerCase() == unstakedSig.toLowerCase()) {
//             final decoded = unstakedEvent.decodeResults(topics, data);
//             await unStakeCreate(txHash, decoded);
//           } else if (topic0Hex.toLowerCase() == referralSig.toLowerCase()) {
//             final decoded = referralEvent.decodeResults(topics, data);
//             await unStakeReferral(txHash, decoded);
//           }
//         } catch (e, stackTrace) {
//           print("Error decoding log: $e");
//          }
//       }
//
//       await fetchConnectedWalletData();
//       await getBalance();
//
//       ToastMessage.show(message: "Unstake successful!", type: MessageType.success);
//       return txHash;
//     } catch (e, stackTrace) {
//
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "unstake",
//         STAKING_CONTRACT_ADDRESSLIVE,
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//           "stakeId": stakeId.toString(),
//         },
//       );
//
//        final isUserRejected = isUserRejectedError(e);
//       ToastMessage.show(
//         message: isUserRejected ? "Transaction Cancelled" : "Unstake Failed",
//         subtitle: isUserRejected
//             ? "You cancelled the transaction in your wallet."
//             : "An error occurred during unstaking.",
//         type: isUserRejected ? MessageType.info : MessageType.error,
//         duration: CustomToastLength.LONG,
//       );
//       return null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> unStakeCreate(String hash, List<dynamic> decodedLog) async {
//     final payload = {
//       'unstake_hash': hash,
//       'stakeId': (decodedLog[1] as BigInt).toString(),
//       'amount': EtherAmount.fromUnitAndValue(EtherUnit.wei, decodedLog[2] as BigInt).getValueInUnit(EtherUnit.ether).toString(),
//       'rewardAmount': EtherAmount.fromUnitAndValue(EtherUnit.wei, decodedLog[3] as BigInt).getValueInUnit(EtherUnit.ether).toString(),
//       'unstakeType': decodedLog[4],
//     };
//
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     final response = await http.post(
//       Uri.parse('${ApiConstants.baseUrl}/unstake-created'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         if (token != null) 'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode(payload),
//     );
//     if (response.statusCode != 200 && response.statusCode != 201) {
//       throw Exception('Failed to sync unstake create');
//     }
//   }
//
//   Future<void> unStakeReferral(String hash, List<dynamic> decodedLog) async {
//     final payload = {
//       'hash': hash,
//       'referral': decodedLog[0].toString(),
//       'staker': decodedLog[1].toString(),
//       'stakeId': (decodedLog[2] as BigInt).toString(),
//       'amount': EtherAmount.fromUnitAndValue(EtherUnit.wei, decodedLog[3] as BigInt).getValueInUnit(EtherUnit.ether).toString(),
//     };
//
//
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     final response = await http.post(
//       Uri.parse('${ApiConstants.baseUrl}/unstake-referral-reward'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         if (token != null) 'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode(payload),
//     );
//     if (response.statusCode != 200 && response.statusCode != 201) {
//       throw Exception('Failed to sync unstake referral');
//     }
//   }
//
//   Future<void> getVestingInformation() async {
//
//     if (!_isConnected || _walletAddress.isEmpty) return;
//
//     // _isLoading = true;
//     notifyListeners();
//     final start = DateTime.now();
//
//     try {
//       final chainId = getChainIdForRequests();
//       if (chainId == null) throw Exception('Chain ID is not available.');
//
//       final saleContractAbiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//       final saleContractAbiData = jsonDecode(saleContractAbiString);
//       final saleContract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(saleContractAbiData), 'ECMCoinICO'),
//         EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
//       );
//
//       final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//       final walletAddressHex = appKitModal?.session?.getAddress(nameSpace);
//       if (walletAddressHex == null) throw Exception('Wallet address is null.');
//
//       final userWalletAddress = EthereumAddress.fromHex(walletAddressHex);
//
//       // vestingOf function on the Sale Contract
//       final vestingOfResult = await _web3Client!.call(
//         contract: saleContract,
//         function: saleContract.function('vestingOf'),
//         params: [userWalletAddress],
//       );
//
//       final vestingContractAddress = vestingOfResult[0] as EthereumAddress;
//       final zeroAddress = EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');
//
//       await logRocketTrackBlockChainEvent(
//         "VESTING_INFO",
//         "vestingOf",
//         SALE_CONTRACT_ADDRESS,
//         true,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "walletAddress": userWalletAddress.hex,
//           "vestingContractAddress": vestingContractAddress.hex,
//         },
//       );
//
//       if (vestingContractAddress == zeroAddress) {
//         // No vesting contract for user
//         _vestingAddress = null;
//         _vestingStatus = null;
//       } else {
//         _vestingAddress = vestingContractAddress.hex;
//         await _resolveVestedStart(vestingContractAddress);
//       }
//     } catch (e, stackTrace) {
//
//       await logRocketTrackBlockChainEvent(
//         "VESTING_INFO",
//         "vestingOf",
//         SALE_CONTRACT_ADDRESS,
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//         },
//       );
//
//        _vestingAddress = null;
//       _vestingStatus = null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> _resolveVestedStart(EthereumAddress vestingContractAddress) async {
//     final start = DateTime.now();
//
//     try {
//       print("fetching vestingContract Address : ${vestingContractAddress.hex}");
//
//       if (_web3Client == null) {
//          _vestingAddress = null;
//         notifyListeners();
//         return;
//       }
//
//       final vestingAbiString = await rootBundle.loadString("assets/abi/VestingABI.json");
//       final vestingAbiData = jsonDecode(vestingAbiString);
//
//       final vestedContract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(vestingAbiData), 'LinearVestingWallet'),
//         vestingContractAddress,
//       );
//
//       final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//
//
//       final startResult = await _web3Client!.call(contract: vestedContract, function: vestedContract.function('start'), params: []);
//       print("   Raw start: ${startResult[0]}");
//
//        final cliffResult = await _web3Client!.call(contract: vestedContract, function: vestedContract.function('cliff'), params: []);
//       print("   Raw cliff: ${cliffResult[0]}");
//
//        final durationResult = await _web3Client!.call(contract: vestedContract, function: vestedContract.function('duration'), params: []);
//       print("   Raw duration: ${durationResult[0]}");
//
//       //'released' function that takes no parameters
//       final releasedFunction = vestedContract.findFunctionsByName('released').firstWhere((func) => func.parameters.isEmpty);
//       final releasedResult = await _web3Client!.call(contract: vestedContract, function: releasedFunction, params: []);
//       print("   Raw released: ${releasedResult[0]}");
//
//       //'vestedAmount' function that takes one parameter (timestamp)
//       final vestedAmountFunction = vestedContract.findFunctionsByName('vestedAmount').firstWhere((func) => func.parameters.length == 1,);
//       final claimableResult = await _web3Client!.call(contract: vestedContract, function: vestedAmountFunction, params: [BigInt.from(now)]);
//       print("Raw vestedAmount (claimable): ${claimableResult[0]}");
//
//
//       final startVal = (startResult[0] as BigInt).toInt();
//       final cliff = (cliffResult[0] as BigInt).toInt();
//       final duration = (durationResult[0] as BigInt).toInt();
//       final released = (releasedResult[0] as BigInt);
//       final claimable = (claimableResult[0] as BigInt);
//
//
//       print("start: $startVal");
//       print("cliff: $cliff");
//       print("duration: $duration");
//       print("released: $released");
//       print("claimable: $claimable");
//
//       vestInfo.start = startVal;
//       vestInfo.cliff = cliff;
//       vestInfo.duration = duration;
//       vestInfo.released = released .toDouble();
//       vestInfo.claimable = claimable.toDouble();
//       vestInfo.end = startVal + duration;
//       _vestingStatus = startVal > now ? 'locked' : 'process';
//
//       await logRocketTrackBlockChainEvent(
//         "VESTING_DURATIONS",
//         "resolveVestedStart",
//         vestingContractAddress.hex,
//         true,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "walletAddress": _walletAddress,
//           "vestingAddress": vestingContractAddress.hex,
//           "start": startVal.toString(),
//           "cliff": cliff.toString(),
//           "duration": duration.toString(),
//           "released": released.toString(),
//           "claimable": claimable.toString(),
//         },
//       );
//
//       notifyListeners();
//
//     } catch (e, stackTrace) {
//       await logRocketTrackBlockChainEvent(
//         "VESTING_DURATIONS",
//         "resolveVestedStart",
//         vestingContractAddress.hex,
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//           "vestingAddress": vestingContractAddress.hex,
//         },
//       );
//        _vestingStatus = null;
//       notifyListeners();
//     }
//   }
//
//   Future<void>claimECM(BuildContext context)async{
//     if (_isLoading || !_isConnected || _vestingAddress == null) return;
//
//     _isLoading = true;
//     notifyListeners();
//     final start = DateTime.now();
//
//     try{
//       // 1. Get the ABI and create a DeployedContract instance
//       final abiString = await rootBundle.loadString("assets/abi/VestingABI.json");
//       final abiData = jsonDecode(abiString);
//       final vestingContract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(abiData), 'LinearVestingWallet'),
//         EthereumAddress.fromHex(_vestingAddress!),
//       );
//
//       // 2. Get the current chain and wallet address
//       final chainId = getChainIdForRequests();
//       if (chainId == null) {
//         throw Exception("Selected chain not available.");
//       }
//       final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//       final walletAddress = appKitModal!.session!.getAddress(nameSpace);
//       if (walletAddress == null) {
//         throw Exception("Wallet address not found.");
//       }
//
//       // 3. Request the transaction via the AppKitModal
//       print('Attempting to claim ECM from vesting contract...');
//       final txResult = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainId,
//         deployedContract: vestingContract,
//         functionName: 'claim',
//         transaction: Transaction(from: EthereumAddress.fromHex(walletAddress)),
//         parameters: [],
//       );
//
//
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "claim",
//         _vestingAddress!,
//         true,
//         DateTime.now().difference(start).inMilliseconds,
//         transactionHash: txResult,
//         extra: {
//           "walletAddress": walletAddress,
//           "vestingAddress": _vestingAddress!,
//         },
//       );
//
//       print('Transaction Hash: $txResult');
//
//       ToastMessage.show(
//         message: "Your ECM tokens have been claimed successfully.",
//         subtitle: "Transaction hash: $txResult.",
//         type: MessageType.success,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//
//       // 4. Automatically refresh vesting data after a successful claim
//       await refreshVesting();
//     } catch (e, stackTrace) {
//
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "claim",
//         _vestingAddress ?? "unknown",
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//           "vestingAddress": _vestingAddress ?? "none",
//         },
//       );
//
//        print('Error during claimECM: $e');
//       final errorMessage = e.toString().contains("User rejected")
//           ? "Transaction rejected by user."
//           : "Claim failed. Please try again.";
//
//       ToastMessage.show(
//         message: "Claim Failed",
//         subtitle: errorMessage,
//         type: MessageType.error,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // Get the latest vesting data.
//   Future<void> refreshVesting() async {
//     if (_isLoading || _vestingAddress == null) return;
//     _isLoading = true;
//     notifyListeners();
//     final start = DateTime.now();
//
//     try{
//       // 1. Get the ABI and create a DeployedContract instance
//       final abiString = await rootBundle.loadString("assets/abi/VestingABI.json");
//       final abiData = jsonDecode(abiString);
//       final vestingContract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(abiData), 'LinearVestingWallet'),
//         EthereumAddress.fromHex(_vestingAddress!),
//       );
//
//       // 2. Read the `released()` value from the contract
//       final releasedResult = await _web3Client!.call(
//         contract: vestingContract,
//         function: vestingContract.function('released'),
//         params: [],
//       );
//
//       // Convert the BigInt to a double and format to 6 decimal places,
//       final releasedWei = releasedResult[0] as BigInt;
//
//       final releasedEther = EtherAmount.fromBigInt(EtherUnit.wei, releasedWei).getValueInUnit(EtherUnit.ether);
//
//       final releasedAmountFormatted = releasedEther.toStringAsFixed(6);
//
//       await logRocketTrackBlockChainEvent(
//         "CONTRACT_CALL",
//         "released",
//         _vestingAddress!,
//         true,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "walletAddress": _walletAddress,
//           "vestingAddress": _vestingAddress!,
//           "releasedAmount": releasedAmountFormatted,
//         },
//       );
//
//       // Update Vesting Info Model to reflect new data
//       vestInfo.released = releasedEther;
//
//       ToastMessage.show(
//         message: "Vesting Refreshed",
//         subtitle: "Latest vesting data has been updated.",
//         type: MessageType.success,
//         duration: CustomToastLength.SHORT,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       print("Vesting refreshed successfully , Released :$releasedAmountFormatted ");
//
//
//     } catch (e, stackTrace) {
//
//       await logRocketTrackBlockChainEvent(
//         "CONTRACT_CALL",
//         "released",
//         _vestingAddress ?? "unknown",
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//           "vestingAddress": _vestingAddress ?? "none",
//         },
//       );
//
//        final errorMessage = e.toString().contains('no contract')
//           ? 'Vesting contract not found or invalid address.'
//           : e.toString();
//
//       ToastMessage.show(
//         message: "Refresh Failed",
//         subtitle: "Could not fetch latest vesting data. $errorMessage",
//         type: MessageType.error,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//
//   }
//
//   // Getter to calculate the total amount of ECM vested so far
//   double get vestedAmount {
//     if (vestInfo.start == 0 || vestInfo.end == 0 || balance == null) return 0.0;
//
//     final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//     final start = vestInfo.start;
//     final end = vestInfo.end;
//     final duration = vestInfo.duration;
//
//     final totalVestingECM = double.tryParse(balance!) ?? 0.0;
//
//     if (nowSec <= start!) {
//       return 0.0;
//     }
//     if (nowSec >= end!) {
//       return totalVestingECM;
//     }
//
//     final elapsed = nowSec - start;
//     final calculatedAmount = (totalVestingECM * elapsed) / duration!;
//     return double.parse(calculatedAmount.toStringAsFixed(6));
//   }
//
//   // Getter to calculate the amount of ECM available for claim
//   double get availableClaimableAmount {
//     final vested = vestedAmount;
//     final released = vestInfo.released;
//     final available = vested - released!;
//     return available > 0 ? available : 0.0;
//   }
//
//
//   /// Existing User Vesting
//   Future<String?> startVesting(BuildContext context)async{
//     if(_isLoading || !_isConnected || _vestingAddress == null) {
//       ToastMessage.show(
//         message: "Wallet Connection Lost",
//         subtitle: "Please connect your wallet to start vesting.",
//         type: MessageType.error,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       return null;
//     }
//
//     final balance = double.tryParse(_balance ?? '0') ?? 0;
//     if(balance <= 1){
//       ToastMessage.show(
//         message: "Insufficient ECM Balance",
//         subtitle: "You need at least 1 ECM to start vesting.",
//         type: MessageType.error,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       return null;
//     }
//
//     _isLoading = true;
//     notifyListeners();
//     final start = DateTime.now();
//
//     try{
//       final chainId = getChainIdForRequests();
//       print('startVesting: Chain ID = $chainId');
//       if (chainId == null) {
//         throw Exception("Selected chain not available.");
//       }
//
//       final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//       final walletAddress = appKitModal!.session!.getAddress(nameSpace);
//       print('startVesting: Wallet Address = $walletAddress');
//       if(walletAddress == null){
//         throw Exception("Wallet address not found.");
//       }
//
//       // Load ABI
//       final tokenAbiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final vestingAbiString = await rootBundle.loadString("assets/abi/ExitingVestingABI.json");
//       final tokenAbiData = jsonDecode(tokenAbiString);
//       final vestingAbiData = jsonDecode(vestingAbiString);
//
//       //Initialize Contracts
//       final ecmTokenContract = DeployedContract(
//           ContractAbi.fromJson(jsonEncode(tokenAbiData), 'ECommerceCoin'),
//           EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS)
//       );
//
//       final vestingContract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(vestingAbiData), 'ECMcoinVesting'),
//           EthereumAddress.fromHex(EXITING_VESTING_ADDRESS)
//       );
//
//       //Token Decimals
//
//       final userBalance = await _web3Client!.call(
//           contract: ecmTokenContract,
//           function: ecmTokenContract.function('balanceOf'),
//           params: [EthereumAddress.fromHex(walletAddress)]
//       );
//       final balanceWei = userBalance[0] as BigInt;
//       final balanceEther = EtherAmount.fromBigInt(EtherUnit.wei, balanceWei).getValueInUnit(EtherUnit.ether);
//
//       print('Existing Vesting :: User balance: ${balanceEther.toStringAsFixed(2)} ECM'); // Print balance
//
//       // Approve Transaction
//       ToastMessage.show(
//         message: "Step 1 of 2: Approval",
//         subtitle: "Please approve the token spending in your wallet.",
//         type: MessageType.info,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//
//       final approveStart = DateTime.now();
//       final approveTxResult = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainId,
//         deployedContract: ecmTokenContract,
//         functionName: 'approve',
//         transaction: Transaction(from: EthereumAddress.fromHex(walletAddress)),
//         parameters: [
//           EthereumAddress.fromHex(EXITING_VESTING_ADDRESS),
//           balanceWei,
//         ],
//       );
//
//       final approveTxHash = approveTxResult is String ? approveTxResult : bytesToHex(approveTxResult);
//       final approveReceipt = await _waitForTransaction(approveTxHash);
//       if (approveReceipt == null) {
//         throw Exception("Approval transaction failed or timed out.");
//       }
//
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "approve",
//         ECM_TOKEN_CONTRACT_ADDRESS,
//         true,
//         DateTime.now().difference(approveStart).inMilliseconds,
//         transactionHash: approveTxHash,
//         extra: {
//           "walletAddress": walletAddress,
//           "vestingAddress": EXITING_VESTING_ADDRESS,
//           "balanceWei": balanceWei.toString(),
//         },
//       );
//       ToastMessage.show(
//         message: "Approval Successful!",
//         subtitle: "Now confirming the vesting transaction.",
//         type: MessageType.success,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//
//       //  Vesting transaction
//       ToastMessage.show(
//         message: "Step 2 of 2: Vesting",
//         subtitle: "Please confirm the vesting transaction in your wallet.",
//         type: MessageType.info,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//
//       final vestingStart = DateTime.now();
//       final vestingTxResult = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainId,
//         deployedContract: vestingContract,
//         functionName: 'vestTokens',
//         transaction: Transaction(from: EthereumAddress.fromHex(walletAddress)),
//         parameters: [],
//       );
//
//       final vestingTxHash = vestingTxResult is String ? vestingTxResult : bytesToHex(vestingTxResult);
//       final vestingReceipt = await _waitForTransaction(vestingTxHash);
//       if (vestingReceipt == null) {
//         throw Exception("Vesting transaction failed or timed out.");
//       }
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "vestTokens",
//         EXITING_VESTING_ADDRESS,
//         true,
//         DateTime.now().difference(vestingStart).inMilliseconds,
//         transactionHash: vestingTxHash,
//         extra: {
//           "walletAddress": walletAddress,
//           "vestingAddress": EXITING_VESTING_ADDRESS,
//         },
//       );
//       ToastMessage.show(
//         message: "Vesting Started Successfully!",
//         subtitle: "Your ECM tokens are now vesting.",
//         type: MessageType.success,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       // Refresh vesting information
//       await getExistingVestingInformation();
//
//       return vestingTxHash;
//
//     }catch(e){
//       await logRocketTrackBlockChainEvent(
//         "TRANSACTION",
//         "startVesting",
//         EXITING_VESTING_ADDRESS,
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//         },
//       );
//
//       final isUserRejected = isUserRejectedError(e);
//       ToastMessage.show(
//         message: isUserRejected ? "Transaction Cancelled" : "Vesting Failed",
//         subtitle: isUserRejected
//             ? "You cancelled the transaction in your wallet."
//             : "An error occurred during vesting. Please try again.",
//         type: isUserRejected ? MessageType.info : MessageType.error,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       return null;
//
//     }finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//
//
//   }
//
//   Future<void> getVestingSchedulesCount()async{
//     if(_isLoading || !_isConnected || _vestingAddress == null) return;
//
//     _isLoading = true;
//     notifyListeners();
//     final start = DateTime.now();
//
//
//     try{
//       final chainId = getChainIdForRequests();
//       if (chainId == null) throw Exception('Chain ID is not available.');
//       // ExitingVestingABI
//       // ECMcoinVesting
//       final vestingAbiString = await rootBundle.loadString("assets/abi/ExitingVestingABI.json");
//       final vestingAbiData = jsonDecode(vestingAbiString);
//
//       final vestingContract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(vestingAbiData), 'ECMcoinVesting'),
//         EthereumAddress.fromHex(EXITING_VESTING_ADDRESS),
//       );
//
//       final countResult = await _web3Client!.call(
//         contract: vestingContract,
//         function: vestingContract.function('getVestingSchedulesCountByBeneficiary'),
//         params: [EthereumAddress.fromHex(_walletAddress)],
//       );
//       final count = countResult[0] as BigInt;
//       await logRocketTrackBlockChainEvent(
//         "VESTING_INFO",
//         "getVestingSchedulesCountByBeneficiary",
//         EXITING_VESTING_ADDRESS,
//         true,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "walletAddress": _walletAddress,
//           "count": count.toString(),
//         },
//       );
//       if (count > BigInt.zero) {
//         await _resolveVestedStart(EthereumAddress.fromHex(EXITING_VESTING_ADDRESS));
//       } else {
//         _vestingAddress = null;
//         _vestingStatus = null;
//         notifyListeners();
//       }
//
//     }catch(e){
//       await logRocketTrackBlockChainEvent(
//         "VESTING_INFO",
//         "getVestingSchedulesCountByBeneficiary",
//         EXITING_VESTING_ADDRESS,
//         false,
//         DateTime.now().difference(start).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//         },
//       );
//       _vestingAddress = null;
//       _vestingStatus = null;
//       notifyListeners();
//     }finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//
//   }
//   Future<void> getExistingVestingInformation() async {
//     if (!_isConnected || _walletAddress.isEmpty) return;
//     notifyListeners();
//     final startTime = DateTime.now();
//     try {
//       final chainId = getChainIdForRequests();
//       if (chainId == null) throw Exception('Chain ID is not available.');
//
//       // Load ExitingVesting ABI
//       final vestingAbiString = await rootBundle.loadString("assets/abi/ExitingVestingABI.json");
//       final vestingAbiData = jsonDecode(vestingAbiString);
//
//       final vestingContract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(vestingAbiData), 'ECMcoinVesting'),
//         EthereumAddress.fromHex(EXITING_VESTING_ADDRESS),
//       );
//
//
//       // Step 1: Get vesting schedules count
//       final countResult = await _web3Client!.call(
//         contract: vestingContract,
//         function: vestingContract.function('getVestingSchedulesCountByBeneficiary'),
//         params: [EthereumAddress.fromHex(_walletAddress)],
//       );
//       final count = countResult[0] as BigInt;
//       await logRocketTrackBlockChainEvent(
//         "VESTING_INFO",
//         "getVestingSchedulesCountByBeneficiary",
//         EXITING_VESTING_ADDRESS,
//         true,
//         DateTime.now().difference(startTime).inMilliseconds,
//         extra: {
//           "walletAddress": _walletAddress,
//           "count": count.toString(),
//         },
//       );
//
//       if(count > BigInt.zero){
//         // Step 2: Resolve details from last schedule
//         await resolveExistingVestedStart(vestingContract);
//       }else{
//         // No vesting schedules
//         _vestingAddress = null;
//         _vestingStatus = null;
//         vestInfo.start = 0;
//         vestInfo.cliff = 0;
//         vestInfo.duration = 0;
//         vestInfo.end = 0;
//         vestInfo.released = 0.0;
//         vestInfo.claimable = 0.0;
//         vestInfo.totalVestingAmount = 0.0;
//         notifyListeners();
//       }
//
//     } catch (e, stackTrace) {
//       await logRocketTrackBlockChainEvent(
//         "VESTING_INFO",
//         "getVestingSchedulesCountByBeneficiary",
//         EXITING_VESTING_ADDRESS,
//         false,
//         DateTime.now().difference(startTime).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//         },
//       );
//
//       _vestingAddress = null;
//       _vestingStatus = null;
//       vestInfo.start = 0;
//       vestInfo.cliff = 0;
//       vestInfo.duration = 0;
//       vestInfo.end = 0;
//       vestInfo.released = 0.0;
//       vestInfo.claimable = 0.0;
//       vestInfo.totalVestingAmount = 0.0;
//       notifyListeners();
//
//     }
//   }
//
//   Future<void> resolveExistingVestedStart(DeployedContract vestingContract)async{
//     final startTime = DateTime.now();
//
//     try{
//       print("Resolving existing vesting for wallet: $_walletAddress");
//
//       if(_web3Client == null){
//         _vestingAddress = null;
//         _vestingStatus = null;
//         notifyListeners();
//         return;
//       }
//
//       final now = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Current Unix timestamp ( ~1757548800 on Sep 11, 2025)
//
//       final scheduleResult = await _web3Client!.call(
//           contract: vestingContract,
//           function: vestingContract.function('getLastVestingScheduleForHolder'),
//           params: [EthereumAddress.fromHex(_walletAddress)]
//       );
//
//       final id = scheduleResult[0] as BigInt;
//       final cliffBn = scheduleResult[1] as BigInt;
//       final startBn = scheduleResult[2] as BigInt;
//       final durationBn = scheduleResult[3] as BigInt;
//       // final slicePeriodBn = scheduleResult[4] as BigInt;  // Ignored as per Vue
//       final totalVestingAmountBn = scheduleResult[5] as BigInt;
//       final releasedBn = scheduleResult[6] as BigInt;
//
//
//       final startVal = (startBn).toInt();
//       final cliff = (cliffBn).toInt();
//       final duration = (durationBn).toInt();
//       final end = startVal + duration;
//       final released = EtherAmount.fromBigInt(EtherUnit.wei, releasedBn).getValueInUnit(EtherUnit.ether).toDouble();
//       final totalVestingAmount = EtherAmount.fromBigInt(EtherUnit.wei, totalVestingAmountBn).getValueInUnit(EtherUnit.ether).toDouble();
//       final claimable = 0.0;  // Set initially as per Vue; can be computed via vestedAmount - released if needed
//
//       print("Existing vesting details: start=$startVal, cliff=$cliff, duration=$duration, end=$end, released=$released, total=$totalVestingAmount");
// // Update vestInfo
//       vestInfo.start = startVal;
//       vestInfo.cliff = cliff;
//       vestInfo.duration = duration;
//       vestInfo.end = end;
//       vestInfo.released = released;
//       vestInfo.claimable = claimable;
//       vestInfo.totalVestingAmount = totalVestingAmount;  // Assuming field exists
//
//       // Set status: 'locked' if start > now, else 'process'
//       _vestingStatus = startVal > now ? 'locked' : 'process';
//       _vestingAddress = EXITING_VESTING_ADDRESS;  // Set to the main vesting contract
//
//       await logRocketTrackBlockChainEvent(
//         "VESTING_DURATIONS",
//         "resolveExistingVestedStart",
//         EXITING_VESTING_ADDRESS,
//         true,
//         DateTime.now().difference(startTime).inMilliseconds,
//         extra: {
//           "walletAddress": _walletAddress,
//           "vestingAddress": EXITING_VESTING_ADDRESS,
//           "start": startVal.toString(),
//           "cliff": cliff.toString(),
//           "duration": duration.toString(),
//           "end": end.toString(),
//           "released": released.toString(),
//           "totalVestingAmount": totalVestingAmount.toString(),
//         },
//       );
//
//       notifyListeners();
//
//     }catch(e){
//       await logRocketTrackBlockChainEvent(
//         "VESTING_DURATIONS",
//         "resolveExistingVestedStart",
//         EXITING_VESTING_ADDRESS,
//         false,
//         DateTime.now().difference(startTime).inMilliseconds,
//         extra: {
//           "error": e.toString(),
//           "walletAddress": _walletAddress,
//           "vestingAddress": EXITING_VESTING_ADDRESS,
//         },
//       );
//
//       _vestingStatus = null;
//       _vestingAddress = null;
//       notifyListeners();
//     }
//   }
//
//
//   ///Helper Function to wait transaction to be mined.
//   Future<TransactionReceipt?> _waitForTransaction(String txHash)async{
//     const pollInterval = Duration(seconds: 3);
//     const timeout = Duration(minutes: 3);
//     final expiry = DateTime.now().add(timeout);
//     final start = DateTime.now();
//
//     while (DateTime.now().isBefore(expiry)){
//       try{
//         final receipt = await _web3Client!.getTransactionReceipt(txHash);
//         if(receipt != null){
//
//           await logRocketTrackBlockChainEvent(
//             "TRANSACTION_CONFIRMATION",
//             "waitForTransaction",
//             "",
//             true,
//             DateTime.now().difference(start).inMilliseconds,
//             transactionHash: txHash,
//             extra: {
//               "walletAddress": _walletAddress,
//               "status": receipt.status.toString(),
//             },
//           );
//
//           if (receipt.status == true){
//             print("Transaction successful: $txHash");
//             return receipt;
//           }else{
//             print("Transaction reverted by EVM: $txHash");
//             throw Exception("Transaction failed. Please check the block explorer for details.");
//           }
//         }
//       } catch (e, stackTrace) {
//         await logRocketTrackBlockChainEvent(
//           "TRANSACTION_CONFIRMATION",
//           "waitForTransaction",
//           "",
//           false,
//           DateTime.now().difference(start).inMilliseconds,
//           extra: {
//             "error": e.toString(),
//             "walletAddress": _walletAddress,
//             "transactionHash": txHash,
//           },
//         );
//        }
//       await Future.delayed(pollInterval);
//     }
//     await logRocketTrackBlockChainEvent(
//       "TRANSACTION_CONFIRMATION",
//       "waitForTransaction",
//       "",
//       false,
//       DateTime.now().difference(start).inMilliseconds,
//       extra: {
//         "error": "Transaction timed out",
//         "walletAddress": _walletAddress,
//         "transactionHash": txHash,
//       },
//     );
//     throw Exception("Transaction timed out. Could not confirm transaction status.");
//   }
//
//   Future<bool> _waitForConnection({Duration timeout = const Duration(seconds: 3)}) async {
//     final start = DateTime.now();
//     final end = DateTime.now().add(timeout);
//     while (DateTime.now().isBefore(end)) {
//       if (_isConnected && _walletAddress.isNotEmpty) {
//         await logRocketTrackBlockChainEvent(
//           "WALLET_ACTION",
//           "waitForConnection",
//           "",
//           true,
//           DateTime.now().difference(start).inMilliseconds,
//           extra: {
//             "walletAddress": _walletAddress,
//           },
//         );
//
//         return true;
//       };
//       final s = appKitModal?.session;
//       if (s != null) {
//         String? address;
//         final selected = appKitModal?.selectedChain?.chainId;
//         if (selected != null) {
//           final ns = ReownAppKitModalNetworks.getNamespaceForChainId(selected);
//           address = s.getAddress(ns);
//         }
//         address ??= _getFirstAddressFromSession();
//         if (address != null) {
//           _walletAddress = address;
//           _isConnected = true;
//
//           await logRocketTrackBlockChainEvent(
//             "WALLET_ACTION",
//             "waitForConnection",
//             "",
//             true,
//             DateTime.now().difference(start).inMilliseconds,
//             extra: {
//               "walletAddress": _walletAddress,
//             },
//           );
//
//           notifyListeners();
//           return true;
//         }
//       }
//       await Future.delayed(const Duration(milliseconds: 200));
//     }
//
//     await logRocketTrackBlockChainEvent(
//       "WALLET_ACTION",
//       "waitForConnection",
//       "",
//       false,
//       DateTime.now().difference(start).inMilliseconds,
//       extra: {
//         "error": "Connection timed out",
//         "walletAddress": _walletAddress.isEmpty ? "none" : _walletAddress,
//       },
//     );
//
//     return false;
//   }
//
//
// }
class WalletViewModel extends ChangeNotifier with WidgetsBindingObserver{

  bool _hasMaterial(BuildContext context) {
    return Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) != null;
  }
  void setupLifecycleObserver() {
    WidgetsBinding.instance.addObserver(_LifecycleHandler(
        onDetached: _handleAppDetached, onPause: _handleAppPause,
        onResume: _handleAppResume)
    );
  }


  ///Ensures context is valid and modal is re-initialized if needed
  ReownAppKitModal? appKitModal;
  bool _isSessionSettling = false;
  String _walletAddress = '';
  bool _isLoading = false;
  bool _isConnected = false;
  String? _balance;
  String? _minimumStake;
  String? _maximumStake;
  double _ethPrice = 0.0;

  Web3Client? _web3Client;
  bool _isModalEventsSubscribed = false;
  bool _walletConnectedManually = false;
  bool _modalHasMaterialContext = false;
  String? _lastKnowChainId;
  String? _lastTransactionHash;
  BuildContext? _lastContext;
  String? _authToken;

  BigInt? rawPrice;

  // Getters
  bool get walletConnectedManually => _walletConnectedManually;
  String? get lastTransactionHash => _lastTransactionHash;
  double get ethPrice => _ethPrice;

  String? get balance => _balance;
  String? get minimumStake => _minimumStake;
  String? get maximumStake => _maximumStake;
  String get walletAddress => _walletAddress;
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  bool get isSessionSettling => _isSessionSettling;
  String? get authToken => _authToken;


  Timer? _vestingTimer;
  String? _userWalletBalance;
  String? _vestingContractBalance;
  bool _isUserBalanceLoading = false;
  bool _isVestingBalanceLoading = false;


  bool _isReconnecting = false;
  Timer? _sessionHealthTimer;
  Timer? _reconnectionTimer;
  int _reconnectionAttempts = 0;
  static const int MAX_RECONNECTION_ATTEMPTS = 3;
  static const Duration SESSION_HEALTH_CHECK_INTERVAL = Duration(seconds: 30);
  static const Duration RECONNECTION_DELAY = Duration(seconds: 3);



  // Enhanced session validation
  bool get isSessionValid {
    return appKitModal?.session != null &&
        _isConnected &&
        _walletAddress.isNotEmpty &&
        _lastKnowChainId != null;
  }


  String? get userWalletBalance => _userWalletBalance;
  String? get vestingContractBalance => _vestingContractBalance;
  bool get isUserBalanceLoading => _isUserBalanceLoading;
  bool get isVestingBalanceLoading => _isVestingBalanceLoading;

  //SEPHOLIA ADDRESS
  /** SEPHOLIA ADDRESS **/
  static const String ALCHEMY_URL_V2 = "https://eth-sepolia.g.alchemy.com/v2/Z-5ts6Ke8ik_CZOD9mNqzh-iekLYPySe";
  static const String SALE_CONTRACT_ADDRESS = '0x732c5dFF0db1070d214F72Fc6056CF8B48692506';
  static const String ECM_TOKEN_CONTRACT_ADDRESS = '0x4C324169890F42c905f3b8f740DBBe7C4E5e55C0';
  static const String STAKING_CONTRACT_ADDRESSLIVE = '0x878323894bE6c7E019dBA7f062e003889C812715';
  static const String AGGREGATO_RADDRESS = '0x694AA1769357215DE4FAC081bf1f309aDC325306';
  static const String EXITING_VESTING_ADDRESS = '0x6EB1b13f3A71b0dfDC2F2e4E9490468aB3BAB266';


  //MAINNET ADDRESS
  /** MAINNET ADDRESS
  static const String ALCHEMY_URL_V2 = "https://mainnet.infura.io/v3/8e59f629376f4c459566f61b213bb3f4";
  static const String SALE_CONTRACT_ADDRESS = '0xf19A1ca2441995BB02090F57046147f36555b0aC';
  static const String ECM_TOKEN_CONTRACT_ADDRESS = '0x6f9c25edc02f21e9df8050a3e67947c99b88f0b2';
  static const String STAKING_CONTRACT_ADDRESSLIVE = '0x6c6a6450b95d15Fbd80356EFe0b7DaE27ea00092';
  static const String AGGREGATO_RADDRESS = '0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419';
  static const String EXITING_VESTING_ADDRESS = '0x5bC875476C73C76092755226d59747e37c467d90';
  **/

  static const double ECM_PRICE_USD = 1.2;
  static const int ECM_DECIMALS = 18;
  static const int AGGREGATOR_DECIMALS = 8;
  static const String API_ENDPOINT = 'https://app.mycoinpoll.com/api/v1';


  WalletViewModel() {
    _web3Client = Web3Client(ALCHEMY_URL_V2, Client());
    WidgetsBinding.instance.addObserver(this);
  }

  String? _vestingAddress;
  String? _vestingStatus; // 'locked' | 'process' | null

  String? _existingVestingAddress;
  String? _existingVestingStatus;

  final IcoVestingInfo vestInfo = IcoVestingInfo(
    start: 0,
    cliff: 0,
    duration: 0,
    end: 0,
    released: 0.0,
    claimable: 0.0,
  );

  final ExistingVestingInfo existingVestInfo = ExistingVestingInfo(
    start: 0,
    cliff: 0,
    duration: 0,
    end: 0,
    released: 0.0,
    claimable: 0.0,
    totalVestingAmount: 0.0,
  );

// Getters for the new properties
  String? get vestingAddress => _vestingAddress;
  String? get existingVestingAddress => _existingVestingAddress;

  String? get vestingStatus => _vestingStatus;
  String? get existingVestingStatus => _existingVestingStatus;

  @override
  void dispose() {
    _vestingTimer?.cancel();
    _sessionHealthTimer?.cancel();
    _reconnectionTimer?.cancel();
     _web3Client?.dispose();
    WidgetsBinding.instance.removeObserver(this);

    appKitModal?.onModalConnect.unsubscribeAll();
    appKitModal?.onModalUpdate.unsubscribeAll();
    appKitModal?.onModalDisconnect.unsubscribeAll();
    appKitModal?.onSessionExpireEvent.unsubscribeAll();
    appKitModal?.onSessionUpdateEvent.unsubscribeAll();
    super.dispose();
  }

  Future<void> init(BuildContext context) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try{
      if (appKitModal == null) {
         appKitModal = ReownAppKitModal(

          context: context,
          // projectId: 'f3d7c5a3be3446568bcc6bcc1fcc6389',
          projectId: 'ec1aaae5ff0cfc95b21c0a59b7a2fe91',
           metadata: const PairingMetadata(
            name: "MyWallet",
            description: "Example Description",
            url: 'https://mycoinpoll.com/',
            icons: ['https://example.com/logo.png'],
            redirect: Redirect(
              native: 'MyCoin Poll',
              universal: 'https://reown.com/exampleapp',
              linkMode: true,
            ),
          ),

          logLevel: LogLevel.error,
          enableAnalytics: false,
          featuresConfig: FeaturesConfig(
            email: false,
            socials: [
              AppKitSocialOption.Google,
              AppKitSocialOption.Discord,
              AppKitSocialOption.Facebook,
              AppKitSocialOption.GitHub,
              AppKitSocialOption.X,
              AppKitSocialOption.Apple,
              AppKitSocialOption.Twitch,
              AppKitSocialOption.Farcaster,
            ],
            showMainWallets: true,
          ),
        );

        await appKitModal!.init();
        final hasMaterial = Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) != null;
        _modalHasMaterialContext = hasMaterial;


      }

      if (!_isModalEventsSubscribed) {
        final prefs = await SharedPreferences.getInstance();
        _subscribeToModalEvents(prefs);
        _isModalEventsSubscribed = true;
      }

      // await fetchLatestETHPrice();

      await _hydrateFromExistingSession();


    }catch(e,stack){

      await fetchLatestETHPrice();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> ensureModalWithValidContext(BuildContext context) async {

    if (appKitModal == null || !_hasMaterial(context)) {
      _lastContext = context;
      await init(context);
    }
  }

  void _subscribeToModalEvents(SharedPreferences prefs) {
    // Clear all existing subscriptions first
    appKitModal!.onModalConnect.unsubscribeAll();
    appKitModal!.onModalUpdate.unsubscribeAll();
    appKitModal!.onModalDisconnect.unsubscribeAll();
    appKitModal!.onSessionExpireEvent.unsubscribeAll();
    appKitModal!.onSessionUpdateEvent.unsubscribeAll();

    // Simple connection handler - only update state, don't fetch data immediately
    appKitModal!.onModalConnect.subscribe((_) async {
      debugPrint("Modal connected event triggered");

      // Update basic state
      _isConnected = true;
      _reconnectionAttempts = 0;

      // Get basic info from session
      _lastKnowChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
      final address = _getFirstAddressFromSession();

      if (address != null) {
        _walletAddress = address;
        // Save to prefs
        await prefs.setBool('isConnected', true);
        await prefs.setString('walletAddress', _walletAddress);
      }

      // Don't fetch data here - let the UI handle it
      notifyListeners();
    });

    // Simple update handler - minimal processing
    appKitModal!.onModalUpdate.subscribe((_) async {
      debugPrint("Modal update event triggered");

      // Only update if something actually changed
      final newChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
      final newAddress = _getFirstAddressFromSession();

      bool shouldNotify = false;

      if (newChainId != _lastKnowChainId) {
        _lastKnowChainId = newChainId;
        shouldNotify = true;
      }

      if (newAddress != null && newAddress != _walletAddress) {
        _walletAddress = newAddress;
        await prefs.setString('walletAddress', _walletAddress);
        shouldNotify = true;
      }

      if (shouldNotify) {
        notifyListeners();
      }
    });

    // Simple disconnect handler - don't clear everything immediately
    appKitModal!.onModalDisconnect.subscribe((_) async {
      debugPrint("Modal disconnect event triggered");

      // Only clear if we're actually disconnected
      if (appKitModal?.session == null) {
        await _handleDisconnect(prefs);
      }
    });

    // Simple session expire handler
    appKitModal!.onSessionExpireEvent.subscribe((_) async {
      debugPrint("Session expire event triggered");
      await _handleDisconnect(prefs);
    });

    // Simple session update handler - minimal processing
    appKitModal!.onSessionUpdateEvent.subscribe((_) async {
      debugPrint("Session update event triggered");


      final newChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
      final newAddress = _getFirstAddressFromSession();

      bool shouldNotify = false;

      if (newChainId != _lastKnowChainId) {
        _lastKnowChainId = newChainId;
        shouldNotify = true;
      }

      if (newAddress != null && newAddress != _walletAddress) {
        _walletAddress = newAddress;
        await prefs.setString('walletAddress', _walletAddress);
        shouldNotify = true;
      }

      if (shouldNotify) {
        notifyListeners();
      }
    });
  }

  Future<void> _handleDisconnect(SharedPreferences prefs) async {
    // Only disconnect if we're actually disconnected
    if (appKitModal?.session != null) {
      debugPrint("Session still exists, not clearing state");
      return;
    }

    debugPrint("Actually disconnecting - clearing state");

    final prevAddress = _walletAddress;
    if (prevAddress.isNotEmpty) {
      await prefs.remove('web3_sig_$prevAddress');
      await prefs.remove('web3_msg_$prevAddress');
    }

    _lastKnowChainId = null;
    _isConnected = false;
    _walletAddress = '';

    _reconnectionTimer?.cancel();

    await _removePersistedConnection();
    await _clearWalletAndStageInfo();
    await fetchLatestETHPrice();

    notifyListeners();
  }
  /// Connect the wallet using the ReownAppKitModal UI.

  Future<bool> connectWallet(BuildContext context) async {
    if (_isLoading || _isReconnecting) return false;

    _walletConnectedManually = true;
    _isLoading = true;
    notifyListeners();
    final start = DateTime.now();

    try {
      // Ensure modal is initialized
      if (appKitModal == null) {
        await init(context);
      }

      // Check if already connected
      if (_isConnected && appKitModal?.session != null) {
        debugPrint("Already connected, skipping connection");
        return true;
      }

      // Open modal and wait for connection
      await appKitModal!.openModalView();

      // Wait for connection with reasonable timeout
      final connected = await _waitForConnection(timeout: const Duration(seconds: 2));
      if (!connected) {
        debugPrint("Connection timeout");
        return false;
      }

      await logRocketTrackBlockChainEvent(
        "WALLET_ACTION",
        "connectWallet",
        "",
        true,
        DateTime.now().difference(start).inMilliseconds,
        extra: {"walletAddress": _walletAddress},
      );

      return true;

    } catch (e,stack) {
      await logRocketTrackBlockChainEvent(
        "WALLET_ACTION",
        "connectWallet",
        "",
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {"error": e.toString()},
      );
       return _handleConnectionError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> openWalletModal(BuildContext context) async {
    // 1) Always (re)create with the current valid context
    await init(context);

    try {
      await appKitModal!.openModalView();
      return true;
    } catch (_) {

      await reset();
       await init(context);
      await appKitModal!.openModalView();
      return true;
    }
  }

  bool _handleConnectionError(dynamic error) {

    final errorMsg = error.toString().toLowerCase();

    if (errorMsg.contains("user rejected") ||
        errorMsg.contains("user denied") ||
        errorMsg.contains("user canceled") ||
        errorMsg.contains("user cancelled") ||
        errorMsg.contains("modal closed") ||
        errorMsg.contains("wallet modal closed") ||
        errorMsg.contains("no response from user")) {
      ToastMessage.show(
        message: "Connection Cancelled",
        subtitle: "You cancelled the wallet connection.",
        type: MessageType.info,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      return false;
    } else {

      ToastMessage.show(
        message: "Connection Failed",
        subtitle: "Please try connecting again.",
        type: MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      return false;
    }
  }
  /// Disconnect from the wallet and clear stored wallet info.
  Future<void> disconnectWallet(BuildContext context) async {
    if (appKitModal == null) return;
    _isLoading = true;
    _vestingTimer?.cancel();
    notifyListeners();
    try {
      final prevAddress = _walletAddress;

      if (_isConnected && appKitModal!.session != null) {
        await appKitModal!.disconnect();
      }

      final prefs = await SharedPreferences.getInstance();
      if (prevAddress.isNotEmpty) {
        await prefs.remove('web3_sig_$prevAddress');
        await prefs.remove('web3_msg_$prevAddress');
      }

      _lastKnowChainId = null;

      await _removePersistedConnection();
      await _clearWalletAndStageInfo(shouldNotify: false);
       await fetchLatestETHPrice();
    } finally {

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> rehydrate() async {
    if (_isLoading || _isSessionSettling) return;
    _isLoading = true;
    notifyListeners();
    try {
      await _hydrateFromExistingSession();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  ///LifeCycle Functions
  Future<void> _handleAppResume() async {
    debugPrint("App resumed - checking wallet connection...");

    if (appKitModal == null) {
      debugPrint("AppKitModal is null, initializing...");
      if (_lastContext != null) {
        await init(_lastContext!);
      }
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final isConnected = prefs.getBool('isConnected') ?? false;

      if (isConnected) {
        debugPrint("Previous connection found, rehydrating...");
        await _hydrateFromExistingSession();

      } else {
        debugPrint("No previous connection found");
      }
    } catch (e, stack) {


      debugPrint("App resume error: $e\n$stack");
    } finally {
      notifyListeners();
    }
  }

  Future<void> _handleAppPause() async {
    debugPrint("App paused - saving session state...");

    if (_isConnected && appKitModal?.session != null) {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = appKitModal!.session!.toJson();
      await prefs.setString('walletSession', jsonEncode(sessionJson));
      await prefs.setBool('isConnected', true);
      await prefs.setString('walletAddress', _walletAddress);
      if (_lastKnowChainId != null) {
        await prefs.setString('chainId', _lastKnowChainId!);
      }

    }
  }

  Future<void> _handleAppDetached() async {
    debugPrint("App detached - cleaning up...");
     _reconnectionTimer?.cancel();
  }

  Future<void> _hydrateFromExistingSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wasConnected = prefs.getBool('isConnected') ?? false;
      final savedAddress = prefs.getString('walletAddress');

      if (wasConnected && savedAddress != null && appKitModal?.session != null) {
        debugPrint("Restoring existing wallet session");
        _isConnected = true;
        _walletAddress = savedAddress;

        _lastKnowChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();

        await fetchConnectedWalletData();
        await fetchLatestETHPrice();

        /// NEW Added
        await getBalance();
        await getExistingVestingInformation();

        notifyListeners();
      }
    } catch (e,stack) {

      debugPrint("Error hydrating session: $e");
    }
  }

  String? _getFirstAddressFromSession() {
    final s = appKitModal?.session;
    if (s == null) return null;
    try {
      final values = s.namespaces?.values;
      if (values == null) return null;
      for (final ns in values) {
        if (ns.accounts.isNotEmpty) {
          final parts = ns.accounts.first.split(':'); // eip155:11155111:0x...
          if (parts.length >= 3) return parts[2];
        }
      }
    } catch (e,stack) {


    }
    return null;
  }

  String? _getChainIdFromSession() {
    final s = appKitModal?.session;
    if (s == null) return null;
    try {
      final values = s.namespaces?.values;
      if (values == null) return null;
      for (final ns in values) {
        if (ns.accounts.isNotEmpty) {
          final parts = ns.accounts.first.split(':'); // eip155:11155111:0x...
          if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
        }
      }
    } catch (e, stack) {

    }
    return null;
  }

  String? getChainIdForRequests() {
    return appKitModal?.selectedChain?.chainId ?? _lastKnowChainId ?? _getChainIdFromSession();
  }

  Future<void> _removePersistedConnection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isConnected');
    await prefs.remove('walletAddress');
    await prefs.remove('chainId');
    await prefs.remove('walletSession');
  }

  Future<void> _clearWalletAndStageInfo({bool shouldNotify = true}) async {
    _walletAddress = '';
    _isConnected = false;
    _balance = null;
    _minimumStake = null;
    _maximumStake = null;
    _ethPrice = 0.0;



    print("Wallet state and storage have been reset.");
    if (shouldNotify) {
      notifyListeners();
    }
  }

  Future<void> reset() async {
    _walletAddress = '';
    _isConnected = false;
    _balance = null;
    _minimumStake = null;
    _maximumStake = null;
    _ethPrice = 0.0;

    _walletConnectedManually = false;
    _isModalEventsSubscribed = false;
    _lastKnowChainId = null;

     await _removePersistedConnection();

    appKitModal?.onModalConnect.unsubscribeAll();
    appKitModal?.onModalUpdate.unsubscribeAll();
    appKitModal?.onModalDisconnect.unsubscribeAll();
    appKitModal?.onSessionExpireEvent.unsubscribeAll();
    appKitModal?.onSessionUpdateEvent.unsubscribeAll();

    appKitModal = null;
    print("Wallet state and storage have been reset.");
    notifyListeners();
  }

  Future<void> fetchConnectedWalletData({bool isReconnecting = false}) async {
     if (appKitModal == null || appKitModal!.session == null || appKitModal!.selectedChain == null) {
      _clearWalletSpecificInfo(shouldNotify: !isReconnecting);
      return;
    }

    if (!_isConnected) {
      _clearWalletSpecificInfo(shouldNotify: !isReconnecting);
      return;
    }

    final chainID = getChainIdForRequests();
    if (chainID == null) {
      await _clearWalletAndStageInfo(shouldNotify: !isReconnecting);
      return;
    }

    final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);

    final currentSessionAddress = appKitModal!.session!.getAddress(nameSpace);
    if (currentSessionAddress == null || currentSessionAddress.isEmpty) {
      await _clearWalletAndStageInfo(shouldNotify: !isReconnecting);
      return;
    }

    _walletAddress = currentSessionAddress;

    if (!isReconnecting && !_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      debugPrint("Fetching connected wallet data for address: $_walletAddress");

      // Fetch balance first
      await getBalance();
      await fetchLatestETHPrice();
      await Future.wait([
          getMinimunStake(),
        getMaximumStake(),
        getVestingInformation(),
        getExistingVestingInformation()
      ]);

    } catch (e, stack) {

      _clearWalletSpecificInfo(shouldNotify: true);
    } finally {
      if (!isReconnecting) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void _clearWalletSpecificInfo({bool shouldNotify = true}) {
    _balance = null;
    _minimumStake = null;
    _maximumStake = null;
    if (shouldNotify) {
      notifyListeners();
    }
  }


  Future<int> getTokenDecimals({required String contractAddress}) async {
    try {
      final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final abiData = jsonDecode(abiString);
      final contract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abiData), 'ECommerceCoin'),
        EthereumAddress.fromHex(contractAddress),
      );

      final decimalsResult = await _web3Client!.call(
        contract: contract,
        function: contract.function('decimals'),
        params: [],
      );

      final decimals = (decimalsResult[0] as BigInt).toInt();

      // Validate the decimals value
      if (decimals < 0 || decimals > 18) {
        debugPrint("Invalid decimals returned from contract: $decimals, using default of 18");
        return 18; // Return a safe default
      }

      debugPrint("Token decimals: $decimals");
      return decimals;
    } catch (e, stack) {

       return 18;
    }
  }

  Future<String> getMinimunStake() async {
    try {
      final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
      final abiData = jsonDecode(abiString);
      final decimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS);
      print("Decimals for staking: $decimals");

      final stakingContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE),
      );

      final minimumStakeResult = await _web3Client!.call(
        contract: stakingContract,
        function: stakingContract.function('minimumStake'),
        params: [],
      );
      final min = (minimumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
      _minimumStake = min.toDouble().toStringAsFixed(0);
      print("Raw minimumStakeResult: ${minimumStakeResult[0]}");
      return _minimumStake!;
    } catch (e, stack) {

      _minimumStake = null;
      rethrow;
    }
  }

  Future<String> getMaximumStake() async {
    try {
      final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
      final abiData = jsonDecode(abiString);
      final decimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS);


      final stakingContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE),
      );

      final maximumStakeResult = await _web3Client!.call(
        contract: stakingContract,
        function: stakingContract.function('maximumStake'),
        params: [],
      );


      final max = (maximumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
      _maximumStake = max.toDouble().toStringAsFixed(0);
      return _maximumStake!;
    } catch (e, stack) {

      _maximumStake = null;
      rethrow;
    }
  }

  Future<String> fetchLatestETHPrice({bool forceLoad = false}) async {
    print('### fetchLatestETHPrice() called');
    print('### forceLoad: $forceLoad');
    const cacheDurationMs = 3 * 60 * 1000; // 3 minutes
    final prefs = await SharedPreferences.getInstance();
    final lastUpdated = prefs.getInt('ethPriceLastUpdated') ?? 0;
    final cachedPrice = prefs.getString('ethPriceUSD');
    final cachedRawPrice = prefs.getString('ethPriceRaw');


    if (!forceLoad && cachedPrice != null && cachedRawPrice != null && DateTime.now().millisecondsSinceEpoch - lastUpdated < cacheDurationMs) {
      _ethPrice = double.parse(cachedPrice);
      rawPrice = BigInt.parse(cachedRawPrice);

      notifyListeners();
      return cachedPrice;
    }

    final start = DateTime.now();

    try {
      final abiString = await rootBundle.loadString("assets/abi/AggregatorABI.json");
      final abiData = jsonDecode(abiString);
      const aggregatorAddress = AGGREGATO_RADDRESS;
      final contract = DeployedContract(
        ContractAbi.fromJson(
            jsonEncode(abiData),
            'EACAggregatorProxy'
        ),
        EthereumAddress.fromHex(aggregatorAddress),
      );
      final result = await _web3Client!.call(
        contract: contract,
        function: contract.function('latestAnswer'),
         params: [],
      );
      print('##### fetchLatestETHPrice ####');
      print('Test result: $result');

      final newRawPrice = result[0] as BigInt;
      print('RAW_PRICE : $rawPrice');
      rawPrice = newRawPrice;



      final ethUsdPrice = newRawPrice.toDouble() / 1e8;
      final ethPerEcm = ECM_PRICE_USD / ethUsdPrice;
       final price = ethPerEcm.toStringAsFixed(8);

      print('RAW_PRICE 8 Decimal: $price');

      await prefs.setString('ethPriceUSD', price);
      await prefs.setInt('ethPriceLastUpdated', DateTime.now().millisecondsSinceEpoch);
      await prefs.setString('ethPriceRaw', newRawPrice.toString());

      await logRocketTrackBlockChainEvent(
        "ECM_LATEST_PRICE",
        "latestAnswer",
        AGGREGATO_RADDRESS,
        true,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "ethPriceUSD": ethUsdPrice.toString(),
          "ecmPriceETH": price,
        },
      );

      _ethPrice = double.parse(price);
       notifyListeners();
      return price;
    } catch (e,stack) {
      await logRocketTrackBlockChainEvent(
        "ECM_LATEST_PRICE",
        "latestAnswer",
        AGGREGATO_RADDRESS,
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {"error": e.toString()},
      );
      if (cachedPrice != null) return cachedPrice;
      throw Exception('Failed to fetch ETH price');
    }
  }

  Future<String> getBalance({String? forAddress}) async {
    final String? addressToQuery = forAddress ?? _walletAddress;

    if (_web3Client == null) {
      debugPrint("Web3Client not initialized for getBalance.");
      throw Exception("Web3Client not initialized.");
    }

    if (addressToQuery == null || addressToQuery.isEmpty) {
      debugPrint("No valid address provided to getBalance. User wallet: $_walletAddress, Optional param: $forAddress");
      if (forAddress == null) {
        _balance = "0";
        notifyListeners();
      }
      return "0";
    }
    final start = DateTime.now();
    try {
      final abiString = await rootBundle.loadString("assets/abi/ECMContractABI.json");
      final abiData = jsonDecode(abiString);

      final ecmTokenContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'ECommerceCoin',
        ),
        EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
      );

      // Get token decimals
      final decimalsResult = await _web3Client!.call(
        contract: ecmTokenContract,
        function: ecmTokenContract.function('decimals'),
        params: [],
      );
      final int tokenDecimals = (decimalsResult[0] as BigInt).toInt();
      debugPrint("Token decimals: $tokenDecimals");

      // Get balance
      final balanceOfResult = await _web3Client!.call(
        contract: ecmTokenContract,
        function: ecmTokenContract.function('balanceOf'),
        params: [EthereumAddress.fromHex(addressToQuery)],
      );

      final rawBalanceBigInt = balanceOfResult[0] as BigInt;
      debugPrint('>>> Raw token balance for $addressToQuery: $rawBalanceBigInt');

      String formattedBalance;
      if (tokenDecimals == 18) {
        formattedBalance = EtherAmount.fromBigInt(EtherUnit.wei, rawBalanceBigInt)
            .getValueInUnit(EtherUnit.ether)
            .toString();
      } else {
        final divisor = BigInt.from(10).pow(tokenDecimals);
        final wholePart = rawBalanceBigInt ~/ divisor;
        final fractionalPart = rawBalanceBigInt % divisor;
        formattedBalance = "$wholePart.${fractionalPart.toString().padLeft(tokenDecimals, '0')}";
        formattedBalance = formattedBalance.replaceAll(RegExp(r'\.0*$'), '')
            .replaceAll(RegExp(r'(\.\d*?[1-9])0+$'), r'$1');
      }


      await logRocketTrackBlockChainEvent(
        "WALLET_BALANCE",
        "balanceOf",
        ECM_TOKEN_CONTRACT_ADDRESS,
        true,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "address": addressToQuery,
          "balance": formattedBalance,
        },
      );

      // Update the appropriate balance variable
      if (forAddress == null) {
        _balance = formattedBalance;
        notifyListeners();
      } else if (forAddress == _vestingAddress) {
        _vestingContractBalance = formattedBalance;
      } else {
        _userWalletBalance = formattedBalance;
      }

      return formattedBalance;

    } catch (e, stack) {
       await logRocketTrackBlockChainEvent(
        "WALLET_BALANCE",
        "balanceOf",
        ECM_TOKEN_CONTRACT_ADDRESS,
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "error": e.toString(),
          "address": addressToQuery,
        },
      );
       // Set default values on error`
      if (forAddress == null) {
        _balance = "0";
        notifyListeners();
      }
      return "0";
    }
  }

  bool isValidECMAmount(double ecmAmount) {
    return ecmAmount >= 50;
  }

  BigInt? convertECMtoWei(double ecmAmount) {
    try {
      // Validation checks
      if (ecmAmount <= 0) {
        return null;
      }


      if (rawPrice == null) {
        debugPrint("⛔️ Conversion failed: rawPrice is null.");
        return null;
      }

      // Convert ECM amount to Wei (18 decimals)
      final BigInt ecmAmountWei = BigInt.from(ecmAmount * 1e18);

      // Convert ECM price USD to Wei (18 decimals)
      final BigInt ecmPriceUSDWei = BigInt.from(ECM_PRICE_USD * 1e18);

      // Calculate total USD needed = ECM amount * ECM price
      final BigInt usdNeeded = (ecmAmountWei * ecmPriceUSDWei) ~/ BigInt.from(10).pow(ECM_DECIMALS);

      // ETH price in USD (scaled properly with oracle decimals)
      final BigInt ethPriceUSDWei = rawPrice! * BigInt.from(10).pow(ECM_DECIMALS - AGGREGATOR_DECIMALS);

      // Calculate ETH needed in Wei
      final BigInt ethNeededWei = (usdNeeded * BigInt.from(10).pow(ECM_DECIMALS) + ethPriceUSDWei - BigInt.one) ~/ ethPriceUSDWei;

      debugPrint("✅ ECM to Wei conversion successful:");
      debugPrint("  ECM Amount: $ecmAmount");
      debugPrint("  ETH Needed (Wei): $ethNeededWei");
      debugPrint("  ETH Needed (ETH): ${ethNeededWei / BigInt.from(10).pow(18)}");

      return ethNeededWei;
    } catch (e) {
      return null;
    }
  }

  Future<String?> buyECMWithETH({
    required EtherAmount ethAmount,
    required EthereumAddress referralAddress,
    required BuildContext context
  }) async {
    final chainID = getChainIdForRequests();
    print("buyECMWithETH Chaid Id ${chainID}");

    if (appKitModal == null || !_isConnected || appKitModal!.session == null || chainID == null) {
      throw Exception("Wallet not Connected or selected chain not available.");
    }
    _isLoading = true;
    notifyListeners();
    final start = DateTime.now();

    try {
       final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
      final walletAddress = EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!);
      final ethBalance = await _web3Client!.getBalance(walletAddress);

      print("ethBalance : ${ethBalance}");
      print("walletAddress : ${walletAddress}");

      if(ethBalance.getInWei < ethAmount.getInWei){
        ToastMessage.show(
          message: "Insufficient ETH Balance",
          subtitle: "Your ETH balance is too low for this purchase.",
          type: MessageType.error,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );
        throw Exception("INSUFFICIENT_ETH_BALANCE");
      }

      final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
      final abiData = jsonDecode(abiString);
      final saleContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abiData),
           'ECMCoinICO'),
        EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
      );


      final result = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: saleContract,
        functionName: 'buyECMWithETH',
        transaction: Transaction(
          from: walletAddress,
          value: ethAmount,
        ),
        parameters: [referralAddress],
      );
      print('Transaction Hash: $result');
      print("ethAmount.getInWei ${ethAmount.getInWei}");

      print("Result : ethAmount ${ethAmount}");
      print("Result : walletAddress ${walletAddress}");




       //Poll until TX is confirmed
       TransactionReceipt? receipt;
       for (var i = 0; i < 20; i++) {
         receipt = await _web3Client!.getTransactionReceipt(result);
         if (receipt != null) break;
         await Future.delayed(const Duration(seconds: 3));
       }

       if(receipt == null){
         throw Exception("Failed to get transaction receipt.");
       }
       _lastTransactionHash = result;
       if (receipt.status != true) {
         ToastMessage.show(
           message: "Purchase Failed",
           subtitle: "Minimum 50 ECM tokens per purchase required.",
           type: MessageType.error,
           duration: CustomToastLength.LONG,
           gravity: CustomToastGravity.BOTTOM,
         );
         return null;
       }

       // Parse transaction logs
      final payload = await _parseTransactionLogs(receipt, saleContract ,walletAddress);
      // Send Payload to API
       await _sendPurchaseDataToApi(payload);


       await logRocketTrackBlockChainEvent(
         "TRANSACTION",
         "buyECMWithETH",
         SALE_CONTRACT_ADDRESS,
         true,
         DateTime.now().difference(start).inMilliseconds,
         transactionHash: result,
         extra: {
           "walletAddress": walletAddress.hex,
           "ethAmount": ethAmount.getInWei.toString(),
           "referralAddress": referralAddress.hex,
           "ecmAmount": payload['amount'].toString(),
         },
       );

       ToastMessage.show(
         message: "Purchase Successful",
         subtitle: "ECM purchase completed successfully. Transaction hash: $result",
         type: MessageType.success,
         duration: CustomToastLength.LONG,
         gravity: CustomToastGravity.BOTTOM,
       );

       await Future.wait([
         fetchConnectedWalletData(),
         fetchLatestETHPrice(),
       ]);
       return result;

    } catch (e,stack) {
      print("Error buying ECM with ETH: $e");
      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "buyECMWithETH",
        SALE_CONTRACT_ADDRESS,
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "error": e.toString(),
          "walletAddress": _walletAddress,
        },
      );

      if (e.toString().contains("INSUFFICIENT_ETH_BALANCE")) {
         return Future.error(e);
      }
      final isUserRejected = isUserRejectedError(e);

      ToastMessage.show(
        message: isUserRejected ? "Transaction Cancelled" : "Transaction Failed",
        subtitle: isUserRejected
            ? "You cancelled the transaction."
            : "Could not complete the purchase. Please try again.",
        type: isUserRejected ? MessageType.info : MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _parseTransactionLogs(
      TransactionReceipt receipt,
      DeployedContract contract,
      EthereumAddress walletAddress,
      ) async {
    final payload = {
      'hash': '0x${bytesToHex(receipt.transactionHash, include0x: false)}',
      'buyer': walletAddress.hex,
      'referrer': '',
      'vestingWallet': '',
      'amount': 0.0,
      'paymentAmountETH': 0.0,
      'ethUsdPriceUsed': 0.0,
      'ecmPriceUSDUsed': 0.0,
      'baseECM': 0.0,
      'bonusECM': 0.0,
      'referralECM': 0.0,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'referralAddress': '',
      'referee': '',
      'refVesting': '',
      'referralAmount': 0.0,
    };

    final saleAddrLc = SALE_CONTRACT_ADDRESS.toLowerCase();
    final ecmPurchasedEvent = contract.event('ECMPurchased');
    final referralRewardEvent = contract.event('ReferralRewardPaid');

    for (final log in receipt.logs) {

       if ((log.address?.hex.toLowerCase() ?? '') != saleAddrLc) continue;
      try {
        final logSignature = log.topics![0];
        final eventSignature = bytesToHex(ecmPurchasedEvent.signature, include0x: true);

        if (logSignature == eventSignature) {
           final decoded = ecmPurchasedEvent.decodeResults(log.topics!, log.data!);

          print("✅ ECMPurchased decoded event: $decoded");

          // Map values into payload
          payload['buyer'] = decoded[0].toString();
          payload['referrer'] = decoded[1].toString();
          payload['vestingWallet'] = decoded[2].toString();
          payload['amount'] = (decoded[3] as BigInt).toDouble() / 1e18;
          payload['paymentAmountETH'] = (decoded[4] as BigInt).toDouble() / 1e18;
          payload['ethUsdPriceUsed'] = (decoded[5] as BigInt).toDouble() / 1e8;
          payload['ecmPriceUSDUsed'] = (decoded[6] as BigInt).toDouble() / 1e18;
          payload['baseECM'] = (decoded[7] as BigInt).toDouble() / 1e18;
          payload['bonusECM'] = (decoded[8] as BigInt).toDouble() / 1e18;
          payload['referralECM'] = (decoded[9] as BigInt).toDouble() / 1e18;
        }
      } catch (e,stackTrace) {
        print('Error decoding ECMPurchased log: $e');

      }

      try {
        final logSignature = log.topics![0];
        final referralSignature = bytesToHex(referralRewardEvent.signature, include0x: true);

        if (logSignature == referralSignature) {
          final decodedReferral = referralRewardEvent.decodeResults(log.topics!, log.data!);
          print("✅ ReferralRewardPaid decoded: $decodedReferral");

          payload['referralAddress'] = decodedReferral[0].toString();
          payload['referee'] = decodedReferral[1].toString();
          payload['refVesting'] = decodedReferral[2].toString();
          payload['referralAmount'] = (decodedReferral[3] as BigInt).toDouble() / 1e18;
        }
      } catch (e, stackTrace) {
       }
    }

    return payload;
  }

  Future<void> _sendPurchaseDataToApi(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    const payloadApi = API_ENDPOINT;

    final response = await http.post(
      Uri.parse('$payloadApi/purchase-ecm-completed'),
      headers: headers,
      body: jsonEncode(payload),
    );
    print("API Response: ${response.statusCode} ${response.body}");

    if(response.statusCode != 201){
      throw Exception('Failed to send purchase data to API: ${response.statusCode}- ${response.body}');
    }else{
      debugPrint("✅ Purchase data sent successfully: ${response.body}");
    }

  }

  Future<String?> stakeNow(BuildContext context, double amount, int planIndex, {String referrerAddress = '0x0000000000000000000000000000000000000000'}) async {
    final chainID = getChainIdForRequests();

    /// Modal Check
    if (appKitModal == null || !_isConnected || appKitModal!.session == null || chainID == null) {
      ToastMessage.show(
        message: "Wallet Error",
        subtitle: "Please connect your wallet before staking.",
        type: MessageType.error,
      );
      throw Exception("Wallet not connected or chain not selected.");
    }

    if (amount <= 0 || planIndex < 0) {
      ToastMessage.show(
        message: "Invalid Input",
        subtitle: "Please enter a valid amount and select a plan",
        type: MessageType.info,
      );
      return null;
    }

    _isLoading = true;
    notifyListeners();
    final start = DateTime.now();

    try {
      /// Contract data setup

      final tokenAbiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final stakingAbiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
      print(">> ABIs loaded.");

      final ecmTokenContract = DeployedContract(
          ContractAbi.fromJson(jsonEncode(jsonDecode(tokenAbiString)),
              'eCommerce Coin'
              // 'ECommerceCoin'
          ),
          EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS));

      final stakingContract = DeployedContract(
          ContractAbi.fromJson(jsonEncode(jsonDecode(stakingAbiString)), 'eCommerce Coin'),
          EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE));

      final stakeFunction = stakingContract.function('stake');
      print('>> Staking function: ${stakeFunction.name}');

      for (int i = 0; i < stakeFunction.parameters.length; i++) {
        final param = stakeFunction.parameters[i];

      }

      final tokenDecimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS);
      final multiplier = Decimal.parse('1e$tokenDecimals');
      final stakeAmount = (Decimal.parse(amount.toString()) * multiplier).toBigInt();


      /// Approval Transaction
      ToastMessage.show(
        message: "Step 1 of 2: Approval",
        subtitle: "Please approve the token spending in your wallet.",
        type: MessageType.info,
        duration: CustomToastLength.LONG,
      );

      final approveStart = DateTime.now();
      final dynamic approveTxResult = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: ecmTokenContract,
        functionName: 'approve',
        transaction: Transaction(from: EthereumAddress.fromHex(_walletAddress)),
        parameters: [
          EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE),
          stakeAmount,
        ],
      );

      String approveTxHash;
      if (approveTxResult is String) {
        approveTxHash = approveTxResult;
      } else if (approveTxResult is Uint8List) {
        approveTxHash = bytesToHex(approveTxResult);
      } else {
        throw Exception("Unexpected type for approve transaction hash: ${approveTxResult.runtimeType}");
      }


      /// Wait for approval confirmation

      final approveReceipt = await _waitForTransaction(approveTxHash);
      if (approveReceipt == null) {
        throw Exception("Approval transaction failed or timed out.");
      }

      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "approve",
        ECM_TOKEN_CONTRACT_ADDRESS,
        true,
        DateTime.now().difference(approveStart).inMilliseconds,
        transactionHash: approveTxHash,
        extra: {
          "walletAddress": _walletAddress,
          "stakeAmount": stakeAmount.toString(),
        },
      );
      ToastMessage.show(
        message: "Approval Successful!",
        subtitle: "Now confirming the stake transaction.",
        type: MessageType.success,
      );

      /// Stake Transaction
      ToastMessage.show(
        message: "Step 2 of 2: Staking",
        subtitle: "Please confirm the transaction in your wallet.",
        type: MessageType.info,
        duration: CustomToastLength.LONG,
      );
      final stakeStart = DateTime.now();
      final dynamic stakeTxResult = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: stakingContract,
        functionName: 'stake',
        transaction: Transaction(from: EthereumAddress.fromHex(_walletAddress)),
        parameters: [
          stakeAmount,
          BigInt.from(planIndex),
          EthereumAddress.fromHex(referrerAddress),
        ],
      );

      String stakeTxHash;
      if (stakeTxResult is String) {
        stakeTxHash = stakeTxResult;
      } else if (stakeTxResult is Uint8List) {
        stakeTxHash = bytesToHex(stakeTxResult);
      } else {
        throw Exception("Unexpected type for stake transaction hash: ${stakeTxResult.runtimeType}");
      }

      final stakeReceipt = await _waitForTransaction(stakeTxHash);
      if (stakeReceipt == null) {
        throw Exception("Stake transaction failed or timed out.");
      }

      /// Post-Transaction & Event Parsing
      final stakeEvent = stakingContract.event('Staked');
      print(">> Parsing logs for 'Staked' event...");

      bool successShown = false;
      final stakeEventSignatureHex = bytesToHex(stakeEvent.signature);
      for (final log in stakeReceipt.logs) {
        try {
          if (log.topics != null && log.topics!.isNotEmpty) {
            final firstTopic = log.topics!.first;


            if (firstTopic == null) {
              continue;
            }

            String firstTopicHex;


            if (firstTopic is Uint8List) {
              firstTopicHex = bytesToHex(firstTopic as Uint8List);
            } else if (firstTopic is List<int>) {
              firstTopicHex = bytesToHex(Uint8List.fromList(firstTopic as List<int>));
            } else if (firstTopic is String) {

              final bytes = hexToBytes(firstTopic);
              firstTopicHex = bytesToHex(bytes);
            } else {
              continue;
            }

            final stakeEventHex = bytesToHex(stakeEvent.signature);


            if (firstTopicHex.toLowerCase() == stakeEventHex.toLowerCase()) {
              print(">> Matched 'Staked' event log");

              final decodedLog = stakeEvent.decodeResults(log.topics!, log.data!);
              final payload = {
                'hash': bytesToHex(stakeReceipt.transactionHash),
                'staker': (decodedLog[0] as EthereumAddress).hex,
                'stakeId': (decodedLog[1] as BigInt).toString(),
                'amount': EtherAmount.fromUnitAndValue(EtherUnit.wei, decodedLog[2] as BigInt)
                    .getValueInUnit(EtherUnit.ether)
                    .toString(),
                'planIndex': (decodedLog[3] as BigInt).toString(),
                'endTime': (decodedLog[4] as BigInt).toString(),
              };

              await logRocketTrackBlockChainEvent(
                "TRANSACTION",
                "stake",
                STAKING_CONTRACT_ADDRESSLIVE,
                true,
                DateTime.now().difference(stakeStart).inMilliseconds,
                transactionHash: stakeTxHash,
                extra: {
                  "walletAddress": _walletAddress,
                  "stakeAmount": stakeAmount.toString(),
                  "planIndex": planIndex.toString(),
                  "referrerAddress": referrerAddress,
                  "stakeId": payload['stakeId'],
                },
              );

              final apiUrl = '${ApiConstants.baseUrl}/staking-created';
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token');

              try {
                final response = await http.post(
                  Uri.parse(apiUrl),
                  headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    if (token != null) 'Authorization': 'Bearer $token',
                  },
                  body: jsonEncode(payload),
                );
                 print(">> Response body: ${response.body}");
                final postToken = prefs.getString('token');
                print(">> Token AFTER response: $postToken");

                if (response.statusCode != 200 && response.statusCode != 201) {
                  throw Exception("Failed to sync stake to backend: ${response.statusCode}");
                }
              } catch (e) {
                print(">> HTTP POST failed: $e");
              }

              ToastMessage.show(
                message: "Staking Successful!",
                subtitle: "Your tokens have been staked.",
                type: MessageType.success,
                duration: CustomToastLength.LONG,
              );

              await fetchConnectedWalletData();
              successShown = true;
              return bytesToHex(stakeReceipt.transactionHash);
            }
          } else {
            print(">> Skipping log with empty or null topics.");
          }
        } catch (e, stackTrace) {
          print(">> Error decoding log: $e");
         }
      }

      if (!successShown) {
        await logRocketTrackBlockChainEvent(
          "TRANSACTION",
          "stake",
          STAKING_CONTRACT_ADDRESSLIVE,
          true,
          DateTime.now().difference(stakeStart).inMilliseconds,
          transactionHash: stakeTxHash,
          extra: {
            "walletAddress": _walletAddress,
            "stakeAmount": stakeAmount.toString(),
            "planIndex": planIndex.toString(),
            "note": "No Staked event found",
          },
        );

        ToastMessage.show(
          message: "Staking Success (No Event Found)",
          subtitle: "Stake transaction confirmed, but event not parsed.",
          type: MessageType.success,
        );
        await fetchConnectedWalletData();
        return bytesToHex(stakeReceipt.transactionHash);
      }

      return null;
    } catch (e, stackTrace) {
      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "stake",
        STAKING_CONTRACT_ADDRESSLIVE,
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "error": e.toString(),
          "walletAddress": _walletAddress,
          "stakeAmount": amount.toString(),
          "planIndex": planIndex.toString(),
        },
      );
      final isUserRejected = isUserRejectedError(e);
      ToastMessage.show(
        message: isUserRejected ? "Transaction Cancelled" : "Staking Failed",
        subtitle: isUserRejected
            ? "You cancelled the transaction in your wallet."
            : "An error occurred during staking.",
        type: isUserRejected ? MessageType.info : MessageType.error,
        duration: CustomToastLength.LONG,
      );
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

  }

  Future<String?> forceUnstake(int stakeId)async{
    final chainID = getChainIdForRequests();

    if (!_isConnected || appKitModal?.session == null || chainID == null) {
      ToastMessage.show(message: "Connect wallet first.", type: MessageType.error);
      return null;
    }
    _isLoading = true;
    notifyListeners();
    final start = DateTime.now();

    try{

      final stakingAbiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
      final stakingContract = DeployedContract(
        ContractAbi.fromJson(stakingAbiString, 'eCommerce Coin'),
        EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE),
      );

      /// Call forceUnstake function on contract
      final txResult = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: stakingContract,
        functionName: 'forceUnstake',
        transaction: Transaction(
          from: EthereumAddress.fromHex(_walletAddress),
        ),
        parameters: [BigInt.from(stakeId)],

      );

      final txHash = txResult is String ? txResult : bytesToHex(txResult);
      final receipt = await _waitForTransaction(txHash);
      if(receipt == null) throw Exception("Transaction failed or time out");


      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "forceUnstake",
        STAKING_CONTRACT_ADDRESSLIVE,
        true,
        DateTime.now().difference(start).inMilliseconds,
        transactionHash: txHash,
        extra: {
          "walletAddress": _walletAddress,
          "stakeId": stakeId.toString(),
        },
      );

      /// Parse logs for Unstaked and ReferralCommissionPaid events
      final unstakedEvent = stakingContract.event('Unstaked');
      final referralEvent = stakingContract.event('ReferralCommissionPaid');

      for (final log in receipt.logs){
        try{
          if(log.topics == null || log.data == null) continue;
          final topics = log.topics!;
          final data = log.data!;

          if(topics.isEmpty) continue;

          /// Check Event Signature match
          final topic0 = topics[0];
          late final String topic0Hex;

          if (topic0 is Uint8List) {
            topic0Hex = bytesToHex(topic0 as Uint8List);
          } else if (topic0 is List<int>) {
            topic0Hex = bytesToHex(Uint8List.fromList(topic0 as List<int>));
          } else if (topic0 is String) {
            final decoded = hexToBytes(topic0);
            topic0Hex = bytesToHex(decoded);
          } else {
            continue;
          }


          final unstakedSig  = bytesToHex(unstakedEvent.signature);
          final referralSig = bytesToHex(referralEvent.signature);

          if(topic0Hex.toLowerCase() == unstakedSig.toLowerCase()){
            final decoded = unstakedEvent.decodeResults(topics, data);
            await unStakeCreate(txHash, decoded);
          }else if (topic0Hex.toLowerCase() == referralSig.toLowerCase()) {
            final decoded = referralEvent.decodeResults(topics, data);
            await unStakeReferral(txHash, decoded);
          }
        }catch(e, stackTrace){
          print("Error decoding log: $e");
         }
      }


      await fetchConnectedWalletData();
      await getBalance();
      ToastMessage.show(message: "Force unstake successful!", type: MessageType.success);
      return txHash;
    }catch(e, stackTrace){

      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "forceUnstake",
        STAKING_CONTRACT_ADDRESSLIVE,
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "error": e.toString(),
          "walletAddress": _walletAddress,
          "stakeId": stakeId.toString(),
        },
      );

       final isUserRejected = isUserRejectedError(e);
      ToastMessage.show(
        message: isUserRejected ? "Transaction Cancelled" : "Force Unstake Failed",
        subtitle: isUserRejected
            ? "You cancelled the transaction in your wallet."
            : "An error occurred during force unstake.",
        type: isUserRejected ? MessageType.info : MessageType.error,
        duration: CustomToastLength.LONG,
      );

      return null;
    }finally {
      _isLoading = false;
      notifyListeners();
    }

  }

  Future<String?> unstake(int stakeId) async {
    final chainID = getChainIdForRequests();

    if (!_isConnected || appKitModal?.session == null || chainID == null) {
      ToastMessage.show(message: "Connect wallet first.", type: MessageType.error);
      return null;
    }

    _isLoading = true;
    notifyListeners();
    final start = DateTime.now();

    try {

      final stakingAbiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
      final stakingContract = DeployedContract(
        ContractAbi.fromJson(stakingAbiString, 'eCommerce Coin'),
        EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSLIVE),
      );

      final txResult = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: stakingContract,
        functionName: 'unstake',
        transaction: Transaction(
          from: EthereumAddress.fromHex(_walletAddress),
        ),
        parameters: [BigInt.from(stakeId)],
      );

      final txHash = txResult is String ? txResult : bytesToHex(txResult);
      final receipt = await _waitForTransaction(txHash);
      if (receipt == null) throw Exception("Transaction failed or timed out");

      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "unstake",
        STAKING_CONTRACT_ADDRESSLIVE,
        true,
        DateTime.now().difference(start).inMilliseconds,
        transactionHash: txHash,
        extra: {
          "walletAddress": _walletAddress,
          "stakeId": stakeId.toString(),
        },
      );

      final unstakedEvent = stakingContract.event('Unstaked');
      final referralEvent = stakingContract.event('ReferralCommissionPaid');

      for (final log in receipt.logs) {
        try {
          if (log.topics == null || log.data == null) continue;
          final topics = log.topics!;
          final data = log.data!;

          if (topics.isEmpty) continue;

          final topic0 = topics[0];
          late final String topic0Hex;

          if (topic0 is Uint8List) {
            topic0Hex = bytesToHex(topic0 as List<int>);
          } else if (topic0 is List<int>) {
            topic0Hex = bytesToHex(Uint8List.fromList(topic0 as List<int>));
          } else if (topic0 is String) {
            final decoded = hexToBytes(topic0);
            topic0Hex = bytesToHex(decoded);
          } else {
            continue;
          }

          final unstakedSig = bytesToHex(unstakedEvent.signature);
          final referralSig = bytesToHex(referralEvent.signature);

          if (topic0Hex.toLowerCase() == unstakedSig.toLowerCase()) {
            final decoded = unstakedEvent.decodeResults(topics, data);
            await unStakeCreate(txHash, decoded);
          } else if (topic0Hex.toLowerCase() == referralSig.toLowerCase()) {
            final decoded = referralEvent.decodeResults(topics, data);
            await unStakeReferral(txHash, decoded);
          }
        } catch (e, stackTrace) {
          print("Error decoding log: $e");
         }
      }

      await fetchConnectedWalletData();
      await getBalance();

      ToastMessage.show(message: "Unstake successful!", type: MessageType.success);
      return txHash;
    } catch (e, stackTrace) {

      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "unstake",
        STAKING_CONTRACT_ADDRESSLIVE,
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "error": e.toString(),
          "walletAddress": _walletAddress,
          "stakeId": stakeId.toString(),
        },
      );

       final isUserRejected = isUserRejectedError(e);
      ToastMessage.show(
        message: isUserRejected ? "Transaction Cancelled" : "Unstake Failed",
        subtitle: isUserRejected
            ? "You cancelled the transaction in your wallet."
            : "An error occurred during unstaking.",
        type: isUserRejected ? MessageType.info : MessageType.error,
        duration: CustomToastLength.LONG,
      );
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> unStakeCreate(String hash, List<dynamic> decodedLog) async {
    final payload = {
      'unstake_hash': hash,
      'stakeId': (decodedLog[1] as BigInt).toString(),
      'amount': EtherAmount.fromUnitAndValue(EtherUnit.wei, decodedLog[2] as BigInt).getValueInUnit(EtherUnit.ether).toString(),
      'rewardAmount': EtherAmount.fromUnitAndValue(EtherUnit.wei, decodedLog[3] as BigInt).getValueInUnit(EtherUnit.ether).toString(),
      'unstakeType': decodedLog[4],
    };

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/unstake-created'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to sync unstake create');
    }
  }

  Future<void> unStakeReferral(String hash, List<dynamic> decodedLog) async {
    final payload = {
      'hash': hash,
      'referral': decodedLog[0].toString(),
      'staker': decodedLog[1].toString(),
      'stakeId': (decodedLog[2] as BigInt).toString(),
      'amount': EtherAmount.fromUnitAndValue(EtherUnit.wei, decodedLog[3] as BigInt).getValueInUnit(EtherUnit.ether).toString(),
    };


    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/unstake-referral-reward'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to sync unstake referral');
    }
  }

  /// ICO Vesting
  Future<void> getVestingInformation() async {

    if (!_isConnected || _walletAddress.isEmpty) return;

    // _isLoading = true;
    notifyListeners();
    final start = DateTime.now();

    try {
      final chainId = getChainIdForRequests();
      if (chainId == null) throw Exception('Chain ID is not available.');

      final saleContractAbiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
      final saleContractAbiData = jsonDecode(saleContractAbiString);
      final saleContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(saleContractAbiData), 'ECMCoinICO'),
        EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
      );

      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
      final walletAddressHex = appKitModal?.session?.getAddress(nameSpace);
      if (walletAddressHex == null) throw Exception('Wallet address is null.');

      final userWalletAddress = EthereumAddress.fromHex(walletAddressHex);

      // vestingOf function on the Sale Contract
      final vestingOfResult = await _web3Client!.call(
        contract: saleContract,
        function: saleContract.function('vestingOf'),
        params: [userWalletAddress],
      );

      final vestingContractAddress = vestingOfResult[0] as EthereumAddress;
      final zeroAddress = EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');

      await logRocketTrackBlockChainEvent(
        "VESTING_INFO",
        "vestingOf",
        SALE_CONTRACT_ADDRESS,
        true,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "walletAddress": userWalletAddress.hex,
          "vestingContractAddress": vestingContractAddress.hex,
        },
      );

      if (vestingContractAddress == zeroAddress) {
        // No vesting contract for user
        _vestingAddress = null;
        _vestingStatus = null;
      } else {
        _vestingAddress = vestingContractAddress.hex;
        await _resolveVestedStart(vestingContractAddress);
      }
    } catch (e, stackTrace) {

      await logRocketTrackBlockChainEvent(
        "VESTING_INFO",
        "vestingOf",
        SALE_CONTRACT_ADDRESS,
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "error": e.toString(),
          "walletAddress": _walletAddress,
        },
      );

       _vestingAddress = null;
      _vestingStatus = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _resolveVestedStart(EthereumAddress vestingContractAddress) async {
    final start = DateTime.now();

    try {
      print("fetching vestingContract Address : ${vestingContractAddress.hex}");

      if (_web3Client == null) {
         _vestingAddress = null;
        notifyListeners();
        return;
      }

      final vestingAbiString = await rootBundle.loadString("assets/abi/VestingABI.json");
      final vestingAbiData = jsonDecode(vestingAbiString);

      final vestedContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(vestingAbiData), 'LinearVestingWallet'),
        vestingContractAddress,
      );

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;


      final startResult = await _web3Client!.call(contract: vestedContract, function: vestedContract.function('start'), params: []);
      print("   Raw start: ${startResult[0]}");

       final cliffResult = await _web3Client!.call(contract: vestedContract, function: vestedContract.function('cliff'), params: []);
      print("   Raw cliff: ${cliffResult[0]}");

       final durationResult = await _web3Client!.call(contract: vestedContract, function: vestedContract.function('duration'), params: []);
      print("   Raw duration: ${durationResult[0]}");

      //'released' function that takes no parameters
      final releasedFunction = vestedContract.findFunctionsByName('released').firstWhere((func) => func.parameters.isEmpty);
      final releasedResult = await _web3Client!.call(contract: vestedContract, function: releasedFunction, params: []);
      print("   Raw released: ${releasedResult[0]}");

      //'vestedAmount' function that takes one parameter (timestamp)
      final vestedAmountFunction = vestedContract.findFunctionsByName('vestedAmount').firstWhere((func) => func.parameters.length == 1,);
      final claimableResult = await _web3Client!.call(contract: vestedContract, function: vestedAmountFunction, params: [BigInt.from(now)]);
      print("Raw vestedAmount (claimable): ${claimableResult[0]}");


      final startVal = (startResult[0] as BigInt).toInt();
      final cliff = (cliffResult[0] as BigInt).toInt();
      final duration = (durationResult[0] as BigInt).toInt();
      final released = (releasedResult[0] as BigInt);
      final claimable = (claimableResult[0] as BigInt);


      print("start: $startVal");
      print("cliff: $cliff");
      print("duration: $duration");
      print("released: $released");
      print("claimable: $claimable");

      vestInfo.start = startVal;
      vestInfo.cliff = cliff;
      vestInfo.duration = duration;
      vestInfo.released = released .toDouble();
      vestInfo.claimable = claimable.toDouble();
      vestInfo.end = startVal + duration;
      _vestingStatus = startVal > now ? 'locked' : 'process';

      await logRocketTrackBlockChainEvent(
        "VESTING_DURATIONS",
        "resolveVestedStart",
        vestingContractAddress.hex,
        true,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "walletAddress": _walletAddress,
          "vestingAddress": vestingContractAddress.hex,
          "start": startVal.toString(),
          "cliff": cliff.toString(),
          "duration": duration.toString(),
          "released": released.toString(),
          "claimable": claimable.toString(),
        },
      );

      notifyListeners();

    } catch (e, stackTrace) {
      await logRocketTrackBlockChainEvent(
        "VESTING_DURATIONS",
        "resolveVestedStart",
        vestingContractAddress.hex,
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "error": e.toString(),
          "walletAddress": _walletAddress,
          "vestingAddress": vestingContractAddress.hex,
        },
      );
       _vestingStatus = null;
      notifyListeners();
    }
  }

  Future<void>claimECM(BuildContext context)async{

    _isLoading = true;
    notifyListeners();
    final start = DateTime.now();

    try{
      // 1. Get the ABI and create a DeployedContract instance
      final abiString = await rootBundle.loadString("assets/abi/VestingABI.json");
      final abiData = jsonDecode(abiString);
      final vestingContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abiData), 'LinearVestingWallet'),
        EthereumAddress.fromHex(_vestingAddress!),
      );

      // 2. Get the current chain and wallet address
      final chainId = getChainIdForRequests();
      if (chainId == null) {
        throw Exception("Selected chain not available.");
      }
      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
      final walletAddress = appKitModal!.session!.getAddress(nameSpace);
      if (walletAddress == null) {
        throw Exception("Wallet address not found.");
      }

      final releasedFunction = vestingContract.findFunctionsByName('released').firstWhere((func) => func.parameters.isEmpty);
      final releasedResult = await _web3Client!.call(
          contract: vestingContract,
          function: releasedFunction,
          params: []
      );
      print("Raw released: ${releasedResult[0]}");
      print('claimECM: Raw releasedResult = $releasedResult');

      final releasedWei = releasedResult.length > 0 ? releasedResult[0] as BigInt : BigInt.zero;
      if (releasedResult.length > 1) {
        print('claimECM: Warning - Multiple values returned by released(): $releasedResult');
      }

      final releasedEther = EtherAmount.fromBigInt(EtherUnit.wei, releasedWei).getValueInUnit(EtherUnit.ether);
      final releasedAmountFormatted = releasedEther.toStringAsFixed(6);
      print('claimECM: Released amount = $releasedAmountFormatted');


      // 3. Request the transaction via the AppKitModal
      print('Attempting to claim ECM from vesting contract...');
      final txResult = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainId,
        deployedContract: vestingContract,
        functionName: 'claim',
        transaction: Transaction(from: EthereumAddress.fromHex(walletAddress)),
        parameters: [],
      );
      print('claimECM: Raw txResult = $txResult');

      String? transactionHash;
      if (txResult is String) {
        transactionHash = txResult;
      } else if (txResult is Map<String, dynamic> && txResult['code'] != null) {
        throw Exception("Transaction failed: ${txResult['message']}");
      } else {
        throw Exception("Unknown transaction result format");
      }

      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "claim",
        _vestingAddress!,
        true,
        DateTime.now().difference(start).inMilliseconds,
        transactionHash: transactionHash,
        extra: {
          "walletAddress": walletAddress,
          "vestingAddress": _vestingAddress!,
        },
      );

      print('Transaction Hash: $transactionHash');

      const payloadApi = API_ENDPOINT;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      //  API call to log claim history
      final payload = {
        "amount": releasedAmountFormatted,
        "wallet_address": walletAddress,
        "hash": txResult,
        "type": "ICO_Vesting",
      };

      final response = await http.post(
        Uri.parse('$payloadApi/vesting-claim'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': token != null && token.isNotEmpty ? 'Bearer $token' : '',
        },
        body: jsonEncode(payload),
      );

      print("claimECM response.statusCode ${response.statusCode}");
      print("claimECM ${response.body}");
      print("claimECM ${payload}");
      if (response.statusCode == 200) {
        print('Claim history logged successfully');
      } else {
        print('Failed to log claim history: ${response.body}');
      }

      ToastMessage.show(
        message: "Your ECM tokens have been claimed successfully.",
        subtitle: "Transaction hash: $txResult.",
        type: MessageType.success,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

      // 4. Automatically refresh vesting data after a successful claim
      // await refreshVesting();
      await getVestingInformation();
    } catch (e, stackTrace) {

      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "claim",
        _vestingAddress ?? "unknown",
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "error": e.toString(),
          "walletAddress": _walletAddress,
          "vestingAddress": _vestingAddress ?? "none",
        },
      );

       print('Error during claimECM: $e');
      final errorMessage = e.toString().contains("User rejected")
          ? "Transaction rejected by user."
          : "Claim failed. Please try again.";

      print('CLAIM Button : ${errorMessage}');
      ToastMessage.show(
        message: "Claim Failed",
        subtitle: errorMessage,
        type: MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshVesting() async {
    if (_isLoading || _vestingAddress == null) return;
    _isLoading = true;
    notifyListeners();
    final start = DateTime.now();

    try{
      // 1. Get the ABI and create a DeployedContract instance
      final abiString = await rootBundle.loadString("assets/abi/VestingABI.json");
      final abiData = jsonDecode(abiString);
      final vestingContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abiData), 'LinearVestingWallet'),
        EthereumAddress.fromHex(_vestingAddress!),
      );

      // 2. Read the `released()` value from the contract
      final releasedResult = await _web3Client!.call(
        contract: vestingContract,
        function: vestingContract.function('released'),
        params: [],
      );

      print('refreshVesting: Raw releasedResult = $releasedResult'); // Debug the full result
      // Convert the BigInt to a double and format to 6 decimal places,
      final releasedWei = releasedResult.length > 0 ? releasedResult[0] as BigInt : BigInt.zero;
      if (releasedResult.length > 1) {
        print('refreshVesting: Warning - Multiple values returned by released(): $releasedResult');
      }
      final releasedEther = EtherAmount.fromBigInt(EtherUnit.wei, releasedWei).getValueInUnit(EtherUnit.ether);
      final releasedAmountFormatted = releasedEther.toStringAsFixed(6);
      await logRocketTrackBlockChainEvent(
        "CONTRACT_CALL",
        "released",
        _vestingAddress!,
        true,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "walletAddress": _walletAddress,
          "vestingAddress": _vestingAddress!,
          "releasedAmount": releasedAmountFormatted,
        },
      );

      // Update Vesting Info Model to reflect new data
      vestInfo.released = releasedEther;
      print('claimECM: Raw releasedResult = ${vestInfo.released}');

      ToastMessage.show(
        message: "Vesting Refreshed",
        subtitle: "Latest vesting data has been updated.",
        type: MessageType.success,
        duration: CustomToastLength.SHORT,
        gravity: CustomToastGravity.BOTTOM,
      );
      print("Vesting refreshed successfully , Released :$releasedAmountFormatted ");


    } catch (e, stackTrace) {

      await logRocketTrackBlockChainEvent(
        "CONTRACT_CALL",
        "released",
        _vestingAddress ?? "unknown",
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "error": e.toString(),
          "walletAddress": _walletAddress,
          "vestingAddress": _vestingAddress ?? "none",
        },
      );

       final errorMessage = e.toString().contains('no contract')
          ? 'Vesting contract not found or invalid address.'
          : e.toString();

      ToastMessage.show(
        message: "Refresh Failed",
        subtitle: "Could not fetch latest vesting data. $errorMessage",
        type: MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

    } finally {
      _isLoading = false;
      notifyListeners();
    }

  }
  // Getter to calculate the total amount of ECM vested so far
  double get vestedAmount {
    if (vestInfo.start == 0 || vestInfo.end == 0 || balance == null) return 0.0;

    final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final start = vestInfo.start;
    final end = vestInfo.end;
    final duration = vestInfo.duration;

    final totalVestingECM = double.tryParse(balance!) ?? 0.0;

    if (nowSec <= start!) {
      return 0.0;
    }
    if (nowSec >= end!) {
      return totalVestingECM;
    }

    final elapsed = nowSec - start;
    final calculatedAmount = (totalVestingECM * elapsed) / duration!;
    return double.parse(calculatedAmount.toStringAsFixed(6));
  }
  // Getter to calculate the amount of ECM available for claim
  double get availableClaimableAmount {
    final vested = vestedAmount;
    final released = vestInfo.released;
    final available = vested - released!;
    return available > 0 ? available : 0.0;
  }


  /// Existing User Vesting
  Future<String?> startVesting(BuildContext context)async{


    final balance = double.tryParse(_balance ?? '0') ?? 0;
    if(balance <= 1){
      ToastMessage.show(
        message: "Insufficient ECM Balance",
        subtitle: "You need at least 1 ECM to start vesting.",
        type: MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      return null;
    }

    _isLoading = true;
    notifyListeners();
    final start = DateTime.now();

    try{
      final chainId = getChainIdForRequests();
      print('startVesting: Chain ID = $chainId');
      if (chainId == null) {
        throw Exception("Selected chain not available.");
      }

      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
      final walletAddress = appKitModal!.session!.getAddress(nameSpace);
      print('startVesting: Wallet Address = $walletAddress');
      if(walletAddress == null){
        throw Exception("Wallet address not found.");
      }

      // Load ABI
      final tokenAbiString = await rootBundle.loadString("assets/abi/ECMContractABI.json");
      final vestingAbiString = await rootBundle.loadString("assets/abi/ExitingVestingABI.json");
      final tokenAbiData = jsonDecode(tokenAbiString);
      final vestingAbiData = jsonDecode(vestingAbiString);

      //Initialize Contracts
      final ecmTokenContract = DeployedContract(
          ContractAbi.fromJson(jsonEncode(tokenAbiData), 'ECommerceCoin'),
          EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS)
      );

      final vestingContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(vestingAbiData), 'ECMcoinVesting'),
          EthereumAddress.fromHex(EXITING_VESTING_ADDRESS)
      );

      //Token Decimals
      final userBalance = await _web3Client!.call(
          contract: ecmTokenContract,
          function: ecmTokenContract.function('balanceOf'),
          params: [EthereumAddress.fromHex(walletAddress)]
      );
      final balanceWei = userBalance[0] as BigInt;
      final balanceEther = EtherAmount.fromBigInt(EtherUnit.wei, balanceWei).getValueInUnit(EtherUnit.ether);

      print('Existing Vesting :: User balance: ${balanceEther.toStringAsFixed(2)} ECM');

      // Approve Transaction
      ToastMessage.show(
        message: "Step 1 of 2: Approval",
        subtitle: "Please approve the token spending in your wallet.",
        type: MessageType.info,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

      final approveStart = DateTime.now();
      final approveTxResult = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainId,
        deployedContract: ecmTokenContract,
        functionName: 'approve',
        transaction: Transaction(from: EthereumAddress.fromHex(walletAddress)),
        parameters: [
          EthereumAddress.fromHex(EXITING_VESTING_ADDRESS),
          balanceWei,
        ],
      );

      final approveTxHash = approveTxResult is String ? approveTxResult : bytesToHex(approveTxResult);
      final approveReceipt = await _waitForTransaction(approveTxHash);
      if (approveReceipt == null) {
        throw Exception("Approval transaction failed or timed out.");
      }

      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "approve",
        ECM_TOKEN_CONTRACT_ADDRESS,
        true,
        DateTime.now().difference(approveStart).inMilliseconds,
        transactionHash: approveTxHash,
        extra: {
          "walletAddress": walletAddress,
          "vestingAddress": EXITING_VESTING_ADDRESS,
          "balanceWei": balanceWei.toString(),
        },
      );
      ToastMessage.show(
        message: "Approval Successful!",
        subtitle: "Now confirming the vesting transaction.",
        type: MessageType.success,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

      //  Vesting transaction
      ToastMessage.show(
        message: "Step 2 of 2: Vesting",
        subtitle: "Please confirm the vesting transaction in your wallet.",
        type: MessageType.info,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

      final vestingStart = DateTime.now();
      final vestingTxResult = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainId,
        deployedContract: vestingContract,
        functionName: 'vestTokens',
        transaction: Transaction(from: EthereumAddress.fromHex(walletAddress)),
        parameters: [],
      );

      final vestingTxHash = vestingTxResult is String ? vestingTxResult : bytesToHex(vestingTxResult);
      final vestingReceipt = await _waitForTransaction(vestingTxHash);
      if (vestingReceipt == null) {
        throw Exception("Vesting transaction failed or timed out.");
      }
      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "vestTokens",
        EXITING_VESTING_ADDRESS,
        true,
        DateTime.now().difference(vestingStart).inMilliseconds,
        transactionHash: vestingTxHash,
        extra: {
          "walletAddress": walletAddress,
          "vestingAddress": EXITING_VESTING_ADDRESS,
        },
      );
      ToastMessage.show(
        message: "Vesting Started Successfully!",
        subtitle: "Your ECM tokens are now vesting.",
        type: MessageType.success,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      // Refresh vesting information
      await getExistingVestingInformation();
      print('Post-vesting state: existingVestingStatus = $_existingVestingStatus, vestInfo = $existingVestInfo');

      return vestingTxHash;

    }catch(e){
      print('startVesting Error: $e');
      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "startVesting",
        EXITING_VESTING_ADDRESS,
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "error": e.toString(),
          "walletAddress": _walletAddress,
        },
      );

      final isUserRejected = isUserRejectedError(e);
      ToastMessage.show(
        message: isUserRejected ? "Transaction Cancelled" : "Vesting Failed",
        subtitle: isUserRejected
            ? "You cancelled the transaction in your wallet."
            : "An error occurred during vesting. Please try again.",
        type: isUserRejected ? MessageType.info : MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      return null;
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getExistingVestingInformation() async {
    if (!_isConnected || _walletAddress.isEmpty) {
      print('getExistingVestingInformation: Wallet not connected or address empty');
      return;
    }
    _isLoading = true;
    notifyListeners();
    final startTime = DateTime.now();
    try {
      final chainId = getChainIdForRequests();
      print('getExistingVestingInformation: Chain ID = $chainId');
      if (chainId == null) throw Exception('Chain ID is not available.');

      // Load ExitingVesting ABI
      final vestingAbiString = await rootBundle.loadString("assets/abi/ExitingVestingABI.json");
      final vestingAbiData = jsonDecode(vestingAbiString);

      final vestingContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(vestingAbiData), 'ECMcoinVesting'),
        EthereumAddress.fromHex(EXITING_VESTING_ADDRESS),
      );

      int retryCount = 0;
      const maxRetries = 3;
      BigInt? count;

      do{
        // Step 1: Get vesting schedules count
        final countResult = await _web3Client!.call(
          contract: vestingContract,
          function: vestingContract.function('getVestingSchedulesCountByBeneficiary'),
          params: [EthereumAddress.fromHex(_walletAddress)],
        );
        print('getVestingSchedulesCount raw countResult: $countResult');

        count = countResult[0] is BigInt ? countResult[0] as BigInt : BigInt.from(countResult[0]);
        if (count == BigInt.zero && retryCount < maxRetries) {
          await Future.delayed(const Duration(seconds: 2));
          retryCount++;
        }

      }while (count == BigInt.zero && retryCount < maxRetries);


      await logRocketTrackBlockChainEvent(
        "VESTING_INFO",
        "getVestingSchedulesCountByBeneficiary",
        EXITING_VESTING_ADDRESS,
        true,
        DateTime.now().difference(startTime).inMilliseconds,
        extra: {
          "walletAddress": _walletAddress,
          "count": count.toString(),
        },
      );

      if(count > BigInt.zero){
        // Step 2: Resolve details from last schedule
        await resolveExistingVestedStart(vestingContract);
        final vestingIdFunction = vestingContract.function('computeVestingScheduleIdForAddressAndIndex');
        final vestingIdResult = await _web3Client!.call(
          contract: vestingContract,
          function: vestingIdFunction,
          params: [EthereumAddress.fromHex(_walletAddress), BigInt.zero],
        );

        //  Compute vestingId (bytes32) and handle as byte array
        final vestingIdBytes = vestingIdResult[0] as Uint8List;
        final releasableFunction = vestingContract.function('computeReleasableAmount');
        final releasableBnResult = await _web3Client!.call(
          contract: vestingContract,
          function: releasableFunction,
          params: [vestingIdBytes],
        );

        final releasableBn = releasableBnResult[0] as BigInt; // Directly cast as BigInt
        final releasable = EtherAmount.fromBigInt(EtherUnit.wei, releasableBn).getValueInUnit(EtherUnit.ether).toDouble();
        existingVestInfo.claimable = releasable;
        print('getExistingVestingInformation: Computed releasable = $releasable');

       }else{
        // No vesting schedules
        _existingVestingAddress = null;
        _existingVestingStatus = null;
        existingVestInfo.start = 0;
        existingVestInfo.cliff = 0;
        existingVestInfo.duration = 0;
        existingVestInfo.end = 0;
        existingVestInfo.released = 0.0;
        existingVestInfo.claimable = 0.0;
        existingVestInfo.totalVestingAmount = 0.0;
        notifyListeners();
      }

    } catch (e, stackTrace) {
      print('getExistingVestingInformation Error: $e');
      if (e.toString().contains('function does not exist') || e.toString().contains('revert')) {
        print('ABI/Function mismatch - Check ExitingVestingABI.json for getVestingSchedulesCountByBeneficiary');
      }

      await logRocketTrackBlockChainEvent(
        "VESTING_INFO",
        "getVestingSchedulesCountByBeneficiary",
        EXITING_VESTING_ADDRESS,
        false,
        DateTime.now().difference(startTime).inMilliseconds,
        extra: {
          "error": e.toString(),
          "walletAddress": _walletAddress,
        },
      );

      _existingVestingAddress = null;
      _existingVestingStatus = null;
      existingVestInfo.start = 0;
      existingVestInfo.cliff = 0;
      existingVestInfo.duration = 0;
      existingVestInfo.end = 0;
      existingVestInfo.released = 0.0;
      existingVestInfo.claimable = 0.0;
      existingVestInfo.totalVestingAmount = 0.0;
      notifyListeners();

    }
  }

  Future<void> resolveExistingVestedStart(DeployedContract vestingContract)async{
    final startTime = DateTime.now();

    try{
      if(_web3Client == null){
        print('resolveExistingVestedStart: Web3Client null');
        _existingVestingAddress = null;
        _existingVestingStatus = null;
        notifyListeners();
        return;
      }


      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Current Unix timestamp (~1757548800 on Sep 11, 2025)
       print('resolveExistingVestedStart: Current now timestamp = $now');

      final scheduleResult = await _web3Client!.call(
          contract: vestingContract,
          function: vestingContract.function('getLastVestingScheduleForHolder'),
          params: [EthereumAddress.fromHex(_walletAddress)]
      );
      if (scheduleResult.isEmpty || scheduleResult[0] == null) {
        throw Exception('No vesting schedule found');
      }
      print('resolveExistingVestedStart: Raw schedule result = $scheduleResult');

      final schedule = scheduleResult[0] as List;
      /// Safely cast to BigInt, handling potential byte array or numeric types
      final cliffBn = schedule[1] is BigInt ? schedule[1] as BigInt : BigInt.from(schedule[1]);
      final startBn = schedule[2] is BigInt ? schedule[2] as BigInt : BigInt.from(schedule[2]);
      final durationBn = schedule[3] is BigInt ? schedule[3] as BigInt : BigInt.from(schedule[3]);
      final totalVestingAmountBn = schedule[5] is BigInt ? schedule[5] as BigInt : BigInt.from(schedule[5]);
      final releasedBn = schedule[6] is BigInt ? schedule[6] as BigInt : BigInt.from(schedule[6]);


      final startVal = (startBn).toInt();
      print('resolveExistingVestedStart: Parsed startVal = $startVal');
      final cliff = (cliffBn).toInt();
      final duration = (durationBn).toInt();
      final end = startVal + duration;
      final released = EtherAmount.fromBigInt(EtherUnit.wei, releasedBn).getValueInUnit(EtherUnit.ether).toDouble();
      final totalVestingAmount = EtherAmount.fromBigInt(EtherUnit.wei, totalVestingAmountBn).getValueInUnit(EtherUnit.ether).toDouble();
      final claimable = 0.0;

      print("resolveExistingVestedStart: "
          "Existing vesting details: "
          "start=$startVal,"
          " cliff=$cliff,"
          " duration=$duration,"
          " end=$end,"
          " released=$released,"
          " total=$totalVestingAmount");

      existingVestInfo.start = startVal;
      existingVestInfo.cliff = cliff;
      existingVestInfo.duration = duration;
      existingVestInfo.end = end;
      existingVestInfo.released = released;
      existingVestInfo.claimable = claimable;
      existingVestInfo.totalVestingAmount = totalVestingAmount;

      final status = startVal > now ? 'locked' : 'process';
      print('resolveExistingVestedStart: Setting status = $status (start $startVal vs now $now)');


      _existingVestingStatus = status;
      _existingVestingAddress = EXITING_VESTING_ADDRESS;

      await logRocketTrackBlockChainEvent(
        "VESTING_DURATIONS",
        "resolveExistingVestedStart",
        EXITING_VESTING_ADDRESS,
        true,
        DateTime.now().difference(startTime).inMilliseconds,
        extra: {
          "walletAddress": _walletAddress,
          "vestingAddress": EXITING_VESTING_ADDRESS,
          "start": startVal.toString(),
          "cliff": cliff.toString(),
          "duration": duration.toString(),
          "end": end.toString(),
          "released": released.toString(),
          "totalVestingAmount": totalVestingAmount.toString(),
        },
      );
      print('Notifying listeners with existingVestingStatus: $_existingVestingStatus, existingVestingAddress: $_existingVestingAddress');
      notifyListeners();

    }catch(e){
      print('resolveExistingVestedStart Error: $e');
      if (e.toString().contains('function does not exist') || e.toString().contains('revert')) {
        print('ABI/Function mismatch - Check ExitingVestingABI.json for getLastVestingScheduleForHolder');
      }
      await logRocketTrackBlockChainEvent(
        "VESTING_DURATIONS",
        "resolveExistingVestedStart",
        EXITING_VESTING_ADDRESS,
        false,
        DateTime.now().difference(startTime).inMilliseconds,
        extra: {
          "error": e.toString(),
          "walletAddress": _walletAddress,
          "vestingAddress": EXITING_VESTING_ADDRESS,
        },
      );

      _existingVestingAddress = null;
      _existingVestingStatus = null;
      notifyListeners();
    }
  }

  Future<void> releaseECM(BuildContext context) async {
     _isLoading = true;
    notifyListeners();
    final start = DateTime.now();
    print('releaseECM:Function started, starting at $start');

    try {
      // 1. Load ABI and create DeployedContract instance
      final abiString = await rootBundle.loadString("assets/abi/ExitingVestingABI.json");
      final abiData = jsonDecode(abiString);
      final vestingContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abiData), 'ECMcoinVesting'),
        EthereumAddress.fromHex(EXITING_VESTING_ADDRESS),
      );
      print('releaseECM: Contract initialized with address $EXITING_VESTING_ADDRESS');

      // 2. Get chain and wallet details
      final chainId = getChainIdForRequests();
      if (chainId == null) {
        print('releaseECM: Chain ID not available');
        throw Exception("Selected chain not available.");
      }
      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
      final walletAddress = appKitModal!.session!.getAddress(nameSpace);
      if (walletAddress == null) {
        print('releaseECM: Wallet address not found');
        throw Exception("Wallet address not found.");
      }
      // 3. Compute vestingId
      final vestingIdFunction = vestingContract.function('computeVestingScheduleIdForAddressAndIndex');
      final vestingIdResult = await _web3Client!.call(
        contract: vestingContract,
        function: vestingIdFunction,
        params: [EthereumAddress.fromHex(walletAddress), BigInt.zero],
      );
      final vestingIdBytes = vestingIdResult[0] as Uint8List;

      // 4. Compute releasable amount
      final releasableFunction = vestingContract.function('computeReleasableAmount');
      final releasableBnResult = await _web3Client!.call(
        contract: vestingContract,
        function: releasableFunction,
        params: [vestingIdBytes],
      );
      print('releaseECM: Raw releasableBnResult = $releasableBnResult');
      final releasableBn = releasableBnResult[0] as BigInt;
      final releasable = EtherAmount.fromBigInt(EtherUnit.wei, releasableBn).getValueInUnit(EtherUnit.ether).toDouble();
      print('releaseECM: Releasable amount in ether = $releasable');


      // 6. Request the release transaction
      print('releaseECM: Attempting to release ECM...');
       final txResult = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainId,
        deployedContract: vestingContract,
        functionName: 'release',
        transaction: Transaction(from: EthereumAddress.fromHex(walletAddress)),
        parameters: [vestingIdBytes, releasableBn],
      );
      print('releaseECM: Transaction submitted, txResult = $txResult');

      // 7. Log the transaction
      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "release",
        _existingVestingAddress!,
        true,
        DateTime.now().difference(start).inMilliseconds,
        transactionHash: txResult,
        extra: {
          "walletAddress": walletAddress,
          "vestingAddress": _existingVestingAddress!,
          "amount": releasable.toString(),
        },
      );

      print('releaseECM: Transaction logged, hash: $txResult');

      const payloadApi = API_ENDPOINT;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

    // 8. API call to log claim history
      final payload = {
        "amount": releasable.toString(),
        "wallet_address": walletAddress,
        "hash": txResult,
        "type": "Exiting_Vesting",
      };

      final response = await http.post(
        Uri.parse('$payloadApi/vesting-claim'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': token != null && token.isNotEmpty ? 'Bearer $token' : '',

        },
        body: jsonEncode(payload),
      );

       print("releaseECM response.body ${response.body}");
      print("releaseECM payload ${payload}");
      if (response.statusCode == 200) {
        print('releaseECM: Claim history logged successfully');

      } else {
        print('releaseECM: Failed to log claim history: ${response.body}');
      }

      ToastMessage.show(
        message: "Your ECM tokens have been released successfully.",
        subtitle: "Transaction hash: $txResult.",
        type: MessageType.success,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

      // 9. Refresh vesting data
      await getExistingVestingInformation();
      print('releaseECM: Vesting data refreshed');
    } catch (e, stackTrace) {
      print('releaseECM: Error occurred - $e\nStackTrace: $stackTrace');
      await logRocketTrackBlockChainEvent(
        "TRANSACTION",
        "release",
        _existingVestingAddress ?? "unknown",
        false,
        DateTime.now().difference(start).inMilliseconds,
        extra: {
          "error": e.toString(),
          "stackTrace": stackTrace.toString(),
          "walletAddress": _walletAddress,
          "vestingAddress": _existingVestingAddress ?? "none",
        },
      );
      print('Error during releaseECM: $e');

      final errorMessage = e.toString().contains("User rejected")
          ? "Transaction rejected by user."
          : e.toString().contains("No ECM available")
          ? "No ECM available for release."
          : "Release failed. Please try again.";

      ToastMessage.show(
        message: "Release Failed",
        subtitle: errorMessage,
        type: MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
      print('releaseECM: Loading set to false, completed at ${DateTime.now()}');
    }
  }


  double get existingVestedAmount {
    if (existingVestInfo.start == 0 || existingVestInfo.end == 0 || balance == null) return 0.0;

    final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000; // ~1757925560
    final start = existingVestInfo.start;
    final end = existingVestInfo.end;
    final duration = existingVestInfo.duration;

    final totalVestingECM = double.tryParse(
      existingVestingStatus != null
          ? existingVestInfo.totalVestingAmount?.toString() ?? '0.0'
          : formatBalance(balance!),
    ) ?? 0.0;

     if (nowSec <= start!) {
       return 0.0;
    }
    if (nowSec >= end!) {
      return totalVestingECM;
    }

    final elapsed = nowSec - start;
    final calculatedAmount = (totalVestingECM * elapsed) / duration!;
     return double.parse(calculatedAmount.toStringAsFixed(6));
  }

  // Getter to calculate the amount of ECM available for claim
  double get availableClaimableAmountForExistingUser {
    final vested = existingVestedAmount; // Ensure type safety
    final released = existingVestInfo.released ?? 0.0; // Handle null with default 0.0
    final available = vested - released;
    debugPrint('availableClaimableAmountForExistingUser: vested=$vested, released=$released, available=$available');
    return available > 0 ? available : 0.0;
  }

  ///Helper Function to wait transaction to be mined.
  Future<TransactionReceipt?> _waitForTransaction(String txHash)async{
    const pollInterval = Duration(seconds: 3);
    const timeout = Duration(minutes: 3);
    final expiry = DateTime.now().add(timeout);
    final start = DateTime.now();

    while (DateTime.now().isBefore(expiry)){
      try{
        final receipt = await _web3Client!.getTransactionReceipt(txHash);
        if(receipt != null){

          await logRocketTrackBlockChainEvent(
            "TRANSACTION_CONFIRMATION",
            "waitForTransaction",
            "",
            true,
            DateTime.now().difference(start).inMilliseconds,
            transactionHash: txHash,
            extra: {
              "walletAddress": _walletAddress,
              "status": receipt.status.toString(),
            },
          );

          if (receipt.status == true){
            print("Transaction successful: $txHash");
            return receipt;
          }else{
            print("Transaction reverted by EVM: $txHash");
            throw Exception("Transaction failed. Please check the block explorer for details.");
          }
        }
      } catch (e, stackTrace) {
        await logRocketTrackBlockChainEvent(
          "TRANSACTION_CONFIRMATION",
          "waitForTransaction",
          "",
          false,
          DateTime.now().difference(start).inMilliseconds,
          extra: {
            "error": e.toString(),
            "walletAddress": _walletAddress,
            "transactionHash": txHash,
          },
        );
       }
      await Future.delayed(pollInterval);
    }
    await logRocketTrackBlockChainEvent(
      "TRANSACTION_CONFIRMATION",
      "waitForTransaction",
      "",
      false,
      DateTime.now().difference(start).inMilliseconds,
      extra: {
        "error": "Transaction timed out",
        "walletAddress": _walletAddress,
        "transactionHash": txHash,
      },
    );
    throw Exception("Transaction timed out. Could not confirm transaction status.");
  }

  Future<bool> _waitForConnection({Duration timeout = const Duration(seconds: 3)}) async {
    final start = DateTime.now();
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      if (_isConnected && _walletAddress.isNotEmpty) {
        await logRocketTrackBlockChainEvent(
          "WALLET_ACTION",
          "waitForConnection",
          "",
          true,
          DateTime.now().difference(start).inMilliseconds,
          extra: {
            "walletAddress": _walletAddress,
          },
        );

        return true;
      };
      final s = appKitModal?.session;
      if (s != null) {
        String? address;
        final selected = appKitModal?.selectedChain?.chainId;
        if (selected != null) {
          final ns = ReownAppKitModalNetworks.getNamespaceForChainId(selected);
          address = s.getAddress(ns);
        }
        address ??= _getFirstAddressFromSession();
        if (address != null) {
          _walletAddress = address;
          _isConnected = true;

          await logRocketTrackBlockChainEvent(
            "WALLET_ACTION",
            "waitForConnection",
            "",
            true,
            DateTime.now().difference(start).inMilliseconds,
            extra: {
              "walletAddress": _walletAddress,
            },
          );

          notifyListeners();
          return true;
        }
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }

    await logRocketTrackBlockChainEvent(
      "WALLET_ACTION",
      "waitForConnection",
      "",
      false,
      DateTime.now().difference(start).inMilliseconds,
      extra: {
        "error": "Connection timed out",
        "walletAddress": _walletAddress.isEmpty ? "none" : _walletAddress,
      },
    );

    return false;
  }


}

class _LifecycleHandler extends WidgetsBindingObserver {
  final Future<void> Function() onResume;
  final Future<void> Function() onPause;
  final Future<void> Function() onDetached;

  _LifecycleHandler({required this.onPause,required this.onDetached, required this.onResume});


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.paused:

        onPause();
        break;
      case AppLifecycleState.detached:

        onDetached();
        break;
      default:
        break;
    }
  }
}

extension AppKitModalContextFix on ReownAppKitModal {
  void updateContext(BuildContext context) {
    try {
      (this as dynamic).context = context;
    } catch (e) {
      debugPrint("updateContext failed: $e");
    }
  }
}

