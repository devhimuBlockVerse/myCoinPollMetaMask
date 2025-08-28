import 'dart:async';
import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:http/http.dart';
import 'package:http/http.dart' as http;
 import 'package:reown_appkit/reown_appkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/crypto.dart';
import '../../../framework/utils/customToastMessage.dart';
import '../../../framework/utils/enums/toast_type.dart';
 import '../../domain/constants/api_constants.dart';
import 'dart:typed_data';

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
    "rpc error:.*4001", // standard Ethereum user rejection
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
// const String API_ENDPOINT = 'https://app.mycoinpoll.com/api/v1';

// class WalletViewModel extends ChangeNotifier with WidgetsBindingObserver{
//
//   void setupLifecycleObserver() {
//     WidgetsBinding.instance.addObserver(_LifecycleHandler(onResume: _handleAppResume));
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
//    static const String ALCHEMY_URL_V2 = "https://eth-sepolia.g.alchemy.com/v2/Z-5ts6Ke8ik_CZOD9mNqzh-iekLYPySe";
//
//    static const String SALE_CONTRACT_ADDRESS = '0x732c5dFF0db1070d214F72Fc6056CF8B48692506';
//
//    static const String ECM_TOKEN_CONTRACT_ADDRESS = '0x4C324169890F42c905f3b8f740DBBe7C4E5e55C0';
//   static const String STAKING_CONTRACT_ADDRESS = '0x0Bce6B3f0412c6650157DC0De959bf548F063833'; /// getMinimunStake , maximumStake
//
//   static const String STAKING_CONTRACT_ADDRESSV2 = '0x878323894bE6c7E019dBA7f062e003889C812715'; /// statke , unstake
//
//   static const String AGGREGATO_RADDRESS = '0x694AA1769357215DE4FAC081bf1f309aDC325306';
//
//   static const double ECM_PRICE_USD = 1.2;
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
//   );
//
// // Getters for the new properties
//   String? get vestingAddress => _vestingAddress;
//   String? get vestingStatus => _vestingStatus;
//
//   @override
//   void dispose() {
//     _web3Client?.dispose();
//     WidgetsBinding.instance.removeObserver(this);
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
//       if (appKitModal == null || _lastContext != context) {
//         _lastContext = context;
//         appKitModal = ReownAppKitModal(
//
//           context: context,
//           projectId: 'f3d7c5a3be3446568bcc6bcc1fcc6389',
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
//       }else if (_lastContext != context){
//         _lastContext = context;
//         appKitModal!.updateContext(context);
//       }
//
//       if (!_isModalEventsSubscribed) {
//         final prefs = await SharedPreferences.getInstance();
//         _subscribeToModalEvents(prefs);
//         _isModalEventsSubscribed = true;
//       }
//       await _hydrateFromExistingSession();
//     }catch(_){
//       await fetchLatestETHPrice();
//     }finally{
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> ensureModalWithValidContext(BuildContext context) async {
//     final hasMaterial = Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) != null;
//
//     if (appKitModal == null) {
//       _lastContext = context;
//       await init(context);
//       return;
//     }
//
//     if (_lastContext != context || !_modalHasMaterialContext || !hasMaterial) {
//       await _recreateModalWithContext(context);
//       return;
//     }
//
//     if (_lastContext != context) {
//       _lastContext = context;
//       appKitModal!.updateContext(context);
//
//     }
//
//   }
//
//   Future<void> _recreateModalWithContext(BuildContext context) async {
//     appKitModal?.onModalConnect.unsubscribeAll();
//     appKitModal?.onModalUpdate.unsubscribeAll();
//     appKitModal?.onModalDisconnect.unsubscribeAll();
//     appKitModal?.onSessionExpireEvent.unsubscribeAll();
//     appKitModal?.onSessionUpdateEvent.unsubscribeAll();
//     appKitModal = null;
//     _isModalEventsSubscribed = false;
//     _modalHasMaterialContext = false;
//     _lastContext = context;
//     await init(context);
//   }
//
//   void _subscribeToModalEvents(SharedPreferences prefs) {
//     appKitModal!.onModalConnect.unsubscribeAll();
//     appKitModal!.onModalUpdate.unsubscribeAll();
//     appKitModal!.onModalDisconnect.unsubscribeAll();
//     appKitModal!.onSessionExpireEvent.unsubscribeAll();
//     appKitModal!.onSessionUpdateEvent.unsubscribeAll();
//
//
//     appKitModal!.onModalConnect.subscribe((_) async {
//       _isConnected = true;
//
//       _lastKnowChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
//       if (_lastKnowChainId != null) {
//         await prefs.setString('chainId', _lastKnowChainId!);
//       }
//
//       final address = _getFirstAddressFromSession();
//       if (address != null) {
//         _walletAddress = address;
//         await prefs.setBool('isConnected', true);
//         await prefs.setString('walletAddress', _walletAddress);
//         final sessionJson = appKitModal!.session?.toJson();
//         if (sessionJson != null) {
//           await prefs.setString('walletSession', jsonEncode(sessionJson));
//         }
//       }
//
//       await Future.wait([
//         fetchConnectedWalletData(),
//         fetchLatestETHPrice(),
//       ]);
//
//       notifyListeners();
//     });
//
//     appKitModal!.onModalUpdate.subscribe((_) async {
//       _lastKnowChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
//       if (_lastKnowChainId != null) {
//         await prefs.setString('chainId', _lastKnowChainId!);
//       }
//       final updatedAddress = _getFirstAddressFromSession();
//       if (updatedAddress != null && updatedAddress != _walletAddress) {
//         _walletAddress = updatedAddress;
//         await fetchConnectedWalletData();
//       }
//       _isConnected = true;
//       await fetchLatestETHPrice();
//       notifyListeners();
//     });
//
//
//     appKitModal!.onModalDisconnect.subscribe((_) async {
//        final prevAddress = _walletAddress;
//       if (prevAddress.isNotEmpty) {
//         await prefs.remove('web3_sig_$prevAddress');
//         await prefs.remove('web3_msg_$prevAddress');
//       }
//
//       _lastKnowChainId = null;
//       _isConnected = false;
//       _walletAddress = '';
//       await _removePersistedConnection();
//       await _clearWalletAndStageInfo();
//       await fetchLatestETHPrice();
//     });
//
//     appKitModal!.onSessionExpireEvent.subscribe((_) async {
//       _lastKnowChainId =null;
//       _isConnected = false;
//       _walletAddress = '';
//       await _removePersistedConnection();
//       await _clearWalletAndStageInfo();
//       await fetchLatestETHPrice();
//     });
//
//     appKitModal!.onSessionUpdateEvent.subscribe((_) async {
//       _lastKnowChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
//       if (_lastKnowChainId != null) {
//         await prefs.setString('chainId', _lastKnowChainId!);
//       }
//       final addr = _getFirstAddressFromSession();
//       if (addr != null && addr != _walletAddress) {
//         _walletAddress = addr;
//         await fetchConnectedWalletData();
//       }
//       _isConnected = true;
//       await fetchLatestETHPrice();
//       notifyListeners();
//     });
//
//
//   }
//
//   /// Connect the wallet using the ReownAppKitModal UI.
//   Future<bool> connectWallet(BuildContext context) async {
//     if (_isLoading) return false;
//     _walletConnectedManually = true;
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       await ensureModalWithValidContext(context);
//
//       try {
//         await appKitModal!.openModalView();
//       } catch (e) {
//         debugPrint("First attempt failed: $e");
//         await _recreateModalWithContext(context);
//
//         try {
//           await appKitModal!.openModalView();
//         } catch (e2) {
//
//           // Detect wallet app killed / modal closed
//           final errorMsg = e2.toString().toLowerCase();
//           if (errorMsg.contains("user rejected") ||
//               errorMsg.contains("user denied") ||
//               errorMsg.contains("user canceled") ||
//               errorMsg.contains("user cancelled") ||
//               errorMsg.contains("modal closed") ||
//               errorMsg.contains("wallet modal closed") ||
//               errorMsg.contains("no response from user")) {
//             ToastMessage.show(
//               message: "User Rejected",
//               subtitle: "You cancelled the connection.",
//               type: MessageType.info,
//               duration: CustomToastLength.LONG,
//               gravity: CustomToastGravity.BOTTOM,
//             );
//             return false;
//           } else {
//             ToastMessage.show(
//               message: "Wallet Connection Interrupted",
//               subtitle: "The wallet app was closed or session lost. Please connect.",
//               type: MessageType.info,
//               duration: CustomToastLength.LONG,
//               gravity: CustomToastGravity.BOTTOM,
//             );
//             return false;
//           }
//         }
//       }
//
//       // Wait until a session and address are available
//       final connected = await _waitForConnection(timeout: const Duration(seconds: 5));
//       if (!connected) {
//         ToastMessage.show(
//           message: "Wallet Connection Timeout",
//           subtitle: "Could not detect wallet session. Please try again.",
//           type: MessageType.info,
//           duration: CustomToastLength.LONG,
//           gravity: CustomToastGravity.BOTTOM,
//         );
//         return false;
//       }
//
//       // Persist and hydrate
//       final prefs = await SharedPreferences.getInstance();
//       final chainId = _getChainIdForRequests();
//       if (chainId != null) await prefs.setString('chainId', chainId);
//
//       await prefs.setBool('isConnected', true);
//       await prefs.setString('walletAddress', _walletAddress);
//
//       final sessionJson = appKitModal!.session?.toJson();
//       if (sessionJson != null) {
//         await prefs.setString('walletSession', jsonEncode(sessionJson));
//       }
//
//       await fetchConnectedWalletData(isReconnecting: true);
//
//       notifyListeners();
//       return true;
//     } catch (e, stack) {
//       debugPrint('connectWallet error: $e\n$stack');
//
//       final isUserRejected = isUserRejectedError(e);
//
//       ToastMessage.show(
//         message: isUserRejected ? "User Rejected" : "Connection Failed",
//         subtitle: isUserRejected
//             ? "You cancelled the connection."
//             : "Could not complete the connection request. Please try again.",
//         type: isUserRejected ? MessageType.info : MessageType.error,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// Disconnect from the wallet and clear stored wallet info.
//   Future<void> disconnectWallet(BuildContext context) async {
//     if (appKitModal == null) return;
//     _isLoading = true;
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
//     } catch (e) {
//       print("Error during disconnect: $e");
//     } finally {
//
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> rehydrate() async {
//     await _hydrateFromExistingSession();
//   }
//   ///LifeCycle Functions
//
//   // Future<void> _handleAppResume() async {
//   //   if (appKitModal == null) return;
//   //   try {
//   //     await _hydrateFromExistingSession();
//   //   } catch (e, stack) {
//   //     debugPrint("Resume error: $e\n$stack");
//   //
//   //   } finally {
//   //     notifyListeners();
//   //   }
//   // }
//   Future<void> _handleAppResume() async {
//     // Always check if the WalletViewModel is initialized before proceeding.
//     if (appKitModal == null) {
//       debugPrint("App resumed but appKitModal is null. Initializing...");
//       if (_lastContext != null) {
//         await init(_lastContext!);
//       }
//     }
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final isConnected = prefs.getBool('isConnected') ?? false;
//
//       if (isConnected) {
//         debugPrint("App resumed. A wallet session was previously active. Rehydrating...");
//          await _hydrateFromExistingSession();
//       } else {
//         debugPrint("App resumed. No active wallet session to rehydrate.");
//       }
//     } catch (e, stack) {
//       debugPrint("Resume error: $e\n$stack");
//     } finally {
//       notifyListeners();
//     }
//   }
//
//   /// NEw Changes
//   Future<void> _hydrateFromExistingSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     // var session = appKitModal!.session;
//     var session = appKitModal?.session;
//
//     // wait a bit for SDK to rehydrate after init
//     if (session == null) {
//       for (int i = 0; i < 15; i++) {
//         await Future.delayed(const Duration(milliseconds: 150));
//         session = appKitModal!.session;
//         if (session != null) break;
//       }
//     }
//
//     if (session != null) {
//       _isConnected = true;
//       String? chainId = appKitModal!.selectedChain!.chainId ?? _getChainIdFromSession();
//       if (chainId != null) {
//         _lastKnowChainId = chainId;
//         await prefs.setString('chainId', chainId);
//       }
//
//
//       final address = _getFirstAddressFromSession();
//
//       if (address != null) {
//         _walletAddress = address;
//         await prefs.setBool('isConnected', true);
//         await prefs.setString('walletAddress', _walletAddress);
//         await prefs.setString('walletSession', jsonEncode(session.toJson()));
//         await Future.wait([
//           fetchConnectedWalletData(isReconnecting: false),
//           fetchLatestETHPrice(),
//         ]);
//         return;
//       }else{
//         _isConnected = false;
//         await _removePersistedConnection();
//       }
//     }
//
//     await fetchLatestETHPrice();
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
//     } catch (_) {}
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
//     } catch (_) {}
//     return null;
//   }
//
//   String? _getChainIdForRequests() {
//     return appKitModal?.selectedChain?.chainId ?? _lastKnowChainId ?? _getChainIdFromSession();
//   }
//
//   Future<bool> _waitForConnection({Duration timeout = const Duration(seconds: 3)}) async {
//     final end = DateTime.now().add(timeout);
//     while (DateTime.now().isBefore(end)) {
//       if (_isConnected && _walletAddress.isNotEmpty) return true;
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
//           notifyListeners();
//           return true;
//         }
//       }
//       await Future.delayed(const Duration(milliseconds: 200));
//     }
//     return false;
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
//     final chainID = _getChainIdForRequests();
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
//
//       await Future.wait([
//         getBalance(),
//          getMinimunStake(),
//         getMaximumStake(),
//         getVestingInformation()
//       ]);
//     } catch (e) {
//       print('Error fetching connected wallet data: $e');
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
//         ContractAbi.fromJson(jsonEncode(abiData),
//             // 'eCommerce Coin'
//             'ECommerceCoin'
//
//         ),
//         EthereumAddress.fromHex(contractAddress),
//       );
//       final decimalsResult = await _web3Client!.call(
//         contract: contract,
//         function: contract.function('decimals'),
//         params: [],
//       );
//       return (decimalsResult[0] as BigInt).toInt();
//     } catch (e) {
//       print('Error getting token decimals: $e');
//       rethrow;
//     }
//   }
//
//   // Future<String> getBalance() async {
//   //
//   //
//   //   try {
//   //     final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//   //     final abiData = jsonDecode(abiString);
//   //
//   //     final tetherContract = DeployedContract(
//   //       ContractAbi.fromJson(
//   //         jsonEncode(abiData),
//   //         'eCommerce Coin',
//   //       ),
//   //       EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
//   //     );
//   //
//   //     final tokenDecimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS);
//   //     String addressToQuery = '';
//   //     final chainID = _getChainIdForRequests();
//   //
//   //
//   //     if (_isConnected && appKitModal != null && appKitModal!.session != null && chainID != null) {
//   //        final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//   //       addressToQuery = appKitModal!.session!.getAddress(nameSpace)!;
//   //     } else {
//   //       addressToQuery = '0x0000000000000000000000000000000000000000';
//   //
//   //     }
//   //     print("Querying balanceOf for vesting address: $_vestingAddress on token: $ECM_TOKEN_CONTRACT_ADDRESS");
//   //
//   //     final balanceOfResult = await _web3Client!.call(
//   //       contract: tetherContract,
//   //       function: tetherContract.function('balanceOf'),
//   //       params: [EthereumAddress.fromHex(addressToQuery)],
//   //     );
//   //     final balance = balanceOfResult[0] as BigInt;
//   //     final divisor = BigInt.from(10).pow(tokenDecimals);
//   //     _balance = (balance / divisor).toString();
//   //     print('balanceOf: ${balanceOfResult[0]}');
//   //
//   //     return '$_balance';
//   //   } catch (e) {
//   //     _balance = null;
//   //     print('Error getting balance: $e');
//   //     rethrow;
//   //   }
//   // }
//
//   Future<String> getBalance() async {
//      if (_web3Client == null) {
//       print("Web3Client not initialized for getBalance.");
//       _balance = null; // Or "0" depending on desired default/error display
//       notifyListeners();
//       throw Exception("Web3Client not initialized.");
//     }
//
//     if (_vestingAddress == null || _vestingAddress!.isEmpty) {
//       print("Vesting address is not available. Cannot fetch balance for vesting contract.");
//       _balance = "0";
//       notifyListeners();
//        return "0";
//     }
//
//     try {
//        final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
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
//        final decimalsResult = await _web3Client!.call(
//         contract: ecmTokenContract,
//         function: ecmTokenContract.function('decimals'),
//         params: [],
//       );
//       final int tokenDecimals = (decimalsResult[0] as BigInt).toInt();
//
//        print("Querying balanceOf for vesting address: $_vestingAddress on token: $ECM_TOKEN_CONTRACT_ADDRESS");
//       final balanceOfResult = await _web3Client!.call(
//         contract: ecmTokenContract,
//         function: ecmTokenContract.function('balanceOf'),
//          params: [EthereumAddress.fromHex(_vestingAddress!)],
//       );
//
//       final rawBalanceBigInt = balanceOfResult[0] as BigInt;
//       print('Raw token balance for vesting address $_vestingAddress: $rawBalanceBigInt');
//
//
//       if (tokenDecimals == 18) {
//         _balance = EtherAmount.fromBigInt(EtherUnit.wei, rawBalanceBigInt)
//             .getValueInUnit(EtherUnit.ether)
//             .toString();
//       } else {
//
//         final divisor = BigInt.from(10).pow(tokenDecimals);
//         final wholePart = rawBalanceBigInt ~/ divisor;
//         final fractionalPart = rawBalanceBigInt % divisor;
//         _balance = "$wholePart.${fractionalPart.toString().padLeft(tokenDecimals, '0')}";
//
//         _balance = _balance?.replaceAll(RegExp(r'\.0*$'), '')
//             .replaceAll(RegExp(r'(\.\d*?[1-9])0+$'), r'$1');
//       }
//
//
//       print('Formatted token balance for vesting address $_vestingAddress: $_balance');
//       notifyListeners();
//       return _balance ?? "0";
//
//     } catch (e, stack) {
//       _balance = null;
//       print('Error getting balance for vesting address: $e');
//       print(stack);
//       notifyListeners();
//       rethrow;
//     }
//   }
//   Future<String> getTotalSupply() async {
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final abiData = jsonDecode(abiString);
//       final tetherContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           // 'eCommerce Coin',
//           'ECommerceCoin',
//         ),
//         EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
//       );
//
//       final totalSupplyResult = await _web3Client!.call(
//         contract: tetherContract,
//         function: tetherContract.function('totalSupply'),
//         params: [],
//       );
//       final decimalsResult = await _web3Client!.call(
//         contract: tetherContract,
//         function: tetherContract.function('decimals'),
//         params: [],
//       );
//       final tokenDecimals = (decimalsResult[0] as BigInt).toInt();
//       final totalSupply = totalSupplyResult[0] as BigInt;
//       final divisor = BigInt.from(10).pow(tokenDecimals);
//       final formattedTotalSupply = totalSupply / divisor;
//       return '$formattedTotalSupply';
//     } catch (e) {
//       print('Error getting total supply: $e');
//       rethrow;
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
//         EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESS),
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
//     } catch (e) {
//       print('Error getting minimum stake: $e');
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
//         EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESS),
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
//     } catch (e) {
//       print('Error getting Maximum stake: $e');
//       _maximumStake = null;
//       rethrow;
//     }
//   }
//
//   Future<String> transferToken(String recipientAddress, double amount) async {
//     final chainID = _getChainIdForRequests();
//
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null || chainID == null) {
//       ToastMessage.show(
//         message: "Wallet Error",
//         subtitle: "Wallet not connected or chain not selected.",
//         type: MessageType.error,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//       throw Exception("Wallet not Connected or selected chain not available.");
//     }
//     _isLoading = true;
//     notifyListeners();
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final abiData = jsonDecode(abiString);
//       final tetherContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           // 'eCommerce Coin',
//           'ECommerceCoin',
//         ),
//         EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
//       );
//       final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//
//
//       final decimalsResult = await appKitModal!.requestReadContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: tetherContract,
//         functionName: 'decimals',
//       );
//       final decimalUnits = (decimalsResult.first as BigInt);
//       final transferValue = _formatValue(amount, decimals: decimalUnits);
//
//       final metaMaskUrl = Uri.parse(
//         'metamask://dapp/exampleapp',
//       );
//       await launchUrl(metaMaskUrl, mode: LaunchMode.externalApplication);
//
//       final result = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: tetherContract,
//         functionName: 'transfer',
//         transaction: Transaction(
//             from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!)),
//         parameters: [
//           EthereumAddress.fromHex(recipientAddress),
//           transferValue,
//         ],
//       );
//       print('Transfer Result: $result');
//
//       ToastMessage.show(
//         message: "Transaction Sent",
//         subtitle: "Token transfer initiated successfully!",
//         type: MessageType.success,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//
//       await fetchConnectedWalletData();
//       // await getCurrentStageInfo();
//
//
//       return result;
//     } catch (e) {
//       print('Error Sending transferToken: $e');
//
//       ToastMessage.show(
//         message: "Transfer Failed",
//         subtitle: "Something went wrong: ${e.toString()}",
//         type: MessageType.info,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<String> fetchLatestETHPrice({bool forceLoad = false}) async {
//     const cacheDurationMs = 3 * 60 * 1000; // 3 minutes
//     final prefs = await SharedPreferences.getInstance();
//     final lastUpdated = prefs.getInt('ethPriceLastUpdated') ?? 0;
//     final cachedPrice = prefs.getString('ethPriceUSD');
//
//     if (!forceLoad && cachedPrice != null && DateTime.now().millisecondsSinceEpoch - lastUpdated < cacheDurationMs) {
//       _ethPrice = double.parse(cachedPrice);
//       notifyListeners();
//       return cachedPrice;
//     }
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
//       final rawPrice = result[0] as BigInt;
//       print('RAW_PRICE : $rawPrice');
//
//
//       final ethUsdPrice = rawPrice.toDouble() / 1e8;
//       final ethPerEcm = ECM_PRICE_USD / ethUsdPrice;
//        final price = ethPerEcm.toStringAsFixed(8);
//
//       print('RAW_PRICE 8 Decimal: $price');
//
//       await prefs.setString('ethPriceUSD', price);
//       await prefs.setInt('ethPriceLastUpdated', DateTime.now().millisecondsSinceEpoch);
//       _ethPrice = double.parse(price);
//       notifyListeners();
//       return price;
//     } catch (e) {
//       print('Error fetching ETH price: $e');
//       if (cachedPrice != null) return cachedPrice;
//       throw Exception('Failed to fetch ETH price');
//     }
//   }
//
//   Future<String?> buyECMWithETH({
//     required EtherAmount ethAmount,
//     required EthereumAddress referralAddress,
//     required BuildContext context
//   }) async {
//     final chainID = _getChainIdForRequests();
//     print("buyECMWithETH Chaid Id ${chainID}");
//
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null || chainID == null) {
//       throw Exception("Wallet not Connected or selected chain not available.");
//     }
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//        final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//       final walletAddress = EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!);
//       final ethBalance = await _web3Client!.getBalance(walletAddress);
//
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
//       // wait for the transaction  confirmation
//       //  final receipt = await _web3Client!.getTransactionReceipt(result);
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
//
//       // Send Payload to API
//        await _sendPurchaseDataToApi(payload);
//
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
//     } catch (e) {
//       print("Error buying ECM with ETH: $e");
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
//       } catch (e) {
//         print('Error decoding ECMPurchased log: $e');
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
//       } catch (_) {}
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
//     final chainID = _getChainIdForRequests();
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
//               // 'eCommerce Coin'
//               'ECommerceCoin'
//           ),
//           EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS));
//
//       final stakingContract = DeployedContract(
//           ContractAbi.fromJson(jsonEncode(jsonDecode(stakingAbiString)), 'eCommerce Coin'),
//           EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSV2));
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
//
//
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
//       print(">> Requesting approval transaction...");
//       final dynamic approveTxResult = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: ecmTokenContract,
//         functionName: 'approve',
//         transaction: Transaction(from: EthereumAddress.fromHex(_walletAddress)),
//         parameters: [
//           EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSV2),
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
//       print(">> Approval confirmed.");
//
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
//
//       print('>> Preparing stake transaction...');
//       print('>>  stakeAmount: $stakeAmount');
//       print('>>  planIndex: ${BigInt.from(planIndex)}');
//       print('>>  referrerAddress: $referrerAddress');
//
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
//
//
//       final stakeReceipt = await _waitForTransaction(stakeTxHash);
//
//       if (stakeReceipt == null) {
//         throw Exception("Stake transaction failed or timed out.");
//       }
//       print(">> Stake transaction confirmed.");
//
//       /// Post-Transaction & Event Parsing
//       final stakeEvent = stakingContract.event('Staked');
//       print(">> Parsing logs for 'Staked' event...");
//
//       bool successShown = false;
//
//       final stakeEventSignatureHex = bytesToHex(stakeEvent.signature);
//
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
//               print(">> Payload prepared for backend: $payload");
//
//
//
//               final apiUrl = '${ApiConstants.baseUrl}/staking-created';
//
//               print(">> Sending POST request to: $apiUrl");
//
//
//               final prefs = await SharedPreferences.getInstance();
//               final token = prefs.getString('token');
//
//               try {
//
//                 final response = await http.post(
//                   Uri.parse(apiUrl),
//                   headers: {
//                     'Content-Type': 'application/json',
//                     'Accept': 'application/json',
//                     if (token != null) 'Authorization': 'Bearer $token',
//                   },
//                   body: jsonEncode(payload),
//                 );
//                 print(">> Response status: ${response.statusCode}");
//                 print(">> Response body: ${response.body}");
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
//         } catch (e) {
//           print(">> Error decoding log: $e");
//         }
//       }
//
//       if (!successShown) {
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
//     } catch (e) {
//       debugPrint("Staking failed: $e");
//
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
//
//   Future<String?> forceUnstake(int stakeId)async{
//     final chainID = _getChainIdForRequests();
//
//     if (!_isConnected || appKitModal?.session == null || chainID == null) {
//       ToastMessage.show(message: "Connect wallet first.", type: MessageType.error);
//       return null;
//     }
//     _isLoading = true;
//     notifyListeners();
//
//
//     try{
//       // final chainID = appKitModal!.selectedChain!.chainId;
//
//       final stakingAbiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//       final stakingContract = DeployedContract(
//         ContractAbi.fromJson(stakingAbiString, 'eCommerce Coin'),
//         EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSV2),
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
//       /// Parse logs for Unstaked and ReferralCommissionPaid events
//       final unstakedEvent = stakingContract.event('Unstaked');
//       final referralEvent = stakingContract.event('ReferralCommissionPaid');
//
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
//         }catch(e){
//           print("Error decoding log: $e");
//         }
//       }
//
//
//       await fetchConnectedWalletData();
//       await getBalance();
//       ToastMessage.show(message: "Force unstake successful!", type: MessageType.success);
//       return txHash;
//     }catch(e){
//       final isUserRejected = isUserRejectedError(e);
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
//     final chainID = _getChainIdForRequests();
//
//     if (!_isConnected || appKitModal?.session == null || chainID == null) {
//       ToastMessage.show(message: "Connect wallet first.", type: MessageType.error);
//       return null;
//     }
//
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//
//       final stakingAbiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//       final stakingContract = DeployedContract(
//         ContractAbi.fromJson(stakingAbiString, 'eCommerce Coin'),
//         EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSV2),
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
//         } catch (e) {
//           print("Error decoding log: $e");
//         }
//       }
//
//       await fetchConnectedWalletData();
//       await getBalance();
//
//       ToastMessage.show(message: "Unstake successful!", type: MessageType.success);
//       return txHash;
//     } catch (e) {
//       final isUserRejected = isUserRejectedError(e);
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
//     if (!_isConnected || _walletAddress.isEmpty) return;
//
//     // _isLoading = true;
//     notifyListeners();
//
//     try {
//       final chainId = _getChainIdForRequests();
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
//       final walletAddressHex = appKitModal!.session!.getAddress(nameSpace);
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
//       if (vestingContractAddress == zeroAddress) {
//         // No vesting contract for user
//         _vestingAddress = null;
//         _vestingStatus = null;
//       } else {
//         _vestingAddress = vestingContractAddress.hex;
//         await _resolveVestedStart(vestingContractAddress);
//       }
//     } catch (e, stack) {
//       print('Error getting vesting information: $e --- $stack');
//       _vestingAddress = null;
//       _vestingStatus = null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> _resolveVestedStart(EthereumAddress vestingContractAddress) async {
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
//       final start = (startResult[0] as BigInt).toInt();
//       final cliff = (cliffResult[0] as BigInt).toInt();
//       final duration = (durationResult[0] as BigInt).toInt();
//       final released = (releasedResult[0] as BigInt);
//       final claimable = (claimableResult[0] as BigInt);
//
//
//       print("start: $start");
//       print("cliff: $cliff");
//       print("duration: $duration");
//       print("released: $released");
//       print("claimable: $claimable");
//
//       vestInfo.start = start;
//       vestInfo.cliff = cliff;
//       vestInfo.duration = duration;
//       vestInfo.released = released .toDouble();
//       vestInfo.claimable = claimable.toDouble();
//       vestInfo.end = start + duration;
//       _vestingStatus = start > now ? 'locked' : 'process';
//
//       notifyListeners();
//
//     } catch (e, stackTrace) {
//         print("Stack Trace: $stackTrace");
//       _vestingStatus = null;
//       notifyListeners();
//     }
//   }
//
//   ///Helper Function to wait transaction to be mined.
//   Future<TransactionReceipt?> _waitForTransaction(String txHash)async{
//     const pollInterval = Duration(seconds: 3);
//     const timeout = Duration(minutes: 3);
//     final expiry = DateTime.now().add(timeout);
//
//     while (DateTime.now().isBefore(expiry)){
//       try{
//         final receipt = await _web3Client!.getTransactionReceipt(txHash);
//         if(receipt != null){
//           if (receipt.status == true){
//             print("Transaction successful: $txHash");
//             return receipt;
//           }else{
//             print("Transaction reverted by EVM: $txHash");
//             throw Exception("Transaction failed. Please check the block explorer for details.");
//           }
//         }
//       }catch(e){
//         debugPrint("_waitForTransaction :$e");
//       }
//       await Future.delayed(pollInterval);
//     }
//     throw Exception("Transaction timed out. Could not confirm transaction status.");
//   }
//
//   /// Mock function to format decimal value to token unit (BigInt)
//   BigInt _formatValue(double amount, {required BigInt decimals}) {
//     final decimalPlaces = decimals.toInt(); // e.g., 6 for USDT, 18 for ETH
//     final factor = BigInt.from(10).pow(decimalPlaces);
//     return BigInt.from(amount * factor.toDouble());
//   }
//
// }
class WalletViewModel extends ChangeNotifier with WidgetsBindingObserver{

  void setupLifecycleObserver() {
    WidgetsBinding.instance.addObserver(_LifecycleHandler(onResume: _handleAppResume));
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



  static const String ALCHEMY_URL_V2 = "https://eth-sepolia.g.alchemy.com/v2/Z-5ts6Ke8ik_CZOD9mNqzh-iekLYPySe";

   static const String SALE_CONTRACT_ADDRESS = '0x732c5dFF0db1070d214F72Fc6056CF8B48692506';

   static const String ECM_TOKEN_CONTRACT_ADDRESS = '0x4C324169890F42c905f3b8f740DBBe7C4E5e55C0';
  static const String STAKING_CONTRACT_ADDRESS = '0x0Bce6B3f0412c6650157DC0De959bf548F063833'; /// getMinimunStake , maximumStake

  static const String STAKING_CONTRACT_ADDRESSV2 = '0x878323894bE6c7E019dBA7f062e003889C812715'; /// statke , unstake

  static const String AGGREGATO_RADDRESS = '0x694AA1769357215DE4FAC081bf1f309aDC325306';

  static const double ECM_PRICE_USD = 1.2;

  static const String API_ENDPOINT = 'https://app.mycoinpoll.com/api/v1';


  Future<void> setAuthToken(String token) async {
    _authToken = token;
    notifyListeners();
  }


  WalletViewModel() {
    _web3Client = Web3Client(ALCHEMY_URL_V2, Client());
    WidgetsBinding.instance.addObserver(this);
  }

  String? _vestingAddress;
  String? _vestingStatus; // 'locked' | 'process' | null

  final VestingInfo vestInfo = VestingInfo(
    start: 0,
    cliff: 0,
    duration: 0,
    end: 0,
    released: 0.0,
    claimable: 0.0,
  );

// Getters for the new properties
  String? get vestingAddress => _vestingAddress;
  String? get vestingStatus => _vestingStatus;

  @override
  void dispose() {
    _vestingTimer?.cancel();
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
      if (appKitModal == null || _lastContext != context) {
        _lastContext = context;
        appKitModal = ReownAppKitModal(

          context: context,
          projectId: 'f3d7c5a3be3446568bcc6bcc1fcc6389',
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


      }else if (_lastContext != context){
        _lastContext = context;
        appKitModal!.updateContext(context);
      }

      if (!_isModalEventsSubscribed) {
        final prefs = await SharedPreferences.getInstance();
        _subscribeToModalEvents(prefs);
        _isModalEventsSubscribed = true;
      }
      await _hydrateFromExistingSession();
    }catch(_){
      await fetchLatestETHPrice();
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> ensureModalWithValidContext(BuildContext context) async {
    final hasMaterial = Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) != null;

    if (appKitModal == null) {
      _lastContext = context;
      await init(context);
      return;
    }

    if (_lastContext != context || !_modalHasMaterialContext || !hasMaterial) {
      await _recreateModalWithContext(context);
      return;
    }

    if (_lastContext != context) {
      _lastContext = context;
      appKitModal!.updateContext(context);

    }

  }

  Future<void> _recreateModalWithContext(BuildContext context) async {
    appKitModal?.onModalConnect.unsubscribeAll();
    appKitModal?.onModalUpdate.unsubscribeAll();
    appKitModal?.onModalDisconnect.unsubscribeAll();
    appKitModal?.onSessionExpireEvent.unsubscribeAll();
    appKitModal?.onSessionUpdateEvent.unsubscribeAll();
    appKitModal = null;
    _isModalEventsSubscribed = false;
    _modalHasMaterialContext = false;
    _lastContext = context;
    await init(context);
  }
  void _subscribeToModalEvents(SharedPreferences prefs) {
    appKitModal!.onModalConnect.unsubscribeAll();
    appKitModal!.onModalUpdate.unsubscribeAll();
    appKitModal!.onModalDisconnect.unsubscribeAll();
    appKitModal!.onSessionExpireEvent.unsubscribeAll();
    appKitModal!.onSessionUpdateEvent.unsubscribeAll();


    appKitModal!.onModalConnect.subscribe((_) async {
      _isConnected = true;

      _lastKnowChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
      if (_lastKnowChainId != null) {
        await prefs.setString('chainId', _lastKnowChainId!);
      }

      final address = _getFirstAddressFromSession();
      if (address != null) {
        _walletAddress = address;
        await prefs.setBool('isConnected', true);
        await prefs.setString('walletAddress', _walletAddress);
        final sessionJson = appKitModal!.session?.toJson();
        if (sessionJson != null) {
          await prefs.setString('walletSession', jsonEncode(sessionJson));
        }
      }

      await Future.wait([
        fetchConnectedWalletData(),
        fetchLatestETHPrice(),
      ]);

      notifyListeners();
    });

    appKitModal!.onModalUpdate.subscribe((_) async {
      _lastKnowChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
      if (_lastKnowChainId != null) {
        await prefs.setString('chainId', _lastKnowChainId!);
      }
      final updatedAddress = _getFirstAddressFromSession();
      if (updatedAddress != null && updatedAddress != _walletAddress) {
        _walletAddress = updatedAddress;
        await fetchConnectedWalletData();
      }
      _isConnected = true;
      await fetchLatestETHPrice();
      final sessionJson = appKitModal!.session?.toJson();
      if (sessionJson != null) {
        await prefs.setString('walletSession', jsonEncode(sessionJson));
      }
      notifyListeners();
    });


    appKitModal!.onModalDisconnect.subscribe((_) async {
       final prevAddress = _walletAddress;
      if (prevAddress.isNotEmpty) {
        await prefs.remove('web3_sig_$prevAddress');
        await prefs.remove('web3_msg_$prevAddress');
      }

      _lastKnowChainId = null;
      _isConnected = false;
      _walletAddress = '';
      await _removePersistedConnection();
      await _clearWalletAndStageInfo();
      await fetchLatestETHPrice();
    });

    appKitModal!.onSessionExpireEvent.subscribe((_) async {
      _lastKnowChainId =null;
      _isConnected = false;
      _walletAddress = '';
      await _removePersistedConnection();
      await _clearWalletAndStageInfo();
      await fetchLatestETHPrice();
    });

    appKitModal!.onSessionUpdateEvent.subscribe((_) async {
      _lastKnowChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
      if (_lastKnowChainId != null) {
        await prefs.setString('chainId', _lastKnowChainId!);
      }
      final addr = _getFirstAddressFromSession();
      if (addr != null && addr != _walletAddress) {
        _walletAddress = addr;
        await fetchConnectedWalletData();
      }
      _isConnected = true;
      await fetchLatestETHPrice();
      final sessionJson = appKitModal!.session?.toJson();
      if (sessionJson != null) {
        await prefs.setString('walletSession', jsonEncode(sessionJson));
      }
      notifyListeners();
    });


  }

  /// Connect the wallet using the ReownAppKitModal UI.
  Future<bool> connectWallet(BuildContext context) async {
    if (_isLoading) return false;
    _walletConnectedManually = true;
    _isLoading = true;
    notifyListeners();

    try {
      await ensureModalWithValidContext(context);

      try {
        await appKitModal!.openModalView();
      } catch (e) {
        debugPrint("First attempt failed: $e");
        await _recreateModalWithContext(context);

        try {
          await appKitModal!.openModalView();
        } catch (e2) {

          // Detect wallet app killed / modal closed
          final errorMsg = e2.toString().toLowerCase();
          if (errorMsg.contains("user rejected") ||
              errorMsg.contains("user denied") ||
              errorMsg.contains("user canceled") ||
              errorMsg.contains("user cancelled") ||
              errorMsg.contains("modal closed") ||
              errorMsg.contains("wallet modal closed") ||
              errorMsg.contains("no response from user")) {
            ToastMessage.show(
              message: "User Rejected",
              subtitle: "You cancelled the connection.",
              type: MessageType.info,
              duration: CustomToastLength.LONG,
              gravity: CustomToastGravity.BOTTOM,
            );
            return false;
          } else {
            ToastMessage.show(
              message: "Wallet Connection Interrupted",
              subtitle: "The wallet app was closed or session lost. Please connect.",
              type: MessageType.info,
              duration: CustomToastLength.LONG,
              gravity: CustomToastGravity.BOTTOM,
            );
            return false;
          }
        }
      }

      // Wait until a session and address are available
      final connected = await _waitForConnection(timeout: const Duration(seconds: 5));
      if (!connected) {
        ToastMessage.show(
          message: "Wallet Connection Timeout",
          subtitle: "Could not detect wallet session. Please try again.",
          type: MessageType.info,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );
        return false;
      }

      // Persist and hydrate
      final prefs = await SharedPreferences.getInstance();
      final chainId = _getChainIdForRequests();
      if (chainId != null) await prefs.setString('chainId', chainId);

      await prefs.setBool('isConnected', true);
      await prefs.setString('walletAddress', _walletAddress);

      final sessionJson = appKitModal!.session?.toJson();
      if (sessionJson != null) {
        await prefs.setString('walletSession', jsonEncode(sessionJson));
      }

      await fetchConnectedWalletData(isReconnecting: true);

      notifyListeners();
      return true;
    } catch (e, stack) {
      debugPrint('connectWallet error: $e\n$stack');

      final isUserRejected = isUserRejectedError(e);

      ToastMessage.show(
        message: isUserRejected ? "User Rejected" : "Connection Failed",
        subtitle: isUserRejected
            ? "You cancelled the connection."
            : "Could not complete the connection request. Please try again.",
        type: isUserRejected ? MessageType.info : MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
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
    } catch (e) {
      print("Error during disconnect: $e");
    } finally {

      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> rehydrate() async {
  //   await _hydrateFromExistingSession();
  // }

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
    // Always check if the WalletViewModel is initialized before proceeding.
    if (appKitModal == null) {
      debugPrint("App resumed but appKitModal is null. Initializing...");
      if (_lastContext != null) {
        await init(_lastContext!);
      }
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final isConnected = prefs.getBool('isConnected') ?? false;

      if (isConnected) {
        debugPrint("App resumed. A wallet session was previously active. Rehydrating...");
         await _hydrateFromExistingSession();
      } else {
        debugPrint("App resumed. No active wallet session to rehydrate.");
      }
    } catch (e, stack) {
      debugPrint("Resume error: $e\n$stack");
    } finally {
      notifyListeners();
    }
  }

  /// NEw Changes
  // Future<void> _hydrateFromExistingSession() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // var session = appKitModal!.session;
  //   var session = appKitModal?.session;
  //
  //   // wait a bit for SDK to rehydrate after init
  //   if (session == null) {
  //     for (int i = 0; i < 15; i++) {
  //       await Future.delayed(const Duration(milliseconds: 150));
  //       session = appKitModal!.session;
  //       if (session != null) break;
  //     }
  //   }
  //
  //   if (session != null) {
  //     _isConnected = true;
  //     String? chainId = appKitModal!.selectedChain!.chainId ?? _getChainIdFromSession();
  //     if (chainId != null) {
  //       _lastKnowChainId = chainId;
  //       await prefs.setString('chainId', chainId);
  //     }
  //
  //
  //     final address = _getFirstAddressFromSession();
  //
  //     if (address != null) {
  //       _walletAddress = address;
  //       await prefs.setBool('isConnected', true);
  //       await prefs.setString('walletAddress', _walletAddress);
  //       await prefs.setString('walletSession', jsonEncode(session.toJson()));
  //       await Future.wait([
  //         fetchConnectedWalletData(isReconnecting: false),
  //         fetchLatestETHPrice(),
  //       ]);
  //       return;
  //     }else{
  //       _isConnected = false;
  //       await _removePersistedConnection();
  //     }
  //   }
  //
  //   await fetchLatestETHPrice();
  // }

  /// V2
  Future<void> _hydrateFromExistingSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isConnectedFromPrefs = prefs.getBool('isConnected') ?? false;


      if (isConnectedFromPrefs) {
        await appKitModal!.init();

        if (appKitModal!.session != null) {
          _isConnected = true;

          final address = _getFirstAddressFromSession();
          if (address != null) {
            _walletAddress = address;
          } else {

            print('No address found in the restored session.');
            _isConnected = false;
            _walletAddress = '';
            await _removePersistedConnection();
            notifyListeners();
            return;
          }

          _lastKnowChainId = appKitModal!.selectedChain?.chainId ?? _getChainIdFromSession();
          print('Wallet session successfully restored from prefs.');

          await fetchConnectedWalletData(isReconnecting: true);


        } else {
          print('Failed to restore session. Clearing saved connection status.');
          await _removePersistedConnection();
        }
      } else {
        print('No wallet session found in storage.');
        await _removePersistedConnection();
      }
    } catch (e) {
      print('Error during session hydration: $e');
      await _removePersistedConnection();
    } finally {
      _isSessionSettling = false;
      notifyListeners();
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
    } catch (_) {}
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
    } catch (_) {}
    return null;
  }

  String? _getChainIdForRequests() {
    return appKitModal?.selectedChain?.chainId ?? _lastKnowChainId ?? _getChainIdFromSession();
  }

  Future<bool> _waitForConnection({Duration timeout = const Duration(seconds: 3)}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      if (_isConnected && _walletAddress.isNotEmpty) return true;
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
          notifyListeners();
          return true;
        }
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
    return false;
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

    final chainID = _getChainIdForRequests();
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

      await Future.wait([
        getBalance(),
         getMinimunStake(),
        getMaximumStake(),
        getVestingInformation()
      ]);

      _startVestingTimer();

    } catch (e) {
      print('Error fetching connected wallet data: $e');
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
        ContractAbi.fromJson(jsonEncode(abiData),
            // 'eCommerce Coin'
            'ECommerceCoin'

        ),
        EthereumAddress.fromHex(contractAddress),
      );
      final decimalsResult = await _web3Client!.call(
        contract: contract,
        function: contract.function('decimals'),
        params: [],
      );
      return (decimalsResult[0] as BigInt).toInt();
    } catch (e) {
      print('Error getting token decimals: $e');
      rethrow;
    }
  }

  Future<String> getBalance() async {
     if (_web3Client == null) {
      print("Web3Client not initialized for getBalance.");
      _balance = null; // Or "0" depending on desired default/error display
      notifyListeners();
      throw Exception("Web3Client not initialized.");
    }

    if (_vestingAddress == null || _vestingAddress!.isEmpty) {
      print("Vesting address is not available. Cannot fetch balance for vesting contract.");
      _balance = "0";
      notifyListeners();
       return "0";
    }

    try {
       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final abiData = jsonDecode(abiString);

      final ecmTokenContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'ECommerceCoin',
        ),
        EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
      );

       final decimalsResult = await _web3Client!.call(
        contract: ecmTokenContract,
        function: ecmTokenContract.function('decimals'),
        params: [],
      );
      final int tokenDecimals = (decimalsResult[0] as BigInt).toInt();

       print("Querying balanceOf for vesting address: $_vestingAddress on token: $ECM_TOKEN_CONTRACT_ADDRESS");
      final balanceOfResult = await _web3Client!.call(
        contract: ecmTokenContract,
        function: ecmTokenContract.function('balanceOf'),
         params: [EthereumAddress.fromHex(_vestingAddress!)],
      );

      final rawBalanceBigInt = balanceOfResult[0] as BigInt;
      print('Raw token balance for vesting address $_vestingAddress: $rawBalanceBigInt');


      if (tokenDecimals == 18) {
        _balance = EtherAmount.fromBigInt(EtherUnit.wei, rawBalanceBigInt)
            .getValueInUnit(EtherUnit.ether)
            .toString();
      } else {

        final divisor = BigInt.from(10).pow(tokenDecimals);
        final wholePart = rawBalanceBigInt ~/ divisor;
        final fractionalPart = rawBalanceBigInt % divisor;
        _balance = "$wholePart.${fractionalPart.toString().padLeft(tokenDecimals, '0')}";

        _balance = _balance?.replaceAll(RegExp(r'\.0*$'), '')
            .replaceAll(RegExp(r'(\.\d*?[1-9])0+$'), r'$1');
      }


      print('Formatted token balance for vesting address $_vestingAddress: $_balance');
      notifyListeners();
      return _balance ?? "0";

    } catch (e, stack) {
      _balance = null;
      print('Error getting balance for vesting address: $e');
      print(stack);
      notifyListeners();
      rethrow;
    }
  }

  Future<String> getTotalSupply() async {
    try {
      final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final abiData = jsonDecode(abiString);
      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          // 'eCommerce Coin',
          'ECommerceCoin',
        ),
        EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
      );

      final totalSupplyResult = await _web3Client!.call(
        contract: tetherContract,
        function: tetherContract.function('totalSupply'),
        params: [],
      );
      final decimalsResult = await _web3Client!.call(
        contract: tetherContract,
        function: tetherContract.function('decimals'),
        params: [],
      );
      final tokenDecimals = (decimalsResult[0] as BigInt).toInt();
      final totalSupply = totalSupplyResult[0] as BigInt;
      final divisor = BigInt.from(10).pow(tokenDecimals);
      final formattedTotalSupply = totalSupply / divisor;
      return '$formattedTotalSupply';
    } catch (e) {
      print('Error getting total supply: $e');
      rethrow;
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
        EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESS),
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
    } catch (e) {
      print('Error getting minimum stake: $e');
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
        EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESS),
      );

      final maximumStakeResult = await _web3Client!.call(
        contract: stakingContract,
        function: stakingContract.function('maximumStake'),
        params: [],
      );


      final max = (maximumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
      _maximumStake = max.toDouble().toStringAsFixed(0);
      return _maximumStake!;
    } catch (e) {
      print('Error getting Maximum stake: $e');
      _maximumStake = null;
      rethrow;
    }
  }

  Future<String> transferToken(String recipientAddress, double amount) async {
    final chainID = _getChainIdForRequests();

    if (appKitModal == null || !_isConnected || appKitModal!.session == null || chainID == null) {
      ToastMessage.show(
        message: "Wallet Error",
        subtitle: "Wallet not connected or chain not selected.",
        type: MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      throw Exception("Wallet not Connected or selected chain not available.");
    }
    _isLoading = true;
    notifyListeners();
    try {
      final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final abiData = jsonDecode(abiString);
      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          // 'eCommerce Coin',
          'ECommerceCoin',
        ),
        EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
      );
      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);


      final decimalsResult = await appKitModal!.requestReadContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: tetherContract,
        functionName: 'decimals',
      );
      final decimalUnits = (decimalsResult.first as BigInt);
      final transferValue = _formatValue(amount, decimals: decimalUnits);

      final metaMaskUrl = Uri.parse(
        'metamask://dapp/exampleapp',
      );
      await launchUrl(metaMaskUrl, mode: LaunchMode.externalApplication);

      final result = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: tetherContract,
        functionName: 'transfer',
        transaction: Transaction(
            from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!)),
        parameters: [
          EthereumAddress.fromHex(recipientAddress),
          transferValue,
        ],
      );
      print('Transfer Result: $result');

      ToastMessage.show(
        message: "Transaction Sent",
        subtitle: "Token transfer initiated successfully!",
        type: MessageType.success,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

      await fetchConnectedWalletData();
      // await getCurrentStageInfo();


      return result;
    } catch (e) {
      print('Error Sending transferToken: $e');

      ToastMessage.show(
        message: "Transfer Failed",
        subtitle: "Something went wrong: ${e.toString()}",
        type: MessageType.info,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> fetchLatestETHPrice({bool forceLoad = false}) async {
    const cacheDurationMs = 3 * 60 * 1000; // 3 minutes
    final prefs = await SharedPreferences.getInstance();
    final lastUpdated = prefs.getInt('ethPriceLastUpdated') ?? 0;
    final cachedPrice = prefs.getString('ethPriceUSD');

    if (!forceLoad && cachedPrice != null && DateTime.now().millisecondsSinceEpoch - lastUpdated < cacheDurationMs) {
      _ethPrice = double.parse(cachedPrice);
      notifyListeners();
      return cachedPrice;
    }
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

      final rawPrice = result[0] as BigInt;
      print('RAW_PRICE : $rawPrice');


      final ethUsdPrice = rawPrice.toDouble() / 1e8;
      final ethPerEcm = ECM_PRICE_USD / ethUsdPrice;
       final price = ethPerEcm.toStringAsFixed(8);

      print('RAW_PRICE 8 Decimal: $price');

      await prefs.setString('ethPriceUSD', price);
      await prefs.setInt('ethPriceLastUpdated', DateTime.now().millisecondsSinceEpoch);
      _ethPrice = double.parse(price);
      notifyListeners();
      return price;
    } catch (e) {
      print('Error fetching ETH price: $e');
      if (cachedPrice != null) return cachedPrice;
      throw Exception('Failed to fetch ETH price');
    }
  }

  Future<String?> buyECMWithETH({
    required EtherAmount ethAmount,
    required EthereumAddress referralAddress,
    required BuildContext context
  }) async {
    final chainID = _getChainIdForRequests();
    print("buyECMWithETH Chaid Id ${chainID}");

    if (appKitModal == null || !_isConnected || appKitModal!.session == null || chainID == null) {
      throw Exception("Wallet not Connected or selected chain not available.");
    }
    _isLoading = true;
    notifyListeners();

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


      // wait for the transaction  confirmation
      //  final receipt = await _web3Client!.getTransactionReceipt(result);

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

    } catch (e) {
      print("Error buying ECM with ETH: $e");
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
      } catch (e) {
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
      } catch (_) {}
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
    final chainID = _getChainIdForRequests();

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
          EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSV2));

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

      print(">> Requesting approval transaction...");
      final dynamic approveTxResult = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: ecmTokenContract,
        functionName: 'approve',
        transaction: Transaction(from: EthereumAddress.fromHex(_walletAddress)),
        parameters: [
          EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSV2),
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
      print(">> Approval confirmed.");

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

      print('>> Preparing stake transaction...');
      print('>>  stakeAmount: $stakeAmount');
      print('>>  planIndex: ${BigInt.from(planIndex)}');
      print('>>  referrerAddress: $referrerAddress');

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
      print(">> Stake transaction confirmed.");

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

              print(">> Payload prepared for backend: $payload");



              final apiUrl = '${ApiConstants.baseUrl}/staking-created';

              print(">> Sending POST request to: $apiUrl");


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
                print(">> Response status: ${response.statusCode}");
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
        } catch (e) {
          print(">> Error decoding log: $e");
        }
      }

      if (!successShown) {
        ToastMessage.show(
          message: "Staking Success (No Event Found)",
          subtitle: "Stake transaction confirmed, but event not parsed.",
          type: MessageType.success,
        );
        await fetchConnectedWalletData();
        return bytesToHex(stakeReceipt.transactionHash);
      }

      return null;
    } catch (e) {
      debugPrint("Staking failed: $e");

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
    final chainID = _getChainIdForRequests();

    if (!_isConnected || appKitModal?.session == null || chainID == null) {
      ToastMessage.show(message: "Connect wallet first.", type: MessageType.error);
      return null;
    }
    _isLoading = true;
    notifyListeners();


    try{
      // final chainID = appKitModal!.selectedChain!.chainId;

      final stakingAbiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
      final stakingContract = DeployedContract(
        ContractAbi.fromJson(stakingAbiString, 'eCommerce Coin'),
        EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSV2),
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
        }catch(e){
          print("Error decoding log: $e");
        }
      }


      await fetchConnectedWalletData();
      await getBalance();
      ToastMessage.show(message: "Force unstake successful!", type: MessageType.success);
      return txHash;
    }catch(e){
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
    final chainID = _getChainIdForRequests();

    if (!_isConnected || appKitModal?.session == null || chainID == null) {
      ToastMessage.show(message: "Connect wallet first.", type: MessageType.error);
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {

      final stakingAbiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
      final stakingContract = DeployedContract(
        ContractAbi.fromJson(stakingAbiString, 'eCommerce Coin'),
        EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESSV2),
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
        } catch (e) {
          print("Error decoding log: $e");
        }
      }

      await fetchConnectedWalletData();
      await getBalance();

      ToastMessage.show(message: "Unstake successful!", type: MessageType.success);
      return txHash;
    } catch (e) {
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

  Future<void> getVestingInformation() async {

    if (!_isConnected || _walletAddress.isEmpty) return;

    // _isLoading = true;
    notifyListeners();

    try {
      final chainId = _getChainIdForRequests();
      if (chainId == null) throw Exception('Chain ID is not available.');

      final saleContractAbiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
      final saleContractAbiData = jsonDecode(saleContractAbiString);
      final saleContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(saleContractAbiData), 'ECMCoinICO'),
        EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
      );

      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
      final walletAddressHex = appKitModal!.session!.getAddress(nameSpace);
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

      if (vestingContractAddress == zeroAddress) {
        // No vesting contract for user
        _vestingAddress = null;
        _vestingStatus = null;
      } else {
        _vestingAddress = vestingContractAddress.hex;
        await _resolveVestedStart(vestingContractAddress);
      }
    } catch (e, stack) {
      print('Error getting vesting information: $e --- $stack');
      _vestingAddress = null;
      _vestingStatus = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _resolveVestedStart(EthereumAddress vestingContractAddress) async {
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


      final start = (startResult[0] as BigInt).toInt();
      final cliff = (cliffResult[0] as BigInt).toInt();
      final duration = (durationResult[0] as BigInt).toInt();
      final released = (releasedResult[0] as BigInt);
      final claimable = (claimableResult[0] as BigInt);


      print("start: $start");
      print("cliff: $cliff");
      print("duration: $duration");
      print("released: $released");
      print("claimable: $claimable");

      vestInfo.start = start;
      vestInfo.cliff = cliff;
      vestInfo.duration = duration;
      vestInfo.released = released .toDouble();
      vestInfo.claimable = claimable.toDouble();
      vestInfo.end = start + duration;
      _vestingStatus = start > now ? 'locked' : 'process';

      notifyListeners();

    } catch (e, stackTrace) {
        print("Stack Trace: $stackTrace");
      _vestingStatus = null;
      notifyListeners();
    }
  }

  Future<void>claimECM(BuildContext context)async{
    if (_isLoading || !_isConnected || _vestingAddress == null) return;

    _isLoading = true;
    notifyListeners();

    try{
      // 1. Get the ABI and create a DeployedContract instance
      final abiString = await rootBundle.loadString("assets/abi/VestingABI.json");
      final abiData = jsonDecode(abiString);
      final vestingContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abiData), 'LinearVestingWallet'),
        EthereumAddress.fromHex(_vestingAddress!),
      );

      // 2. Get the current chain and wallet address
      final chainId = _getChainIdForRequests();
      if (chainId == null) {
        throw Exception("Selected chain not available.");
      }
      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
      final walletAddress = appKitModal!.session!.getAddress(nameSpace);
      if (walletAddress == null) {
        throw Exception("Wallet address not found.");
      }

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

      print('Transaction Hash: $txResult');

      ToastMessage.show(
        message: "Claim Successful",
        subtitle: "Your ECM tokens have been claimed.",
        type: MessageType.success,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

      // 4. Automatically refresh vesting data after a successful claim
      await refreshVesting();
    }catch(e){
      print('Error during claimECM: $e');
      final errorMessage = e.toString().contains("User rejected")
          ? "Transaction rejected by user."
          : "Claim failed. Please try again.";

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

  // Get the latest vesting data.
  Future<void> refreshVesting() async {
    if (_isLoading || _vestingAddress == null) return;
    _isLoading = true;
    notifyListeners();

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

      // final claimableResult = await _web3Client!.call(
      //     contract: vestingContract,
      //     function: vestingContract.function('vestedAmount'),
      //     params: []
      // );

      // Convert the BigInt to a double and format to 6 decimal places,
      final releasedWei = releasedResult[0] as BigInt;
      // final claimableWei = claimableResult[0] as BigInt;

      final releasedEther = EtherAmount.fromBigInt(EtherUnit.wei, releasedWei).getValueInUnit(EtherUnit.ether);
      // final claimableEther = EtherAmount.fromBigInt(EtherUnit.wei, claimableWei).getValueInUnit(EtherUnit.ether);

      final releasedAmountFormatted = releasedEther.toStringAsFixed(6);
      // final claimableAmountFormatted = claimableEther.toStringAsFixed(6);

      // Update Vesting Info Model to reflect new data
      vestInfo.released = releasedEther;
      // vestInfo.claimable = claimableEther;

      ToastMessage.show(
        message: "Vesting Refreshed",
        subtitle: "Latest vesting data has been updated.",
        type: MessageType.success,
        duration: CustomToastLength.SHORT,
        gravity: CustomToastGravity.BOTTOM,
      );
      print("Vesting refreshed successfully , Released :$releasedAmountFormatted ");


    }catch(e){
      print('Error refreshing vesting: $e');
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


  void _startVestingTimer() {
    _vestingTimer?.cancel();
    _vestingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {

      notifyListeners();
    });
  }
  ///Helper Function to wait transaction to be mined.
  Future<TransactionReceipt?> _waitForTransaction(String txHash)async{
    const pollInterval = Duration(seconds: 3);
    const timeout = Duration(minutes: 3);
    final expiry = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(expiry)){
      try{
        final receipt = await _web3Client!.getTransactionReceipt(txHash);
        if(receipt != null){
          if (receipt.status == true){
            print("Transaction successful: $txHash");
            return receipt;
          }else{
            print("Transaction reverted by EVM: $txHash");
            throw Exception("Transaction failed. Please check the block explorer for details.");
          }
        }
      }catch(e){
        debugPrint("_waitForTransaction :$e");
      }
      await Future.delayed(pollInterval);
    }
    throw Exception("Transaction timed out. Could not confirm transaction status.");
  }

  /// Mock function to format decimal value to token unit (BigInt)
  BigInt _formatValue(double amount, {required BigInt decimals}) {
    final decimalPlaces = decimals.toInt(); // e.g., 6 for USDT, 18 for ETH
    final factor = BigInt.from(10).pow(decimalPlaces);
    return BigInt.from(amount * factor.toDouble());
  }

}


class _LifecycleHandler extends WidgetsBindingObserver {
  final Future<void> Function() onResume;

  _LifecycleHandler({required this.onResume});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
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

extension ReownAppKitModalHelper on ReownAppKitModal {
  Future<void> showModalViewWithContext(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await openModalView();
    });
  }
}
