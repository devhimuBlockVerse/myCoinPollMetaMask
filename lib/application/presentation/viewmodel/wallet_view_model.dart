import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';




/// Stablee
// class WalletViewModel extends ChangeNotifier {
//   ReownAppKitModal? appKitModal;
//   String _walletAddress = '';
//   bool _isLoading = false;
//   bool _isConnected = false;
//
//   String? _balance;
//   String? _minimumStake;
//   String? _maximumStake;
//
//
//   String? get balance => _balance;
//   String? get minimumStake => _minimumStake;
//   String? get maximumStake => _maximumStake;
//   String get walletAddress => _walletAddress;
//   bool get isConnected => _isConnected;
//   bool get isLoading => _isLoading;
//
//   Future<void> init(BuildContext context) async {
//
//     _isLoading = true;
//     notifyListeners();
//
//
//     final prefs = await SharedPreferences.getInstance();
//     final wasConnected =  prefs.getBool('isConnected') ?? false;
//     final savedWallet = prefs.getString('walletAddress');
//     final savedChainId = prefs.getInt('chainId');
//
//
//     if (appKitModal == null){
//
//       appKitModal = ReownAppKitModal(
//         context: context,
//         projectId:
//         'f3d7c5a3be3446568bcc6bcc1fcc6389',
//
//         metadata: const PairingMetadata(
//           name: "MyWallet",
//           description: "Example Description",
//           url: 'https://example.com/',
//           icons: ['https://example.com/logo.png'],
//           redirect: Redirect(
//             native: 'exampleapp',
//             universal: 'https://reown.com/exampleapp',
//             linkMode: true,
//           ),
//         ),
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
//       await appKitModal?.init();
//
//       ///Saving User Connected Session
//       appKitModal!.onModalConnect.subscribe((session)async {
//         _isConnected = true;
//         if (appKitModal!.session != null && appKitModal!.selectedChain != null) {
//           final chainId = appKitModal!.selectedChain!.chainId;
//           print("Chain ID: $chainId");
//           final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//           _walletAddress = appKitModal!.session!.getAddress(namespace)!;
//           await prefs.setBool('isConnected', true);
//           await prefs.setString('walletAddress', _walletAddress);
//           await prefs.setInt('chainId', int.parse(chainId));
//         }
//         notifyListeners();
//       });
//       appKitModal!.onModalUpdate.subscribe((ModalConnect? event){
//         print("Modal Update ; ${event.toString()}");
//
//         if(event != null){
//           _isConnected = true;
//
//           final chainId =  appKitModal!.selectedChain?.chainId;
//           if(chainId != null){
//             final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//             final updatedAddress = event.session.getAddress(namespace);
//
//             if(updatedAddress != null && updatedAddress != _walletAddress){
//               _walletAddress = updatedAddress;
//               print("Modal Update - New Wallet Address: $_walletAddress");
//
//             }
//           }
//         }else{
//           _isConnected = false;
//           _walletAddress = '';
//           print("Modal Update - Session cleared or null");
//
//         }
//
//         notifyListeners();
//       });
//       appKitModal!.onModalDisconnect.subscribe((_)async {
//         _isConnected = false;
//         _walletAddress = '';
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.clear();
//         await reset();
//         notifyListeners();
//       });
//       appKitModal!.onSessionExpireEvent.subscribe((event)async{
//         print("Session expired: ${event.topic}");
//         _isConnected = false;
//         _walletAddress = '';
//         await reset();
//         notifyListeners();
//       });
//       appKitModal!.onSessionUpdateEvent.subscribe((event)async{
//         print("Session Update : ${event.topic}");
//
//         final chainId = appKitModal!.selectedChain!.chainId;
//         final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//         final updateAddress = appKitModal!.session!.getAddress(namespace)!;
//
//         if(appKitModal!.session != null && updateAddress != _walletAddress ){
//           _walletAddress = updateAddress;
//           print("Updated New Wallet Address: $_walletAddress");
//         }
//
//         try{
//           final balance = await getBalance();
//           print("Updated new Balance : $balance");
//           await getMinimunStake();
//           await getMaximumStake();
//           await getCurrentStageInfo();
//
//
//         }catch(e){
//           print("Failed to refresh balance: $e");
//         }
//
//         _isConnected= true;
//         notifyListeners();
//
//       });
//     }
//
//     if (wasConnected && savedWallet != null && savedChainId != null) {
//       _isConnected = true;
//       _walletAddress = savedWallet;
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   /// Connect the wallet using the ReownAppKitModal UI.
//   // Future<bool> connectWallet(BuildContext context) async {
//   //
//   //   _isLoading = true;
//   //   notifyListeners();
//   //
//   //   try {
//   //     if (appKitModal == null){
//   //       appKitModal = ReownAppKitModal(
//   //         context: context,
//   //         projectId:
//   //         'f3d7c5a3be3446568bcc6bcc1fcc6389',
//   //         metadata: const PairingMetadata(
//   //           name: "MyWallet",
//   //           description: "Example Description",
//   //           url: 'https://example.com/',
//   //           icons: ['https://example.com/logo.png'],
//   //           redirect: Redirect(
//   //             native: 'exampleapp',
//   //             universal: 'https://reown.com/exampleapp',
//   //             linkMode: true,
//   //           ),
//   //         ),
//   //         logLevel: LogLevel.error,
//   //         enableAnalytics: true,
//   //         featuresConfig: FeaturesConfig(
//   //           email: true,
//   //           socials: [
//   //             AppKitSocialOption.Google,
//   //             AppKitSocialOption.Discord,
//   //             AppKitSocialOption.Facebook,
//   //             AppKitSocialOption.GitHub,
//   //             AppKitSocialOption.X,
//   //             AppKitSocialOption.Apple,
//   //             AppKitSocialOption.Twitch,
//   //             AppKitSocialOption.Farcaster,
//   //           ],
//   //           showMainWallets: true,
//   //         ),
//   //       );
//   //       await appKitModal?.init();
//   //       // Open the modal view
//   //       await appKitModal!.openModalView();
//   //       notifyListeners();
//   //     }else{
//   //       await appKitModal!.openModalView();
//   //       // notifyListeners();
//   //     }
//   //
//   //     return _isConnected;
//   //
//   //    } catch (e) {
//   //     print('Error connecting to wallet: $e');
//   //     rethrow;
//   //   } finally {
//   //     _isLoading = false;
//   //     notifyListeners();
//   //   }
//   // }
//   Future<bool> connectWallet(BuildContext context) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       if (appKitModal == null) {
//         await init(context); // Reusing init method
//       }
//
//       // Open the modal view if appKitModal is initialized
//       await appKitModal?.openModalView();
//
//       return _isConnected;
//     } catch (e) {
//       print('Error connecting to wallet: $e');
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
//       if (_isConnected && appKitModal!.session != null) {
//         await appKitModal!.disconnect();
//       }
//     } catch (e) {
//       print("Error during disconnect: $e");
//     } finally {
//       await reset();
//       _isLoading = false;
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
//
//     // Clear all data from SharedPreferences to remove corrupt sessions
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//
//     print("Wallet state and storage have been reset.");
//     notifyListeners();
//   }
//
//   Future<String> getBalance() async {
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
//       throw Exception("Wallet not Connected");
//     }
//
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final abiData = jsonDecode(abiString);
//
//       final tetherContract = DeployedContract(
//         ContractAbi.fromJson(
//           // abiData,
//           jsonEncode(abiData),
//           'eCommerce Coin',
//         ),
//         EthereumAddress.fromHex(
//             '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d'),
//       );
//
//       final chainID = appKitModal!.selectedChain!.chainId;
//       print("Chain ID : $chainID");
//
//       final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//
//       final decimals = await appKitModal!.requestReadContract(
//           topic: appKitModal!.session!.topic,
//           chainId: chainID,
//           deployedContract: tetherContract,
//           functionName: 'decimals');
//
//
//       print("Wallet address used: $walletAddress");
//
//       final balanceOf = await appKitModal!.requestReadContract(
//           topic: appKitModal!.session!.topic,
//           chainId: chainID,
//           deployedContract: tetherContract,
//           functionName: 'balanceOf',
//           parameters: [ EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!)]
//       );
//
//       final tokenDecimals = (decimals[0] as BigInt).toInt();
//       final balance = balanceOf[0] as BigInt;
//
//       final divisor = BigInt.from(10).pow(tokenDecimals);
//
//       _balance = (balance / divisor).toString();
//
//
//       print('balanceOf: ${balanceOf[0]}');
//       print('runtimeType: ${balanceOf[0].runtimeType}');
//
//       return  '$_balance'  ;
//
//     } catch (e) {
//       _balance = null;
//       print('Error getting balance: $e');
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<String> getTotalSupply() async {
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
//       throw Exception("Wallet not Connected");
//     }
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final abiData = jsonDecode(abiString);
//
//       final tetherContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'eCommerce Coin',
//         ),
//         EthereumAddress.fromHex(
//             '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d'),
//       );
//
//       final totalSupplyResult = await appKitModal!.requestReadContract(
//         deployedContract: tetherContract,
//         topic: appKitModal!.session!.topic,
//         chainId: appKitModal!.selectedChain!.chainId,
//         functionName: 'totalSupply',
//       );
//
//       final decimals = await appKitModal!.requestReadContract(
//           topic: appKitModal!.session!.topic,
//           chainId: appKitModal!.selectedChain!.chainId,
//           deployedContract: tetherContract,
//           functionName: 'decimals');
//
//       final tokenDecimals = (decimals[0] as BigInt).toInt();
//       final totalSupply = totalSupplyResult[0] as BigInt;
//       final divisor = BigInt.from(10).pow(tokenDecimals);
//       final formattedTotalSupply = totalSupply / divisor;
//
//       print('totalSupply: ${totalSupplyResult[0]}');
//       print('runtimeType: ${totalSupplyResult[0].runtimeType}');
//
//       return '$formattedTotalSupply';
//     } catch (e) {
//       print('Error getting total supply: $e');
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> transferToken(String recipientAddress, double amount) async{
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
//       throw Exception("Wallet not Connected");
//     }
//
//     try{
//
//       _isLoading = true;
//       notifyListeners();
//
//       final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//       final abiData = jsonDecode(abiString);
//
//       final tetherContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'eCommerce Coin',
//         ),
//         EthereumAddress.fromHex(
//             '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d'),
//       );
//
//
//
//       final chainID = appKitModal!.selectedChain!.chainId;
//       final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//
//       final decimals = await appKitModal!.requestReadContract(
//           topic: appKitModal!.session!.topic,
//           chainId: chainID,
//           deployedContract: tetherContract,
//           functionName: 'decimals');
//
//
//       final decimalUnits = (decimals.first as BigInt);
//       final transferValue = _formatValue(amount, decimals: decimalUnits);
//       final metaMaskUrl = Uri.parse(
//         'metamask://dapp/exampleapp',
//       );
//       await launchUrl(metaMaskUrl,);
//
//       await Future.delayed(const Duration(seconds: 2));
//
//       final result = await appKitModal!.requestWriteContract(
//           topic: appKitModal!.session!.topic,
//           chainId: chainID,
//           deployedContract: tetherContract,
//           functionName: 'transfer',
//           transaction: Transaction(
//               from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!)
//           ),
//           parameters: [ EthereumAddress.fromHex(recipientAddress),transferValue,
//           ]
//       );
//
//       print('Transfer Result: $result');
//       print('runtimeType: ${result.runtimeType}');
//
//       return result;
//
//     }catch(e){
//       print('Error Sending transferToken: $e');
//       Fluttertoast.showToast(
//           msg: "Error: ${e.toString()}",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0
//       );
//
//       rethrow;
//     }finally{
//       _isLoading = false;
//       notifyListeners();
//     }
//
//   }
//
//   // Future<Map<String, dynamic>> getCurrentStageInfo() async{
//   //
//   //   try{
//   //     _isLoading = true;
//   //     notifyListeners();
//   //
//   //
//   //      if (appKitModal == null || appKitModal!.session == null || appKitModal!.selectedChain == null) {
//   //       print('getCurrentStageInfo failed: appKitModal, session, or selectedChain is null.');
//   //        throw Exception("Wallet not fully connected or initialized.");
//   //     }
//   //
//   //     final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//   //     final abiData = jsonDecode(abiString);
//   //
//   //     final stageContract = DeployedContract(
//   //       ContractAbi.fromJson(
//   //         jsonEncode(abiData),
//   //         'eCommerce Coin',
//   //       ),
//   //       EthereumAddress.fromHex('0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
//   //     );
//   //
//   //     final chainID = appKitModal!.selectedChain!.chainId;
//   //
//   //     print('Attempting to read contract:');
//   //     print('  Chain ID: $chainID');
//   //     print('  Contract Address: ${stageContract.address.hex}');
//   //     print('  Function Name: currentStageInfo');
//   //     print('  Session Topic: ${appKitModal!.session!.topic}');
//   //
//   //     final result = await appKitModal!.requestReadContract(
//   //         topic: appKitModal!.session!.topic,
//   //         chainId: chainID,
//   //         deployedContract: stageContract,
//   //         functionName: 'currentStageInfo',
//   //
//   //     );
//   //
//   //     if(result.isEmpty || result.length < 5){
//   //       throw Exception("Unexpected response from contract");
//   //     }
//   //
//   //
//   //     final stageInfo = {
//   //       'stageIndex': (result[0] as BigInt).toInt(),
//   //       'target': (result[1] as BigInt) / BigInt.from(10).pow(18),
//   //       'ethPrice': (result[2] as BigInt) / BigInt.from(10).pow(18),
//   //       'usdtPrice': (result[3] as BigInt) / BigInt.from(10).pow(6),
//   //       'ecmRefBonus': (result[4] as BigInt).toInt(),
//   //       'paymentRefBonus': (result[5] as BigInt).toInt(),
//   //       'ecmSold':  result[6] is BigInt ? (result[6] as BigInt)/ BigInt.from(10).pow(18) : result[6],
//   //     'isCompleted': result[7] as bool,
//   //     };
//   //
//   //
//   //     print("Stage info successfully parsed:");
//   //     stageInfo.forEach((key, value){
//   //       print('$key: $value (Type: ${value.runtimeType})');
//   //     });
//   //
//   //
//   //
//   //     return stageInfo ;
//   //
//   //   }catch(e){
//   //     print('Error fetching stage info: $e');
//   //     rethrow;
//   //   }finally{
//   //     _isLoading = false ;
//   //     notifyListeners();
//   //   }
//   //
//   // }
//
//   Future<Map<String, dynamic>> getCurrentStageInfo() async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       if (appKitModal == null || appKitModal!.session == null || appKitModal!.selectedChain == null) {
//         throw Exception("Wallet not connected or initialized.");
//       }
//
//       final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final stageContract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(abiData), 'ECMCoinICO'), // contract name from ABI
//         EthereumAddress.fromHex('0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
//       );
//       final chainID = appKitModal!.selectedChain!.chainId;
//
//       print('Attempting to read contract function: currentStageInfo');
//
//       final result = await appKitModal!.requestReadContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: stageContract,
//         functionName: 'currentStageInfo',
//       );
//
//       if (result.isEmpty || result.length < 8) {
//         throw Exception("Unexpected or incomplete response from the contract.");
//       }
//
//       // Helper function for safe BigInt parsing
//       BigInt _safeParseBigInt(dynamic value) {
//         if (value is BigInt) {
//           return value;
//         }
//         return BigInt.parse(value.toString());
//       }
//
//       final stageInfo = {
//         'stageIndex': _safeParseBigInt(result[0]).toInt(),
//         'target': _safeParseBigInt(result[1]) / BigInt.from(10).pow(18),
//         'ethPrice': _safeParseBigInt(result[2]) / BigInt.from(10).pow(18),
//         'usdtPrice': _safeParseBigInt(result[3]) / BigInt.from(10).pow(6),
//         'ecmRefBonus': _safeParseBigInt(result[4]).toInt(),
//         'paymentRefBonus': _safeParseBigInt(result[5]).toInt(),
//         'ecmSold': _safeParseBigInt(result[6]) / BigInt.from(10).pow(18),
//         'isCompleted': result[7] as bool,
//       };
//
//       print("Stage info successfully parsed:");
//       stageInfo.forEach((key, value) {
//         print('$key: $value (Type: ${value.runtimeType})');
//       });
//
//       return stageInfo;
//     } catch (e,s) {
//       print('--- ERROR FETCHING STAGE INFO ---');
//       print('Exception details: ${e.toString()}'); // <-- ADD THIS LINE
//       print('Stack Trace: ${s.toString()}');
//       print('Error fetching stage info: $e');
//       rethrow; // Rethrow to be caught by the UI
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//   Future<String> buyECMWithETH( EtherAmount ethAmount, BuildContext context) async{
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
//       throw Exception("Wallet not Connected");
//     }
//
//     try{
//       _isLoading = true;
//       notifyListeners();
//
//       final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//       final abiData = jsonDecode(abiString);
//
//       final tetherContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'eCommerce Coin',
//         ),
//         EthereumAddress.fromHex(
//             '0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
//       );
//
//
//       final chainID = appKitModal!.selectedChain!.chainId;
//       final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//
//       const referrerAddress = "0x0000000000000000000000000000000000000000";
//
//
//       final metaMaskUrl = Uri.parse('metamask://dapp/exampleapp',);
//       await launchUrl(metaMaskUrl,);
//
//
//       await Future.delayed(const Duration(seconds: 3));
//
//       final result = await appKitModal!.requestWriteContract(
//           topic: appKitModal!.session!.topic,
//           chainId: chainID,
//           deployedContract: tetherContract,
//           functionName: 'buyECMWithETH',
//           transaction: Transaction(
//             from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!),
//             value: ethAmount,
//           ),
//           parameters: [ EthereumAddress.fromHex(referrerAddress)]
//       );
//
//       print('Transaction Hash: $result');
//       print('runtimeType: ${result.runtimeType}');
//       print("ABI Functions: ${tetherContract.functions.map((f) => f.name).toList()}");
//
//       Fluttertoast.showToast(
//         msg: "Transaction sent successfully!",
//         backgroundColor: Colors.green,
//       );
//       return result;
//
//     }catch(e){
//       print("Error buying ECM with ETH: $e");
//       Fluttertoast.showToast(
//         msg: "Error: ${e.toString()}",
//         backgroundColor: Colors.red,
//       );
//       rethrow;
//     }finally{
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<String> buyECMWithUSDT( BigInt amount, BuildContext context) async{
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
//       throw Exception("Wallet not Connected");
//     }
//
//     try{
//       _isLoading = true;
//       notifyListeners();
//
//       final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//       final abiData = jsonDecode(abiString);
//
//       final tetherContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'eCommerce Coin',
//         ),
//         EthereumAddress.fromHex(
//             '0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
//       );
//
//
//       final chainID = appKitModal!.selectedChain!.chainId;
//       final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);
//
//       const referrerAddress = "0x0000000000000000000000000000000000000000";
//
//
//       final metaMaskUrl = Uri.parse(
//         'metamask://dapp/exampleapp',
//       );
//       await launchUrl(metaMaskUrl,);
//
//       await Future.delayed(const Duration(seconds: 3));
//
//       final result = await appKitModal!.requestWriteContract(
//           topic: appKitModal!.session!.topic,
//           chainId: chainID,
//           deployedContract: tetherContract,
//           functionName: 'buyECMWithUSDT',
//           transaction: Transaction(
//             from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!),
//           ),
//
//           parameters: [ amount,EthereumAddress.fromHex(referrerAddress)]
//       );
//
//
//       print('Transaction Hash: $result');
//       print('runtimeType: ${result.runtimeType}');
//       print("ABI Functions: ${tetherContract.functions.map((f) => f.name).toList()}");
//
//       Fluttertoast.showToast(
//         msg: "Transaction sent successfully!",
//         backgroundColor: Colors.green,
//       );
//       return result;
//
//     }catch(e){
//       print("Error buying ECM with ETH: $e");
//       Fluttertoast.showToast(
//         msg: "Error: ${e.toString()}",
//         backgroundColor: Colors.red,
//       );
//       rethrow;
//     }finally{
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<int> getTokenDecimals() async {
//     final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//     final abiData = jsonDecode(abiString);
//
//     final contract = DeployedContract(
//       ContractAbi.fromJson(jsonEncode(abiData), 'eCommerce Coin'),
//       EthereumAddress.fromHex('0x30C8E35377208ebe1b04f78B3008AAc408F00D1d'),
//     );
//
//     final decimalsResult = await appKitModal!.requestReadContract(
//       deployedContract: contract,
//       topic: appKitModal!.session!.topic,
//       chainId: appKitModal!.selectedChain!.chainId,
//       functionName: 'decimals',
//     );
//
//     return (decimalsResult[0] as BigInt).toInt();
//   }
//
//   Future<String> getMinimunStake() async {
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
//       throw Exception("Wallet not Connected");
//     }
//
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final decimals = await getTokenDecimals();
//       print("Decimals: $decimals");
//
//       final tetherContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'eCommerce Coin',
//         ),
//         EthereumAddress.fromHex(
//             '0x0Bce6B3f0412c6650157DC0De959bf548F063833'),
//       );
//
//       final chainID = appKitModal!.selectedChain!.chainId;
//       print("Chain ID : $chainID");
//
//
//
//       final minimumStakeResult = await appKitModal!.requestReadContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: tetherContract,
//         functionName: 'minimumStake',
//       );
//
//       final min = (minimumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
//       _minimumStake = min.toDouble().toStringAsFixed(0);
//       print("Raw minimumStakeResult: ${minimumStakeResult[0]}");
//
//       notifyListeners();
//       return _minimumStake!;
//
//     } catch (e) {
//       print('Error getting minimum stake: $e');
//       _minimumStake = null;
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<String> getMaximumStake() async {
//     if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
//       throw Exception("Wallet not Connected");
//     }
//
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final decimals = await getTokenDecimals();
//       print("Decimals: $decimals");
//
//       final tetherContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'eCommerce Coin',
//         ),
//         EthereumAddress.fromHex(
//             '0x0Bce6B3f0412c6650157DC0De959bf548F063833'),
//       );
//
//       final chainID = appKitModal!.selectedChain!.chainId;
//       print("Chain ID : $chainID");
//
//
//
//       final maximumStakeResult = await appKitModal!.requestReadContract(
//         topic: appKitModal!.session!.topic,
//         chainId: chainID,
//         deployedContract: tetherContract,
//         functionName: 'maximumStake',
//       );
//
//       final max = (maximumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
//       _maximumStake = max.toDouble().toStringAsFixed(0);
//       print("Raw maximumStakeResult: ${maximumStakeResult[0]}");
//
//       notifyListeners();
//       return _maximumStake!;
//
//     } catch (e) {
//       print('Error getting Maximum stake: $e');
//       _maximumStake = null;
//       rethrow;
//
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
//
//
// }

class WalletViewModel extends ChangeNotifier {
  ReownAppKitModal? appKitModal;
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

  // Getters for stage info
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


  static const String INFURA_URL = "https://sepolia.infura.io/v3/b6521574dded4cc4b16f0975d484da49";
  static const String SALE_CONTRACT_ADDRESS = '0x02f2aA15675aED44A117aC0c55E795Be9908543D';


  Future<void> init(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    // WidgetsBinding.instance.addObserver(this);
    final prefs = await SharedPreferences.getInstance();
    final wasConnected = prefs.getBool('isConnected') ?? false;
    final savedWallet = prefs.getString('walletAddress');
    final savedChainId = prefs.getInt('chainId');

    if (appKitModal == null) {
      appKitModal = ReownAppKitModal(
        context: context,
        projectId: 'f3d7c5a3be3446568bcc6bcc1fcc6389',
        metadata: const PairingMetadata(
          name: "MyWallet",
          description: "Example Description",
          url: 'https://example.com/',
          icons: ['https://example.com/logo.png'],
          redirect: Redirect(
            native: 'exampleapp',
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
      await appKitModal?.init();

      ///Saving User Connected Session
      appKitModal!.onModalConnect.subscribe((session) async {
        _isConnected = true;
        if (appKitModal!.session != null && appKitModal!.selectedChain != null) {
          final chainId = appKitModal!.selectedChain!.chainId;
          print("Chain ID: $chainId");
          final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
          _walletAddress = appKitModal!.session!.getAddress(namespace)!;
          await prefs.setBool('isConnected', true);
          await prefs.setString('walletAddress', _walletAddress);
          await prefs.setInt('chainId', int.parse(chainId));
          await fetchConnectedWalletData();
          await getCurrentStageInfo();
        }
        await getCurrentStageInfo();
        notifyListeners();
      });

      appKitModal!.onModalUpdate.subscribe((ModalConnect? event) async {
        print("Modal Update ; ${event.toString()}");
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
              await getCurrentStageInfo();

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
        _clearWalletAndStageInfo();
        await getCurrentStageInfo();
        notifyListeners();
      });

      appKitModal!.onSessionExpireEvent.subscribe((event) async {
        print("Session expired: ${event.topic}");
        _isConnected = false;
        _walletAddress = '';
        _clearWalletAndStageInfo();
        await getCurrentStageInfo();
        notifyListeners();
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

    if (wasConnected && savedWallet != null && savedChainId != null) {
      _isConnected = true;
      _walletAddress = savedWallet;
       if (appKitModal != null && appKitModal!.session != null && appKitModal!.selectedChain != null) {
        print("App launch: Wallet was connected, fetching connected data now.");
        final chainId = appKitModal!.selectedChain!.chainId;
        print("Chain ID: $chainId");
        final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
        _walletAddress = appKitModal!.session!.getAddress(namespace)!;
        await prefs.setBool('isConnected', true);
        await prefs.setString('walletAddress', _walletAddress);
        await prefs.setInt('chainId', int.parse(chainId));
        await fetchConnectedWalletData();
        // await getCurrentStageInfo();
      } else {
         print("App launch: Wallet was previously connected, but session or selectedChain is null. Resetting connection.");
        _isConnected = false;
        _walletAddress = '';
        await prefs.clear();
      }
    }

    if (_isConnected && appKitModal != null && appKitModal!.session != null && appKitModal!.selectedChain != null) {
       print("App relaunch: Wallet was connected, fetching connected data now.");
      await fetchConnectedWalletData();
    }


     await getCurrentStageInfo();

    _isLoading = false;
    notifyListeners();
  }

  /// Connect the wallet using the ReownAppKitModal UI.
    Future<bool> connectWallet(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (appKitModal == null) {
        await init(context);
      }

      await appKitModal?.openModalView();
      await  fetchConnectedWalletData();

      return _isConnected;
    } catch (e) {
      print('Error connecting to wallet: $e');
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
  Future<void> _clearWalletAndStageInfo() async {
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
     SharedPreferences.getInstance().then((prefs) => prefs.clear());
    print("Wallet state and storage have been reset.");
   }
  Future<void> reset() async {
    _walletAddress = '';
    _isConnected = false;
    _balance = null;
    _minimumStake = null;
    _maximumStake = null;

    // Clear all data from SharedPreferences to remove corrupt sessions
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    print("Wallet state and storage have been reset.");
    notifyListeners();
  }

  //specific data fetching (only when connected)
  Future<void> fetchConnectedWalletData() async {
    if (!_isConnected || appKitModal == null || appKitModal!.session == null || appKitModal!.selectedChain == null) {
      print("Not connected, skipping connected wallet data fetch.");
      return;
    }
    try {
      print("Fetching connected wallet specific data...");
      await getBalance();
      await getMinimunStake();
      await getMaximumStake();
      await getCurrentStageInfo();
     } catch (e) {
      print('Error fetching connected wallet data: $e');
    }
  }

   //Unified getCurrentStageInfo function
  Future<Map<String, dynamic>> getCurrentStageInfo() async {


    _isLoading = true;
    notifyListeners();

    List<dynamic> result;

    try {
      final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
      final abiData = jsonDecode(abiString);
      final saleContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abiData), 'ECMCoinICO'), //ABI contract name
        EthereumAddress.fromHex(SALE_CONTRACT_ADDRESS),
      );

      if (_isConnected && appKitModal != null && appKitModal!.session != null && appKitModal!.selectedChain != null) {

        final selectedChain = appKitModal!.selectedChain;

        if (selectedChain == null) {
          print("Wallet is connected, but selectedChain is null. Skipping connected fetch.");
          throw Exception("No chain selected in ReownAppKitModal.");
        }


        // final connectedChainId = appKitModal!.selectedChain!.chainId;
        final connectedChainId = selectedChain.chainId;
        print('Fetching stage info via connected wallet (ReownAppKitModal) for chain ID: $connectedChainId');
        result = await appKitModal!.requestReadContract(
          topic: appKitModal!.session!.topic,
          chainId: connectedChainId,
          deployedContract: saleContract,
          functionName: 'currentStageInfo',
        );
      } else {
        // Fallback to Web3Client for disconnected calls
        final web3client = Web3Client(INFURA_URL, Client());
        print('Fetching stage info via public RPC (Web3Client) for chain ID: ');
        result = await web3client.call(
          contract: saleContract,
          function: saleContract.function('currentStageInfo'),
          params: [],
        );
        await web3client.dispose();
      }

      // Update stage info using the result from either path
      _updateStageInfoFromResults(result);

      // Return the updated stage info as a map (optional, but good for direct consumption)
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
      // If fetching fails, clear existing stage info to reflect no data
      _clearStageInfoOnly();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  // Helper to parse results and update state variables
  void _updateStageInfoFromResults(List<dynamic> result) {
    if (result.isEmpty || result.length < 8) {
      throw Exception("Unexpected or incomplete response from the contract.");
    }

    BigInt _safeParseBigInt(dynamic value) {
      if (value is BigInt) {
        return value;
      }
      return BigInt.parse(value.toString());
    }

    _stageIndex = _safeParseBigInt(result[0]).toInt();
    _maxECM = (_safeParseBigInt(result[1]) / BigInt.from(10).pow(18)).toDouble();
    _ethPrice = (_safeParseBigInt(result[2]) / BigInt.from(10).pow(18)).toDouble();
    _usdtPrice = (_safeParseBigInt(result[3]) / BigInt.from(10).pow(6)).toDouble();
    _ecmRefBonus = _safeParseBigInt(result[4]).toInt();
    _paymentRefBonus = _safeParseBigInt(result[5]).toInt();
    _currentECM = (_safeParseBigInt(result[6]) / BigInt.from(10).pow(18)).toDouble();
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


  // Clears only stage info related variables
  void _clearStageInfoOnly() {
    _ethPrice = 0.0;
    _usdtPrice = 0.0;
    _stageIndex = 0;
    _currentECM = 0.0;
    _maxECM = 0.0;
    _ecmRefBonus = 0;
    _paymentRefBonus = 0;
    _isCompleted = false;
  }

  Future<String> getBalance() async {
    if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
      throw Exception("Wallet not Connected");
    }

    try {
      _isLoading = true;
      notifyListeners();

      final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final abiData = jsonDecode(abiString);

      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          // abiData,
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(
            '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d'),
      );

      final chainID = appKitModal!.selectedChain!.chainId;
      print("Chain ID : $chainID");

      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);

      final decimals = await appKitModal!.requestReadContract(
          topic: appKitModal!.session!.topic,
          chainId: chainID,
          deployedContract: tetherContract,
          functionName: 'decimals');


      print("Wallet address used: $walletAddress");

      final balanceOf = await appKitModal!.requestReadContract(
          topic: appKitModal!.session!.topic,
          chainId: chainID,
          deployedContract: tetherContract,
          functionName: 'balanceOf',
          parameters: [ EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!)]
      );

      final tokenDecimals = (decimals[0] as BigInt).toInt();
      final balance = balanceOf[0] as BigInt;

      final divisor = BigInt.from(10).pow(tokenDecimals);

      _balance = (balance / divisor).toString();


      print('balanceOf: ${balanceOf[0]}');
      print('runtimeType: ${balanceOf[0].runtimeType}');

      return  '$_balance'  ;

    } catch (e) {
      _balance = null;
      print('Error getting balance: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getTotalSupply() async {
    if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
      throw Exception("Wallet not Connected");
    }
    try {
      _isLoading = true;
      notifyListeners();

      final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final abiData = jsonDecode(abiString);

      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(
            '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d'),
      );

      final totalSupplyResult = await appKitModal!.requestReadContract(
        deployedContract: tetherContract,
        topic: appKitModal!.session!.topic,
        chainId: appKitModal!.selectedChain!.chainId,
        functionName: 'totalSupply',
      );

      final decimals = await appKitModal!.requestReadContract(
          topic: appKitModal!.session!.topic,
          chainId: appKitModal!.selectedChain!.chainId,
          deployedContract: tetherContract,
          functionName: 'decimals');

      final tokenDecimals = (decimals[0] as BigInt).toInt();
      final totalSupply = totalSupplyResult[0] as BigInt;
      final divisor = BigInt.from(10).pow(tokenDecimals);
      final formattedTotalSupply = totalSupply / divisor;

      print('totalSupply: ${totalSupplyResult[0]}');
      print('runtimeType: ${totalSupplyResult[0].runtimeType}');

      return '$formattedTotalSupply';
    } catch (e) {
      print('Error getting total supply: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> transferToken(String recipientAddress, double amount) async{
    if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
      throw Exception("Wallet not Connected");
    }

    try{

      _isLoading = true;
      notifyListeners();

      final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
      final abiData = jsonDecode(abiString);

      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(
            '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d'),
      );



      final chainID = appKitModal!.selectedChain!.chainId;
      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);

      final decimals = await appKitModal!.requestReadContract(
          topic: appKitModal!.session!.topic,
          chainId: chainID,
          deployedContract: tetherContract,
          functionName: 'decimals');


      final decimalUnits = (decimals.first as BigInt);
      final transferValue = _formatValue(amount, decimals: decimalUnits);
      final metaMaskUrl = Uri.parse(
        'metamask://dapp/exampleapp',
      );
      await launchUrl(metaMaskUrl,);

      await Future.delayed(const Duration(seconds: 2));

      final result = await appKitModal!.requestWriteContract(
          topic: appKitModal!.session!.topic,
          chainId: chainID,
          deployedContract: tetherContract,
          functionName: 'transfer',
          transaction: Transaction(
              from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!)
          ),
          parameters: [ EthereumAddress.fromHex(recipientAddress),transferValue,
          ]
      );

      print('Transfer Result: $result');
      print('runtimeType: ${result.runtimeType}');

      return result;

    }catch(e){
      print('Error Sending transferToken: $e');
      Fluttertoast.showToast(
          msg: "Error: ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      rethrow;
    }finally{
      _isLoading = false;
      notifyListeners();
    }

  }


  Future<String> buyECMWithETH( EtherAmount ethAmount, BuildContext context) async{
    if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
      throw Exception("Wallet not Connected");
    }

    try{
      _isLoading = true;
      notifyListeners();

      final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
      final abiData = jsonDecode(abiString);

      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(
            '0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
      );


      final chainID = appKitModal!.selectedChain!.chainId;
      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);

      const referrerAddress = "0x0000000000000000000000000000000000000000";


      final metaMaskUrl = Uri.parse('metamask://dapp/exampleapp',);
      await launchUrl(metaMaskUrl,);


      await Future.delayed(const Duration(seconds: 3));

      final result = await appKitModal!.requestWriteContract(
          topic: appKitModal!.session!.topic,
          chainId: chainID,
          deployedContract: tetherContract,
          functionName: 'buyECMWithETH',
          transaction: Transaction(
            from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!),
            value: ethAmount,
          ),
          parameters: [ EthereumAddress.fromHex(referrerAddress)]
      );

      print('Transaction Hash: $result');
      print('runtimeType: ${result.runtimeType}');
      print("ABI Functions: ${tetherContract.functions.map((f) => f.name).toList()}");

      Fluttertoast.showToast(
        msg: "Transaction sent successfully!",
        backgroundColor: Colors.green,
      );
      return result;

    }catch(e){
      print("Error buying ECM with ETH: $e");
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        backgroundColor: Colors.red,
      );
      rethrow;
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> buyECMWithUSDT( BigInt amount, BuildContext context) async{
    if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
      throw Exception("Wallet not Connected");
    }

    try{
      _isLoading = true;
      notifyListeners();

      final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
      final abiData = jsonDecode(abiString);

      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(
            '0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
      );


      final chainID = appKitModal!.selectedChain!.chainId;
      final nameSpace = ReownAppKitModalNetworks.getNamespaceForChainId(chainID);

      const referrerAddress = "0x0000000000000000000000000000000000000000";


      final metaMaskUrl = Uri.parse(
        'metamask://dapp/exampleapp',
      );
      await launchUrl(metaMaskUrl,);

      await Future.delayed(const Duration(seconds: 3));

      final result = await appKitModal!.requestWriteContract(
          topic: appKitModal!.session!.topic,
          chainId: chainID,
          deployedContract: tetherContract,
          functionName: 'buyECMWithUSDT',
          transaction: Transaction(
            from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!),
          ),

          parameters: [ amount,EthereumAddress.fromHex(referrerAddress)]
      );


      print('Transaction Hash: $result');
      print('runtimeType: ${result.runtimeType}');
      print("ABI Functions: ${tetherContract.functions.map((f) => f.name).toList()}");

      Fluttertoast.showToast(
        msg: "Transaction sent successfully!",
        backgroundColor: Colors.green,
      );
      return result;

    }catch(e){
      print("Error buying ECM with ETH: $e");
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        backgroundColor: Colors.red,
      );
      rethrow;
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> getTokenDecimals() async {
    final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
    final abiData = jsonDecode(abiString);

    final contract = DeployedContract(
      ContractAbi.fromJson(jsonEncode(abiData), 'eCommerce Coin'),
      EthereumAddress.fromHex('0x30C8E35377208ebe1b04f78B3008AAc408F00D1d'),
    );

    final decimalsResult = await appKitModal!.requestReadContract(
      deployedContract: contract,
      topic: appKitModal!.session!.topic,
      chainId: appKitModal!.selectedChain!.chainId,
      functionName: 'decimals',
    );

    return (decimalsResult[0] as BigInt).toInt();
  }

  Future<String> getMinimunStake() async {
    if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
      throw Exception("Wallet not Connected");
    }

    try {
      _isLoading = true;
      notifyListeners();

      final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
      final abiData = jsonDecode(abiString);
      final decimals = await getTokenDecimals();
      print("Decimals: $decimals");

      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(
            '0x0Bce6B3f0412c6650157DC0De959bf548F063833'),
      );

      final chainID = appKitModal!.selectedChain!.chainId;
      print("Chain ID : $chainID");



      final minimumStakeResult = await appKitModal!.requestReadContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: tetherContract,
        functionName: 'minimumStake',
      );

      final min = (minimumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
      _minimumStake = min.toDouble().toStringAsFixed(0);
      print("Raw minimumStakeResult: ${minimumStakeResult[0]}");

      notifyListeners();
      return _minimumStake!;

    } catch (e) {
      print('Error getting minimum stake: $e');
      _minimumStake = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getMaximumStake() async {
    if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
      throw Exception("Wallet not Connected");
    }

    try {
      _isLoading = true;
      notifyListeners();

      final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
      final abiData = jsonDecode(abiString);
      final decimals = await getTokenDecimals();
      print("Decimals: $decimals");

      final tetherContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(
            '0x0Bce6B3f0412c6650157DC0De959bf548F063833'),
      );

      final chainID = appKitModal!.selectedChain!.chainId;
      print("Chain ID : $chainID");



      final maximumStakeResult = await appKitModal!.requestReadContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: tetherContract,
        functionName: 'maximumStake',
      );

      final max = (maximumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
      _maximumStake = max.toDouble().toStringAsFixed(0);
      print("Raw maximumStakeResult: ${maximumStakeResult[0]}");

      notifyListeners();
      return _maximumStake!;

    } catch (e) {
      print('Error getting Maximum stake: $e');
      _maximumStake = null;
      rethrow;

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mock function to format decimal value to token unit (BigInt)
  BigInt _formatValue(double amount, {required BigInt decimals}) {
    final decimalPlaces = decimals.toInt(); // e.g., 6 for USDT, 18 for ETH
    final factor = BigInt.from(10).pow(decimalPlaces);
    return BigInt.from(amount * factor.toDouble());
  }


}






