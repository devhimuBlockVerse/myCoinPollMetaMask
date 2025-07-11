import 'dart:async';
import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:reown_appkit/reown_appkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/crypto.dart';

import '../../../framework/utils/customToastMessage.dart';
import '../../../framework/utils/enums/toast_type.dart';
import '../../domain/constants/api_constants.dart';


/// STABLE 2.0
// class WalletViewModel extends ChangeNotifier with WidgetsBindingObserver{
//    void setupLifecycleObserver() {
//     WidgetsBinding.instance.addObserver(_LifecycleHandler(onResume: _handleAppResume));
//   }
//
//   BuildContext? _lastContext;
//   ///Ensures context is valid and modal is re-initialized if needed
//   Future<void> ensureModalWithValidContext(BuildContext context) async {
//     if (appKitModal == null || _lastContext != context) {
//       _lastContext = context;
//       await init(context);
//     }
//   }
//
//
//
//    ReownAppKitModal? appKitModal;
//   bool _isSessionSettling = false;
//   String _walletAddress = '';
//   bool _isLoading = false;
//   bool _isConnected = false;
//   String? _balance;
//   String? _minimumStake;
//   String? _maximumStake;
//   double _ethPrice = 0.0;
//   double _usdtPrice = 0.0;
//   int _stageIndex = 0;
//   double _currentECM = 0.0;
//   double _maxECM = 0.0;
//   int _ecmRefBonus = 0;
//   int _paymentRefBonus = 0;
//   bool _isCompleted = false;
//
//   Web3Client? _web3Client;
//   bool _isModalEventsSubscribed = false;
//
//   bool _walletConnectedManually = false;
//   bool get walletConnectedManually => _walletConnectedManually;
//
//   // Getters
//   double get ethPrice => _ethPrice;
//   double get usdtPrice => _usdtPrice;
//   int get stageIndex => _stageIndex;
//   double get currentECM => _currentECM;
//   double get maxECM => _maxECM;
//   int get ecmRefBonus => _ecmRefBonus;
//   int get paymentRefBonus => _paymentRefBonus;
//   bool get isCompleted => _isCompleted;
//   String? get balance => _balance;
//   String? get minimumStake => _minimumStake;
//   String? get maximumStake => _maximumStake;
//   String get walletAddress => _walletAddress;
//   bool get isConnected => _isConnected;
//   bool get isLoading => _isLoading;
//   bool get isSessionSettling => _isSessionSettling;
//
//   static const String ALCHEMY_URL = "https://eth-sepolia.g.alchemy.com/v2/FPbP1-XUOoRxMpYioocm5i4rdPSJSGKU";
//   static const String SALE_CONTRACT_ADDRESS = '0x02f2aA15675aED44A117aC0c55E795Be9908543D';
//   static const String ECM_TOKEN_CONTRACT_ADDRESS = '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d';
//   static const String STAKING_CONTRACT_ADDRESS = '0x0Bce6B3f0412c6650157DC0De959bf548F063833';
//
//   WalletViewModel() {
//      _web3Client = Web3Client(ALCHEMY_URL, Client());
//      WidgetsBinding.instance.addObserver(this);
//    }
//
//   @override
//   void dispose() {
//      _web3Client?.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//      appKitModal?.onModalConnect.unsubscribeAll();
//     appKitModal?.onModalUpdate.unsubscribeAll();
//     appKitModal?.onModalDisconnect.unsubscribeAll();
//     appKitModal?.onSessionExpireEvent.unsubscribeAll();
//     appKitModal?.onSessionUpdateEvent.unsubscribeAll();
//      super.dispose();
//   }
//
//
//   Future<void> init(BuildContext context) async {
//
//     if (_isLoading) return;
//
//     _isLoading = true;
//     notifyListeners();
//
//      final prefs = await SharedPreferences.getInstance();
//     final wasConnected = prefs.getBool('isConnected') ?? false;
//     final savedAddress = prefs.getString('walletAddress');
//     final savedChainId = prefs.getInt('chainId');
//
//
//
//     if (appKitModal == null) {
//       appKitModal = ReownAppKitModal(
//
//         context: context,
//         projectId: 'f3d7c5a3be3446568bcc6bcc1fcc6389',
//         metadata: const PairingMetadata(
//
//           name: "MyWallet",
//           description: "Example Description",
//           url: 'https://mycoinpoll.com/',
//           icons: ['https://example.com/logo.png'],
//           redirect: Redirect(
//             // native: 'exampleapp',
//             native: 'MyCoin Poll',
//             universal: 'https://reown.com/exampleapp',
//             linkMode: true,
//           ),
//         ),
//
//         logLevel: LogLevel.error,
//         enableAnalytics: false,
//         featuresConfig: FeaturesConfig(
//           email: false,
//           socials: [
//             AppKitSocialOption.Google,
//             AppKitSocialOption.Discord,
//             AppKitSocialOption.Facebook,
//             AppKitSocialOption.GitHub,
//             AppKitSocialOption.X,
//             AppKitSocialOption.Apple,
//             AppKitSocialOption.Twitch,
//             AppKitSocialOption.Farcaster,
//           ],
//           showMainWallets: true,
//         ),
//       );
//
//
//       try {
//         await appKitModal!.init();
//       } catch (e) {
//         debugPrint("Error initializing modal: $e");
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }
//     }
//
//     if (!_isModalEventsSubscribed) {
//       _subscribeToModalEvents(prefs);
//       _isModalEventsSubscribed = true;
//     }
//
//     // Simulate connection
//     if (wasConnected && savedAddress != null && savedChainId != null) {
//       debugPrint("⚡ Simulating auto-connect flow...");
//       _walletAddress = savedAddress;
//       _isConnected = true;
//
//       // Try opening the modal quietly, then fetch data
//       try {
//         await appKitModal!.openModalView();
//         await fetchConnectedWalletData(isReconnecting: true);
//         await getCurrentStageInfo();
//       } catch (e) {
//         debugPrint("Silent modal trigger failed: $e");
//       }
//     } else {
//        await getCurrentStageInfo();
//     }
//
//
//
//     _isLoading = false;
//     notifyListeners();
//   }
//    void _subscribeToModalEvents(SharedPreferences prefs) {
//
//     appKitModal!.onModalConnect.unsubscribeAll();
//     appKitModal!.onModalUpdate.unsubscribeAll();
//     appKitModal!.onModalDisconnect.unsubscribeAll();
//     appKitModal!.onSessionExpireEvent.unsubscribeAll();
//     appKitModal!.onSessionUpdateEvent.unsubscribeAll();
//
//     // appKitModal!.onModalConnect.subscribe((session) async {
//     //   _isConnected = true;
//     //   if (appKitModal!.session != null && appKitModal!.selectedChain != null) {
//     //     final chainId = appKitModal!.selectedChain!.chainId;
//     //     print("Chain ID: $chainId");
//     //
//     //     final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//     //     _walletAddress = appKitModal!.session!.getAddress(namespace)!;
//     //     await prefs.setBool('isConnected', true);
//     //     await prefs.setString('walletAddress', _walletAddress);
//     //     await prefs.setInt('chainId', int.parse(chainId));
//     //     // Save the session data
//     //     final sessionJson = appKitModal!.session?.toJson();
//     //     await prefs.setString('walletSession', jsonEncode(sessionJson));
//     //      await Future.wait([
//     //       fetchConnectedWalletData(),
//     //       getCurrentStageInfo(),
//     //     ]);
//     //   }
//     //   notifyListeners();
//     // });
//     appKitModal!.onModalConnect.subscribe((session) async {
//       _isConnected = true;
//       if (appKitModal!.session != null && appKitModal!.selectedChain != null) {
//         final chainId = appKitModal!.selectedChain!.chainId;
//         print("Chain ID: $chainId");
//         final numericChainId = chainId.split(':').last;
//         print("Chain ID: $numericChainId");
//
//         final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//         _walletAddress = appKitModal!.session!.getAddress(namespace)!;
//         await prefs.setBool('isConnected', true);
//         await prefs.setString('walletAddress', _walletAddress);
//         await prefs.setInt('chainId', int.parse(numericChainId));
//         // Save the session data
//         final sessionJson = appKitModal!.session?.toJson();
//         await prefs.setString('walletSession', jsonEncode(sessionJson));
//          await Future.wait([
//           fetchConnectedWalletData(),
//           getCurrentStageInfo(),
//         ]);
//       }
//       notifyListeners();
//     });
//
//     appKitModal!.onModalUpdate.subscribe((ModalConnect? event) async {
//       print("Modal Update : ${event.toString()}");
//       if (event != null) {
//         _isConnected = true;
//         final chainId = appKitModal!.selectedChain?.chainId;
//         if (chainId != null) {
//           final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//           final updatedAddress = event.session.getAddress(namespace);
//           if (updatedAddress != null && updatedAddress != _walletAddress) {
//             _walletAddress = updatedAddress;
//             print("Modal Update - New Wallet Address: $_walletAddress");
//             await fetchConnectedWalletData();
//           }
//         }
//       } else {
//         _isConnected = false;
//         _walletAddress = '';
//         print("Modal Update - Session cleared or null");
//       }
//       await getCurrentStageInfo();
//       notifyListeners();
//     });
//
//     appKitModal!.onModalDisconnect.subscribe((_) async {
//       _isConnected = false;
//       _walletAddress = '';
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.clear();
//       await _clearWalletAndStageInfo();
//       await getCurrentStageInfo();
//     });
//
//     appKitModal!.onSessionExpireEvent.subscribe((event) async {
//       print("Session expired: ${event.topic}");
//       _isConnected = false;
//       _walletAddress = '';
//       await _clearWalletAndStageInfo();
//       await getCurrentStageInfo();
//     });
//
//     appKitModal!.onSessionUpdateEvent.subscribe((event) async {
//       print("Session Update : ${event.topic}");
//       if (appKitModal!.selectedChain != null && appKitModal!.session != null) {
//         final chainId = appKitModal!.selectedChain!.chainId;
//         final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//         final updateAddress = appKitModal!.session!.getAddress(namespace)!;
//         if (updateAddress != _walletAddress) {
//           _walletAddress = updateAddress;
//           print("Updated New Wallet Address: $_walletAddress");
//         }
//         await fetchConnectedWalletData();
//       }
//       _isConnected = true;
//       await getCurrentStageInfo();
//       notifyListeners();
//     });
//   }
//
//   /// Connect the wallet using the ReownAppKitModal UI.
//
//   Future<bool> connectWallet(BuildContext context) async {
//
//     _walletConnectedManually = true;
//     _isLoading = true;
//     notifyListeners();
//     try {
//       await ensureModalWithValidContext(context);
//        await appKitModal?.openModalView();
//       return _isConnected;
//     } catch (e, stack) {
//       if (e is ReownAppKitModalException) {
//         print('Wallet connect error: ${e.message}');
//       } else {
//         print('Unexpected wallet connect error: $e');
//       }
//       print('Stack trace: $stack');
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//
//   /// Disconnect from the wallet and clear stored wallet info.
//   Future<void> disconnectWallet(BuildContext context) async {
//     if (appKitModal == null) return;
//     _isLoading = true;
//     notifyListeners();
//     try {
//       if (_isConnected && appKitModal!.session != null) {
//         await appKitModal!.disconnect();
//       }
//     } catch (e) {
//       print("Error during disconnect: $e");
//     } finally {
//       await _clearWalletAndStageInfo();
//       await getCurrentStageInfo();
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   ///LifeCycle Functions
//   Future<void> _handleAppResume() async {
//     debugPrint("App resumed. Handling reconnection...");
//     if (appKitModal == null || appKitModal!.session == null) {
//       debugPrint("No active session found on resume.");
//       await _clearWalletAndStageInfo(shouldNotify: false);
//       return;
//     }
//     try {
//       // await appKitModal?.init();
//
//       final selectedChain = appKitModal!.selectedChain;
//
//       if (selectedChain != null) {
//         final chainId = selectedChain.chainId;
//         final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//         _walletAddress = appKitModal!.session!.getAddress(namespace)!;
//         _isConnected = true;
//
//         print("Wallet reconnected: $_walletAddress");
//         await fetchConnectedWalletData(isReconnecting: true);
//         await getCurrentStageInfo();
//       } else {
//         print("Session invalid after resume. Clearing.");
//         await _clearWalletAndStageInfo(shouldNotify: true);
//       }
//     } catch (e, stack) {
//       debugPrint("Resume error: $e\n$stack");
//       await _clearWalletAndStageInfo(shouldNotify: true);
//     }finally{
//       notifyListeners();
//
//     }
//   }
//
//   Future<void> _clearWalletAndStageInfo({bool shouldNotify = true}) async {
//     _walletAddress = '';
//     _isConnected = false;
//     _balance = null;
//     _minimumStake = null;
//     _maximumStake = null;
//     _ethPrice = 0.0;
//     _usdtPrice = 0.0;
//     _stageIndex = 0;
//     _currentECM = 0.0;
//     _maxECM = 0.0;
//     _ecmRefBonus = 0;
//     _paymentRefBonus = 0;
//     _isCompleted = false;
//
//     print("Wallet state and storage have been reset.");
//     if (shouldNotify) {
//       notifyListeners();
//     }
//   }
//
//
//   Future<void> reset() async {
//     _walletAddress = '';
//     _isConnected = false;
//     _balance = null;
//     _minimumStake = null;
//     _maximumStake = null;
//     _ethPrice = 0.0;
//     _usdtPrice = 0.0;
//     _stageIndex = 0;
//     _currentECM = 0.0;
//     _maxECM = 0.0;
//     _ecmRefBonus = 0;
//     _paymentRefBonus = 0;
//     _isCompleted = false;
//      _walletConnectedManually = false;
//     _isModalEventsSubscribed = false;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
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
//    Future<void> fetchConnectedWalletData({bool isReconnecting = false}) async {
//     // Crucial: Always check for fundamental modal components before proceeding
//     if (appKitModal == null || appKitModal!.session == null || appKitModal!.selectedChain == null) {
//       print("AppKitModal or session not fully initialized. Cannot fetch connected wallet data.");
//         _clearWalletSpecificInfo(shouldNotify: !isReconnecting);
//       return;
//     }
//
//     if (!_isConnected) {
//       print("WalletViewModel is not marked as connected. Skipping connected wallet data fetch.");
//        _clearWalletSpecificInfo(shouldNotify: !isReconnecting);
//       return;
//     }
//
//      final chainID = appKitModal!.selectedChain!.chainId;
//     final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//
//
//     final currentSessionAddress = appKitModal!.session!.getAddress(nameSpace);
//
//     if (currentSessionAddress == null || currentSessionAddress.isEmpty) {
//       print("No valid wallet address found in the current session. Skipping connected wallet data fetch.");
//        await _clearWalletAndStageInfo(shouldNotify: !isReconnecting);
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
//       print("Fetching connected wallet specific data for address: $_walletAddress...");
//       await Future.wait([
//         getBalance(),
//         getMinimunStake(),
//         getMaximumStake(),
//       ]);
//     } catch (e) {
//       print('Error fetching connected wallet data: $e');
//        _clearWalletSpecificInfo(shouldNotify: true);
//     } finally {
//       if (!isReconnecting) {
//         _isLoading = false;
//         notifyListeners();
//       }
//     }
//   }
//
//
//   Future<Map<String, dynamic>> getCurrentStageInfo() async {
//      if (!_isLoading) {
//       _isLoading = true;
//       notifyListeners();
//     }
//
//     List<dynamic> result;
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final saleContract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(abiData), 'ECMCoinICO'), //ABI contract name
//         EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
//       );
//
//       // Use the existing _web3Client instance
//       result = await _web3Client!.call(
//         contract: saleContract,
//         function: saleContract.function('currentStageInfo'),
//         params: [],
//       );
//
//       // Update stage info using the result
//       _updateStageInfoFromResults(result, _isConnected);
//
//       return {
//         'stageIndex': _stageIndex,
//         'target': _maxECM,
//         'ethPrice': _ethPrice,
//         'usdtPrice': _usdtPrice,
//         'ecmRefBonus': _ecmRefBonus,
//         'paymentRefBonus': _paymentRefBonus,
//         'ecmSold': _currentECM,
//         'isCompleted': _isCompleted,
//       };
//     } catch (e, s) {
//       print('--- ERROR FETCHING STAGE INFO ---');
//       print('Exception details: ${e.toString()}');
//       print('Stack Trace: ${s.toString()}');
//        _clearStageInfoOnly(shouldNotify: true);
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // Helper to parse results and update state variables
//   void _updateStageInfoFromResults(List<dynamic> result, bool isConnected) {
//     if (result.isEmpty || result.length < 8) {
//       throw Exception("Unexpected or incomplete response from the contract.");
//     }
//
//     BigInt _safeParseBigInt(dynamic value) {
//       if (value is BigInt) {
//         return value;
//       }
//       return BigInt.parse(value.toString());
//     }
//
//      _ethPrice = (_safeParseBigInt(result[2]).toDouble() / 1e18);
//     _usdtPrice = (_safeParseBigInt(result[3]).toDouble() / 1e6);
//
//
//       _stageIndex = _safeParseBigInt(result[0]).toInt();
//       _maxECM = (_safeParseBigInt(result[1]).toDouble() / 1e18);
//       _ecmRefBonus = _safeParseBigInt(result[4]).toInt();
//       _paymentRefBonus = _safeParseBigInt(result[5]).toInt();
//       _currentECM = (_safeParseBigInt(result[6]).toDouble() / 1e18);
//       _isCompleted = result[7] as bool;
//
//     print("Stage info successfully parsed and updated:");
//     print('stageIndex: $_stageIndex');
//     print('target: $_maxECM');
//     print('ethPrice: $_ethPrice');
//     print('usdtPrice: $_usdtPrice');
//     print('ecmRefBonus: $_ecmRefBonus');
//     print('paymentRefBonus: $_paymentRefBonus');
//     print('ecmSold: $_currentECM');
//     print('isCompleted: $_isCompleted');
//
//   }
//
//    void _clearStageInfoOnly({bool shouldNotify = true}) {
//     _ethPrice = 0.0;
//     _usdtPrice = 0.0;
//     _stageIndex = 0;
//     _currentECM = 0.0;
//     _maxECM = 0.0;
//     _ecmRefBonus = 0;
//     _paymentRefBonus = 0;
//     _isCompleted = false;
//     if (shouldNotify) {
//       notifyListeners();
//     }
//   }
//
//    void _clearWalletSpecificInfo({bool shouldNotify = true}) {
//     _balance = null;
//     _minimumStake = null;
//     _maximumStake = null;
//     if (shouldNotify) {
//       notifyListeners();
//     }
//   }
//
//   Future<String> getBalance() async {
//      try {
//       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final abiData = jsonDecode(abiString);
//       final tetherContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'eCommerce Coin',
//         ),
//         EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
//       );
//
//       final tokenDecimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS);
//
//       String addressToQuery = '';
//       if (_isConnected && appKitModal != null && appKitModal!.session != null && appKitModal!.selectedChain != null) {
//         final chainID = appKitModal!.selectedChain!.chainId;
//         final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//         addressToQuery = appKitModal!.session!.getAddress(nameSpace)!;
//       } else {
//         addressToQuery = '0x0000000000000000000000000000000000000000'; // Placeholder
//         print("Wallet not connected, fetching balance for a placeholder address.");
//       }
//       print("Wallet address used for getBalance: $addressToQuery");
//
//       final balanceOfResult = await _web3Client!.call(
//         contract: tetherContract,
//         function: tetherContract.function('balanceOf'),
//         params: [EthereumAddress.fromHex(addressToQuery)],
//       );
//       final balance = balanceOfResult[0] as BigInt;
//       final divisor = BigInt.from(10).pow(tokenDecimals);
//       _balance = (balance / divisor).toString();
//       print('balanceOf: ${balanceOfResult[0]}');
//       print('runtimeType: ${balanceOfResult[0].runtimeType}');
//       return '$_balance';
//     } catch (e) {
//       _balance = null;
//       print('Error getting balance: $e');
//       rethrow;
//     }
//   }
//
//   Future<String> getTotalSupply() async {
//      try {
//       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final abiData = jsonDecode(abiString);
//       final tetherContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'eCommerce Coin',
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
//       print('totalSupply: ${totalSupplyResult[0]}');
//       print('runtimeType: ${totalSupplyResult[0].runtimeType}');
//       return '$formattedTotalSupply';
//     } catch (e) {
//       print('Error getting total supply: $e');
//       rethrow;
//     }
//   }
//
//   Future<int> getTokenDecimals({required String contractAddress}) async {
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final abiData = jsonDecode(abiString);
//       final contract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(abiData), 'eCommerce Coin'),
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
//   Future<String> getMinimunStake() async {
//      try {
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
//      try {
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
//       final maximumStakeResult = await _web3Client!.call(
//         contract: stakingContract,
//         function: stakingContract.function('maximumStake'),
//         params: [],
//       );
//       final max = (maximumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
//       _maximumStake = max.toDouble().toStringAsFixed(0);
//       print("Raw maximumStakeResult: ${maximumStakeResult[0]}");
//       return _maximumStake!;
//     } catch (e) {
//       print('Error getting Maximum stake: $e');
//       _maximumStake = null;
//       rethrow;
//     }
//   }
//
//   Future<String> transferToken(String recipientAddress, double amount) async {
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null || appKitModal!.selectedChain == null) {
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
//           'eCommerce Coin',
//         ),
//         EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
//       );
//       final chainID = appKitModal!.selectedChain!.chainId;
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
//        final result = await appKitModal!.requestWriteContract(
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
//       print('runtimeType: ${result.runtimeType}');
//       ToastMessage.show(
//         message: "Transaction Sent",
//         subtitle: "Token transfer initiated successfully!",
//         type: MessageType.success,
//         duration: CustomToastLength.LONG,
//         gravity: CustomToastGravity.BOTTOM,
//       );
//
//       await fetchConnectedWalletData();
//       await getCurrentStageInfo();
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
//   Future<String> buyECMWithETH(EtherAmount ethAmount, BuildContext context) async {
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null || appKitModal!.selectedChain == null) {
//       throw Exception("Wallet not Connected or selected chain not available.");
//     }
//     _isLoading = true;
//     notifyListeners();
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final saleContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'ECMCoinICO', // Contract name from your ABI
//         ),
//         EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
//       );
//       final chainID = appKitModal!.selectedChain!.chainId;
//       final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//       const referrerAddress = "0x0000000000000000000000000000000000000000";
//
//       final metaMaskUrl = Uri.parse('metamask://dapp/exampleapp');
//       await launchUrl(metaMaskUrl, mode: LaunchMode.externalApplication);
//
//       // No Future.delayed here.
//       final result = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: saleContract,
//         functionName: 'buyECMWithETH',
//         transaction: Transaction(
//           from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!),
//           value: ethAmount,
//         ),
//         parameters: [EthereumAddress.fromHex(referrerAddress)],
//       );
//       print('Transaction Hash: $result');
//       print('runtimeType: ${result.runtimeType}');
//       print("ABI Functions: ${saleContract.functions.map((f) => f.name).toList()}");
//       // ToastMessage.show(
//       //   message: "Purchase Successful",
//       //   subtitle: "Your transaction was submitted to the address.",
//       //   type: MessageType.success,
//       //   duration: CustomToastLength.LONG,
//       //   gravity: CustomToastGravity.BOTTOM,
//       // );
//       // await fetchConnectedWalletData();
//       // await getCurrentStageInfo();
//       // return result;
//
//
//       // ✅ Ensure it's a proper hash (optional: regex validation or check length)
//       if (result != null && result.toString().startsWith("0x") && result.toString().length == 66) {
//         ToastMessage.show(
//           message: "Purchase Successful",
//           subtitle: "Your transaction was submitted successfully.",
//           type: MessageType.success,
//           duration: CustomToastLength.LONG,
//           gravity: CustomToastGravity.BOTTOM,
//         );
//
//         await fetchConnectedWalletData();
//         await getCurrentStageInfo();
//
//         return result;
//       } else {
//          ToastMessage.show(
//           message: "Transaction Cancelled",
//           subtitle: "You cancelled the transaction in your wallet.",
//           type: MessageType.info,
//           duration: CustomToastLength.LONG,
//           gravity: CustomToastGravity.BOTTOM,
//         );
//         throw Exception("User cancelled the transaction.");
//       }
//
//     } catch (e) {
//       print("Error buying ECM with ETH: $e");
//
//       final isUserRejected = e.toString().toLowerCase().contains("user rejected") ||
//           e.toString().toLowerCase().contains("user denied") ||
//           e.toString().toLowerCase().contains("user canceled") ||
//           e.toString().toLowerCase().contains("user cancelled");
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
//
//
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<String> buyECMWithUSDT(BigInt amount, BuildContext context) async {
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null || appKitModal!.selectedChain == null) {
//       throw Exception("Wallet not Connected or selected chain not available.");
//     }
//     _isLoading = true;
//     notifyListeners();
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final saleContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'ECMCoinICO', // Contract name from your ABI
//         ),
//         EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
//       );
//       final chainID = appKitModal!.selectedChain!.chainId;
//       final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//       const referrerAddress = "0x0000000000000000000000000000000000000000";
//
//       final metaMaskUrl = Uri.parse(
//         'metamask://dapp/exampleapp',
//       );
//       await launchUrl(metaMaskUrl, mode: LaunchMode.externalApplication);
//
//       // No Future.delayed here.
//       final result = await appKitModal!.requestWriteContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: saleContract,
//         functionName: 'buyECMWithUSDT',
//         transaction: Transaction(
//           from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!),
//         ),
//         parameters: [amount, EthereumAddress.fromHex(referrerAddress)],
//       );
//       print('Transaction Hash: $result');
//       print('runtimeType: ${result.runtimeType}');
//       print("ABI Functions: ${saleContract.functions.map((f) => f.name).toList()}");
//       // ToastMessage.show(
//       //   message: "Purchase Successful",
//       //   subtitle: "USDT transaction submitted successfully!",
//       //   type: MessageType.success,
//       //   duration: CustomToastLength.LONG,
//       //   gravity: CustomToastGravity.BOTTOM,
//       // );
//       // await fetchConnectedWalletData();
//       // await getCurrentStageInfo();
//       // return result;
//       if (result != null && result.toString().startsWith("0x") && result.toString().length == 66) {
//         ToastMessage.show(
//           message: "Purchase Successful",
//           subtitle: "USDT transaction submitted successfully!",
//           type: MessageType.success,
//           duration: CustomToastLength.LONG,
//           gravity: CustomToastGravity.BOTTOM,
//         );
//         await fetchConnectedWalletData();
//         await getCurrentStageInfo();
//         return result;
//       }else{
//         ToastMessage.show(
//           message: "Transaction Cancelled",
//           subtitle: "You cancelled the transaction in your wallet.",
//           type: MessageType.info,
//           duration: CustomToastLength.LONG,
//           gravity: CustomToastGravity.BOTTOM,
//         );
//         throw Exception("User cancelled the transaction.");
//       }
//
//
//     } catch (e) {
//       print("Error buying ECM with USDT: $e");
//
//       final isUserRejected = e.toString().toLowerCase().contains("user rejected") ||
//           e.toString().toLowerCase().contains("user denied") ||
//           e.toString().toLowerCase().contains("user canceled") ||
//           e.toString().toLowerCase().contains("user cancelled");
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
//
//
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /// Mock function to format decimal value to token unit (BigInt)
//   BigInt _formatValue(double amount, {required BigInt decimals}) {
//     final decimalPlaces = decimals.toInt(); // e.g., 6 for USDT, 18 for ETH
//     final factor = BigInt.from(10).pow(decimalPlaces);
//     return BigInt.from(amount * factor.toDouble());
//   }
// }

class WalletViewModel extends ChangeNotifier with WidgetsBindingObserver{
   void setupLifecycleObserver() {
    WidgetsBinding.instance.addObserver(_LifecycleHandler(onResume: _handleAppResume));
  }

  BuildContext? _lastContext;
  ///Ensures context is valid and modal is re-initialized if needed
  Future<void> ensureModalWithValidContext(BuildContext context) async {
    if (appKitModal == null || _lastContext != context) {
      _lastContext = context;
      await init(context);
    }
  }

  ReownAppKitModal? appKitModal;
  bool _isSessionSettling = false;
  String _walletAddress = '';
  bool _isLoading = false;
  bool _isConnected = false;
  String? _balance;
  String? _minimumStake;
  String? _maximumStake;
  double _ethPrice = 0.0;
  double _usdtPrice = 0.0;
  int _stageIndex = 0;
  double _currentECM = 0.0;
  double _maxECM = 0.0;
  int _ecmRefBonus = 0;
  int _paymentRefBonus = 0;
  bool _isCompleted = false;

  Web3Client? _web3Client;
  bool _isModalEventsSubscribed = false;

  bool _walletConnectedManually = false;
  bool get walletConnectedManually => _walletConnectedManually;

  // Getters
  double get ethPrice => _ethPrice;
  double get usdtPrice => _usdtPrice;
  int get stageIndex => _stageIndex;
  double get currentECM => _currentECM;
  double get maxECM => _maxECM;
  int get ecmRefBonus => _ecmRefBonus;
  int get paymentRefBonus => _paymentRefBonus;
  bool get isCompleted => _isCompleted;
  String? get balance => _balance;
  String? get minimumStake => _minimumStake;
  String? get maximumStake => _maximumStake;
  String get walletAddress => _walletAddress;
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  bool get isSessionSettling => _isSessionSettling;

  static const String ALCHEMY_URL = "https://eth-sepolia.g.alchemy.com/v2/FPbP1-XUOoRxMpYioocm5i4rdPSJSGKU";
  static const String SALE_CONTRACT_ADDRESS = '0x02f2aA15675aED44A117aC0c55E795Be9908543D';
  static const String ECM_TOKEN_CONTRACT_ADDRESS = '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d';
  static const String STAKING_CONTRACT_ADDRESS = '0x0Bce6B3f0412c6650157DC0De959bf548F063833';

  String? _authToken;
  String? get authToken => _authToken;

  Future<void> setAuthToken(String token) async {
    _authToken = token;
    notifyListeners();
  }


  WalletViewModel() {
     _web3Client = Web3Client(ALCHEMY_URL, Client());
     WidgetsBinding.instance.addObserver(this);
   }

  @override
  void dispose() {
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

     final prefs = await SharedPreferences.getInstance();
    final wasConnected = prefs.getBool('isConnected') ?? false;
    final savedAddress = prefs.getString('walletAddress');
    final savedChainId = prefs.getInt('chainId');



    if (appKitModal == null) {
      appKitModal = ReownAppKitModal(

        context: context,
        projectId: 'f3d7c5a3be3446568bcc6bcc1fcc6389',
        metadata: const PairingMetadata(

          name: "MyWallet",
          description: "Example Description",
          url: 'https://mycoinpoll.com/',
          icons: ['https://example.com/logo.png'],
          redirect: Redirect(
            // native: 'exampleapp',
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


      try {
        await appKitModal!.init();
      } catch (e) {
        debugPrint("Error initializing modal: $e");
        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    if (!_isModalEventsSubscribed) {
      _subscribeToModalEvents(prefs);
      _isModalEventsSubscribed = true;
    }

    // Simulate connection
    if (wasConnected && savedAddress != null && savedChainId != null) {
      debugPrint("⚡ Simulating auto-connect flow...");
      _walletAddress = savedAddress;
      _isConnected = true;

      // Try opening the modal quietly, then fetch data
      try {
        await appKitModal!.openModalView();
        await fetchConnectedWalletData(isReconnecting: true);
        await getCurrentStageInfo();
      } catch (e) {
        debugPrint("Silent modal trigger failed: $e");
      }
    } else {
       await getCurrentStageInfo();
    }



    _isLoading = false;
    notifyListeners();
  }
   void _subscribeToModalEvents(SharedPreferences prefs) {

    appKitModal!.onModalConnect.unsubscribeAll();
    appKitModal!.onModalUpdate.unsubscribeAll();
    appKitModal!.onModalDisconnect.unsubscribeAll();
    appKitModal!.onSessionExpireEvent.unsubscribeAll();
    appKitModal!.onSessionUpdateEvent.unsubscribeAll();

    // appKitModal!.onModalConnect.subscribe((session) async {
    //   _isConnected = true;
    //   if (appKitModal!.session != null && appKitModal!.selectedChain != null) {
    //     final chainId = appKitModal!.selectedChain!.chainId;
    //     print("Chain ID: $chainId");
    //
    //     final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
    //     _walletAddress = appKitModal!.session!.getAddress(namespace)!;
    //     await prefs.setBool('isConnected', true);
    //     await prefs.setString('walletAddress', _walletAddress);
    //     await prefs.setInt('chainId', int.parse(chainId));
    //     // Save the session data
    //     final sessionJson = appKitModal!.session?.toJson();
    //     await prefs.setString('walletSession', jsonEncode(sessionJson));
    //      await Future.wait([
    //       fetchConnectedWalletData(),
    //       getCurrentStageInfo(),
    //     ]);
    //   }
    //   notifyListeners();
    // });
    appKitModal!.onModalConnect.subscribe((session) async {
      _isConnected = true;
      if (appKitModal!.session != null && appKitModal!.selectedChain != null) {
        final chainId = appKitModal!.selectedChain!.chainId;
        print("Chain ID: $chainId");
        final numericChainId = chainId.split(':').last;
        print("Chain ID: $numericChainId");

        final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
        _walletAddress = appKitModal!.session!.getAddress(namespace)!;
        await prefs.setBool('isConnected', true);
        await prefs.setString('walletAddress', _walletAddress);
        await prefs.setInt('chainId', int.parse(numericChainId));
        // Save the session data
        final sessionJson = appKitModal!.session?.toJson();
        await prefs.setString('walletSession', jsonEncode(sessionJson));
         await Future.wait([
          fetchConnectedWalletData(),
          getCurrentStageInfo(),
        ]);
      }
      notifyListeners();
    });

    appKitModal!.onModalUpdate.subscribe((ModalConnect? event) async {
      print("Modal Update : ${event.toString()}");
      if (event != null) {
        _isConnected = true;
        final chainId = appKitModal!.selectedChain?.chainId;
        if (chainId != null) {
          final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
          final updatedAddress = event.session.getAddress(namespace);
          if (updatedAddress != null && updatedAddress != _walletAddress) {
            _walletAddress = updatedAddress;
            print("Modal Update - New Wallet Address: $_walletAddress");
            await fetchConnectedWalletData();
          }
        }
      } else {
        _isConnected = false;
        _walletAddress = '';
        print("Modal Update - Session cleared or null");
      }
      await getCurrentStageInfo();
      notifyListeners();
    });

    appKitModal!.onModalDisconnect.subscribe((_) async {
      _isConnected = false;
      _walletAddress = '';
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _clearWalletAndStageInfo();
      await getCurrentStageInfo();
    });

    appKitModal!.onSessionExpireEvent.subscribe((event) async {
      print("Session expired: ${event.topic}");
      _isConnected = false;
      _walletAddress = '';
      await _clearWalletAndStageInfo();
      await getCurrentStageInfo();
    });

    appKitModal!.onSessionUpdateEvent.subscribe((event) async {
      print("Session Update : ${event.topic}");
      if (appKitModal!.selectedChain != null && appKitModal!.session != null) {
        final chainId = appKitModal!.selectedChain!.chainId;
        final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
        final updateAddress = appKitModal!.session!.getAddress(namespace)!;
        if (updateAddress != _walletAddress) {
          _walletAddress = updateAddress;
          print("Updated New Wallet Address: $_walletAddress");
        }
        await fetchConnectedWalletData();
      }
      _isConnected = true;
      await getCurrentStageInfo();
      notifyListeners();
    });
  }

  /// Connect the wallet using the ReownAppKitModal UI.

  Future<bool> connectWallet(BuildContext context) async {

    _walletConnectedManually = true;
    _isLoading = true;
    notifyListeners();
    try {
      await ensureModalWithValidContext(context);
       await appKitModal?.openModalView();
      return _isConnected;
    } catch (e, stack) {
      if (e is ReownAppKitModalException) {
        print('Wallet connect error: ${e.message}');
      } else {
        print('Unexpected wallet connect error: $e');
      }
      print('Stack trace: $stack');
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
    notifyListeners();
    try {
      if (_isConnected && appKitModal!.session != null) {
        await appKitModal!.disconnect();
      }
    } catch (e) {
      print("Error during disconnect: $e");
    } finally {
      await _clearWalletAndStageInfo();
      await getCurrentStageInfo();
      _isLoading = false;
      notifyListeners();
    }
  }

  ///LifeCycle Functions
  Future<void> _handleAppResume() async {
    debugPrint("App resumed. Handling reconnection...");
    if (appKitModal == null || appKitModal!.session == null) {
      debugPrint("No active session found on resume.");
      await _clearWalletAndStageInfo(shouldNotify: false);
      return;
    }
    try {
      // await appKitModal?.init();

      final selectedChain = appKitModal!.selectedChain;

      if (selectedChain != null) {
        final chainId = selectedChain.chainId;
        final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
        _walletAddress = appKitModal!.session!.getAddress(namespace)!;
        _isConnected = true;

        print("Wallet reconnected: $_walletAddress");
        await fetchConnectedWalletData(isReconnecting: true);
        await getCurrentStageInfo();
      } else {
        print("Session invalid after resume. Clearing.");
        await _clearWalletAndStageInfo(shouldNotify: true);
      }
    } catch (e, stack) {
      debugPrint("Resume error: $e\n$stack");
      await _clearWalletAndStageInfo(shouldNotify: true);
    }finally{
      notifyListeners();

    }
  }

  Future<void> _clearWalletAndStageInfo({bool shouldNotify = true}) async {
    _walletAddress = '';
    _isConnected = false;
    _balance = null;
    _minimumStake = null;
    _maximumStake = null;
    _ethPrice = 0.0;
    _usdtPrice = 0.0;
    _stageIndex = 0;
    _currentECM = 0.0;
    _maxECM = 0.0;
    _ecmRefBonus = 0;
    _paymentRefBonus = 0;
    _isCompleted = false;

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
    _usdtPrice = 0.0;
    _stageIndex = 0;
    _currentECM = 0.0;
    _maxECM = 0.0;
    _ecmRefBonus = 0;
    _paymentRefBonus = 0;
    _isCompleted = false;
     _walletConnectedManually = false;
    _isModalEventsSubscribed = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
    // Crucial: Always check for fundamental modal components before proceeding
    if (appKitModal == null || appKitModal!.session == null || appKitModal!.selectedChain == null) {
      print("AppKitModal or session not fully initialized. Cannot fetch connected wallet data.");
        _clearWalletSpecificInfo(shouldNotify: !isReconnecting);
      return;
    }

    if (!_isConnected) {
      print("WalletViewModel is not marked as connected. Skipping connected wallet data fetch.");
       _clearWalletSpecificInfo(shouldNotify: !isReconnecting);
      return;
    }

     final chainID = appKitModal!.selectedChain!.chainId;
    final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);


    final currentSessionAddress = appKitModal!.session!.getAddress(nameSpace);

    if (currentSessionAddress == null || currentSessionAddress.isEmpty) {
      print("No valid wallet address found in the current session. Skipping connected wallet data fetch.");
       await _clearWalletAndStageInfo(shouldNotify: !isReconnecting);
      return;
    }

    _walletAddress = currentSessionAddress;

    if (!isReconnecting && !_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      print("Fetching connected wallet specific data for address: $_walletAddress...");
      await Future.wait([
        getBalance(),
        getMinimunStake(),
        getMaximumStake(),
      ]);
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

  Future<Map<String, dynamic>> getCurrentStageInfo() async {
     if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    List<dynamic> result;
    try {
      final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
      final abiData = jsonDecode(abiString);
      final saleContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abiData), 'ECMCoinICO'), //ABI contract name
        EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
      );

      // Use the existing _web3Client instance
      result = await _web3Client!.call(
        contract: saleContract,
        function: saleContract.function('currentStageInfo'),
        params: [],
      );

      // Update stage info using the result
      _updateStageInfoFromResults(result, _isConnected);

      return {
        'stageIndex': _stageIndex,
        'target': _maxECM,
        'ethPrice': _ethPrice,
        'usdtPrice': _usdtPrice,
        'ecmRefBonus': _ecmRefBonus,
        'paymentRefBonus': _paymentRefBonus,
        'ecmSold': _currentECM,
        'isCompleted': _isCompleted,
      };
    } catch (e, s) {
      print('--- ERROR FETCHING STAGE INFO ---');
      print('Exception details: ${e.toString()}');
      print('Stack Trace: ${s.toString()}');
       _clearStageInfoOnly(shouldNotify: true);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper to parse results and update state variables
  void _updateStageInfoFromResults(List<dynamic> result, bool isConnected) {
    if (result.isEmpty || result.length < 8) {
      throw Exception("Unexpected or incomplete response from the contract.");
    }

    BigInt _safeParseBigInt(dynamic value) {
      if (value is BigInt) {
        return value;
      }
      return BigInt.parse(value.toString());
    }

     _ethPrice = (_safeParseBigInt(result[2]).toDouble() / 1e18);
    _usdtPrice = (_safeParseBigInt(result[3]).toDouble() / 1e6);


      _stageIndex = _safeParseBigInt(result[0]).toInt();
      _maxECM = (_safeParseBigInt(result[1]).toDouble() / 1e18);
      _ecmRefBonus = _safeParseBigInt(result[4]).toInt();
      _paymentRefBonus = _safeParseBigInt(result[5]).toInt();
      _currentECM = (_safeParseBigInt(result[6]).toDouble() / 1e18);
      _isCompleted = result[7] as bool;

    print("Stage info successfully parsed and updated:");
    print('stageIndex: $_stageIndex');
    print('target: $_maxECM');
    print('ethPrice: $_ethPrice');
    print('usdtPrice: $_usdtPrice');
    print('ecmRefBonus: $_ecmRefBonus');
    print('paymentRefBonus: $_paymentRefBonus');
    print('ecmSold: $_currentECM');
    print('isCompleted: $_isCompleted');

  }

   void _clearStageInfoOnly({bool shouldNotify = true}) {
    _ethPrice = 0.0;
    _usdtPrice = 0.0;
    _stageIndex = 0;
    _currentECM = 0.0;
    _maxECM = 0.0;
    _ecmRefBonus = 0;
    _paymentRefBonus = 0;
    _isCompleted = false;
    if (shouldNotify) {
      notifyListeners();
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

  Future<String> getBalance() async {
     try {
      final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final abiData = jsonDecode(abiString);
      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
      );

      final tokenDecimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS);

      String addressToQuery = '';
      if (_isConnected && appKitModal != null && appKitModal!.session != null && appKitModal!.selectedChain != null) {
        final chainID = appKitModal!.selectedChain!.chainId;
        final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
        addressToQuery = appKitModal!.session!.getAddress(nameSpace)!;
      } else {
        addressToQuery = '0x0000000000000000000000000000000000000000'; // Placeholder
        print("Wallet not connected, fetching balance for a placeholder address.");
      }
      print("Wallet address used for getBalance: $addressToQuery");

      final balanceOfResult = await _web3Client!.call(
        contract: tetherContract,
        function: tetherContract.function('balanceOf'),
        params: [EthereumAddress.fromHex(addressToQuery)],
      );
      final balance = balanceOfResult[0] as BigInt;
      final divisor = BigInt.from(10).pow(tokenDecimals);
      _balance = (balance / divisor).toString();
      print('balanceOf: ${balanceOfResult[0]}');
      print('runtimeType: ${balanceOfResult[0].runtimeType}');
      return '$_balance';
    } catch (e) {
      _balance = null;
      print('Error getting balance: $e');
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
          'eCommerce Coin',
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
      print('totalSupply: ${totalSupplyResult[0]}');
      print('runtimeType: ${totalSupplyResult[0].runtimeType}');
      return '$formattedTotalSupply';
    } catch (e) {
      print('Error getting total supply: $e');
      rethrow;
    }
  }

  Future<int> getTokenDecimals({required String contractAddress}) async {
    try {
      final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final abiData = jsonDecode(abiString);
      final contract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abiData), 'eCommerce Coin'),
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
      print("Decimals for staking: $decimals");

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
      print("Raw maximumStakeResult: ${maximumStakeResult[0]}");
      return _maximumStake!;
    } catch (e) {
      print('Error getting Maximum stake: $e');
      _maximumStake = null;
      rethrow;
    }
  }

  Future<String> transferToken(String recipientAddress, double amount) async {
    if (appKitModal == null || !_isConnected || appKitModal!.session == null || appKitModal!.selectedChain == null) {
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
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS),
      );
      final chainID = appKitModal!.selectedChain!.chainId;
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
      print('runtimeType: ${result.runtimeType}');
      ToastMessage.show(
        message: "Transaction Sent",
        subtitle: "Token transfer initiated successfully!",
        type: MessageType.success,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

      await fetchConnectedWalletData();
      await getCurrentStageInfo();

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

  Future<String> buyECMWithETH(EtherAmount ethAmount, BuildContext context) async {
    if (appKitModal == null || !_isConnected || appKitModal!.session == null || appKitModal!.selectedChain == null) {
      throw Exception("Wallet not Connected or selected chain not available.");
    }
    _isLoading = true;
    notifyListeners();
    try {
      final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
      final abiData = jsonDecode(abiString);
      final saleContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'ECMCoinICO', // Contract name from your ABI
        ),
        EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
      );
      final chainID = appKitModal!.selectedChain!.chainId;
      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
      const referrerAddress = "0x0000000000000000000000000000000000000000";

      final metaMaskUrl = Uri.parse('metamask://dapp/exampleapp');
      await launchUrl(metaMaskUrl, mode: LaunchMode.externalApplication);

      // No Future.delayed here.
      final result = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: saleContract,
        functionName: 'buyECMWithETH',
        transaction: Transaction(
          from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!),
          value: ethAmount,
        ),
        parameters: [EthereumAddress.fromHex(referrerAddress)],
      );
      print('Transaction Hash: $result');
      print('runtimeType: ${result.runtimeType}');
      print("ABI Functions: ${saleContract.functions.map((f) => f.name).toList()}");
      // ToastMessage.show(
      //   message: "Purchase Successful",
      //   subtitle: "Your transaction was submitted to the address.",
      //   type: MessageType.success,
      //   duration: CustomToastLength.LONG,
      //   gravity: CustomToastGravity.BOTTOM,
      // );
      // await fetchConnectedWalletData();
      // await getCurrentStageInfo();
      // return result;


      // ✅ Ensure it's a proper hash (optional: regex validation or check length)
      if (result != null && result.toString().startsWith("0x") && result.toString().length == 66) {
        ToastMessage.show(
          message: "Purchase Successful",
          subtitle: "Your transaction was submitted successfully.",
          type: MessageType.success,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );

        await fetchConnectedWalletData();
        await getCurrentStageInfo();

        return result;
      } else {
         ToastMessage.show(
          message: "Transaction Cancelled",
          subtitle: "You cancelled the transaction in your wallet.",
          type: MessageType.info,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );
        throw Exception("User cancelled the transaction.");
      }

    } catch (e) {
      print("Error buying ECM with ETH: $e");

      final isUserRejected = e.toString().toLowerCase().contains("user rejected") ||
          e.toString().toLowerCase().contains("user denied") ||
          e.toString().toLowerCase().contains("user canceled") ||
          e.toString().toLowerCase().contains("user cancelled");

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

  Future<String> buyECMWithUSDT(BigInt amount, BuildContext context) async {
    if (appKitModal == null || !_isConnected || appKitModal!.session == null || appKitModal!.selectedChain == null) {
      throw Exception("Wallet not Connected or selected chain not available.");
    }
    _isLoading = true;
    notifyListeners();
    try {
      final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
      final abiData = jsonDecode(abiString);
      final saleContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'ECMCoinICO', // Contract name from your ABI
        ),
        EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
      );
      final chainID = appKitModal!.selectedChain!.chainId;
      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
      const referrerAddress = "0x0000000000000000000000000000000000000000";

      final metaMaskUrl = Uri.parse(
        'metamask://dapp/exampleapp',
      );
      await launchUrl(metaMaskUrl, mode: LaunchMode.externalApplication);

      // No Future.delayed here.
      final result = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: saleContract,
        functionName: 'buyECMWithUSDT',
        transaction: Transaction(
          from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!),
        ),
        parameters: [amount, EthereumAddress.fromHex(referrerAddress)],
      );
      print('Transaction Hash: $result');
      print('runtimeType: ${result.runtimeType}');
      print("ABI Functions: ${saleContract.functions.map((f) => f.name).toList()}");
      // ToastMessage.show(
      //   message: "Purchase Successful",
      //   subtitle: "USDT transaction submitted successfully!",
      //   type: MessageType.success,
      //   duration: CustomToastLength.LONG,
      //   gravity: CustomToastGravity.BOTTOM,
      // );
      // await fetchConnectedWalletData();
      // await getCurrentStageInfo();
      // return result;
      if (result != null && result.toString().startsWith("0x") && result.toString().length == 66) {
        ToastMessage.show(
          message: "Purchase Successful",
          subtitle: "USDT transaction submitted successfully!",
          type: MessageType.success,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );
        await fetchConnectedWalletData();
        await getCurrentStageInfo();
        return result;
      }else{
        ToastMessage.show(
          message: "Transaction Cancelled",
          subtitle: "You cancelled the transaction in your wallet.",
          type: MessageType.info,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );
        throw Exception("User cancelled the transaction.");
      }


    } catch (e) {
      print("Error buying ECM with USDT: $e");

      final isUserRejected = e.toString().toLowerCase().contains("user rejected") ||
          e.toString().toLowerCase().contains("user denied") ||
          e.toString().toLowerCase().contains("user canceled") ||
          e.toString().toLowerCase().contains("user cancelled");

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

  Future<String?> stakeNow(BuildContext context , double amount, int planIndex,{String referrerAddress = '0x0000000000000000000000000000000000000000'})async{
    /// Modal Check
    if(appKitModal == null || !_isConnected || appKitModal!.session == null || appKitModal!.selectedChain == null){
      ToastMessage.show(
        message: "Wallet Error",
        subtitle: "Please connect your wallet before staking.",
        type: MessageType.error,
       );
      throw Exception("Wallet not connected or chain not selected.");
    }

    if(amount <= 0 || planIndex < 0){
      ToastMessage.show(
        message: "Invalid Input",
        subtitle: "Please enter a valid amount and select a plan",
        type: MessageType.info,
      );
      return null;
    }
    
    _isLoading = true;
    notifyListeners();

    try{
      /// Contract data setup
      final chainID = appKitModal!.selectedChain!.chainId;
      final tokenAbiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final stakingAbiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");

      final ecmTokenContract = DeployedContract(
          ContractAbi.fromJson(jsonEncode(jsonDecode(tokenAbiString)), 'eCommerce Coin'),
          EthereumAddress.fromHex(ECM_TOKEN_CONTRACT_ADDRESS)
      );

      final stakingContract =  DeployedContract(
          ContractAbi.fromJson(jsonEncode(jsonDecode(stakingAbiString)), 'eCommerce Coin'),
          EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESS)
      );

      final tokenDecimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS);
      final multiplier = Decimal.parse('1e$tokenDecimals');
      final stakeAmount = (Decimal.parse(amount.toString()) *  multiplier).toBigInt();

      /// Approval Transaction
      ToastMessage.show(
        message: "Step 1 of 2: Approval",
        subtitle: "Please approve the token spending in your wallet.",
        type: MessageType.info,
        duration: CustomToastLength.LONG
      );

      /// Launch MetaMask for approval
      final metaMaskUrl = Uri.parse('metamask://dapp/exampleapp');
      await launchUrl(metaMaskUrl, mode: LaunchMode.externalApplication);


      final approveTxHashBytes  = await appKitModal!.requestWriteContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: ecmTokenContract,
        functionName: 'approve',
        transaction: Transaction(from: EthereumAddress.fromHex(_walletAddress)),
        parameters:[
          EthereumAddress.fromHex(STAKING_CONTRACT_ADDRESS),
          stakeAmount,
        ],
      );
      final approveTxHash = bytesToHex(approveTxHashBytes);

      /// Wait for approval confirmation
      await _waitForTransaction(approveTxHash);
      ToastMessage.show(
        message: "Approval Successful!",
        subtitle: "Now confirming the stake transaction.",
        type: MessageType.success,
      );

      /// Stack Transaction
       ToastMessage.show(
         message: "Step 2 of 2: Staking",
         subtitle: "Please confirm the transaction in you wallet.",
         type: MessageType.info,
         duration: CustomToastLength.LONG,
       );

       final stakeTxHashBytes  = await appKitModal!.requestWriteContract(
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
      final stakeTxHash = bytesToHex(stakeTxHashBytes); /// Convert Uint8List to String

      // Wait for stake confirmation and get receipt
      final receipt = await _waitForTransaction(stakeTxHash);

      /// POST-TRANSACTION & EVENT PARSING
      if(receipt != null) {
        final stakeEvent = stakingContract.event('Staked');
        final log = receipt.logs.firstWhere(
              (log) => log.topics?.first == bytesToHex(stakeEvent.signature),
          orElse: () => throw Exception("Staked event log not found"),
        );

        final decodedLog = stakeEvent.decodeResults(log.topics!, log.data!);

        final payload = {
           'hash': bytesToHex(receipt.transactionHash),
          'staker': (decodedLog[0] as EthereumAddress).hex,
          'stakeId': (decodedLog[1] as BigInt).toString(),
          'amount': EtherAmount.fromUnitAndValue(EtherUnit.wei, decodedLog[2] as BigInt)
              .getValueInUnit(EtherUnit.ether)
              .toString(),
          'endTime': (decodedLog[4] as BigInt).toString(),
        };
        print("Staking successful. Payload: $payload");

        ///Sending payload to the backend API
        await http.post(Uri.parse('${ApiConstants.baseUrl}/staking-created'),
            body: jsonEncode(payload));

        ToastMessage.show(
          message: "Staking Successful!",
          subtitle: "Your tokens have been staked.",
          type: MessageType.success,
          duration: CustomToastLength.LONG,
        );

        /// REFRESH DATA
        await fetchConnectedWalletData();


        /// function to refresh staking history from backend
        // await loadStakeHistory();


         return bytesToHex(receipt.transactionHash);

      }

      return null;


    }catch(e){
      debugPrint("Staking failed: $e");
      final errorMessage = e.toString().toLowerCase();
      final isUserRejected = errorMessage.contains("user rejected") || errorMessage.contains("user denied") || errorMessage.contains("user cancelled");

      ToastMessage.show(
        message: isUserRejected ? "Transaction Cancelled" : "Staking Failed",
        subtitle: isUserRejected ? "You cancelled the transaction in your wallet." : "An error occurred during staking.",
        type: isUserRejected ? MessageType.info : MessageType.error,
        duration: CustomToastLength.LONG,
      );
      return null;
    }finally{
      _isLoading = false;
      notifyListeners();
    }











  }

  ///Helper Function to wait transaction to be mined.
  Future<TransactionReceipt?> _waitForTransaction(String txHash)async{
    const pollInterval = Duration(seconds: 3);
    const timeout = Duration(minutes: 3);
    final expiry = DateTime.now().add(timeout);

    print("Waiting for transaction: $txHash");

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
