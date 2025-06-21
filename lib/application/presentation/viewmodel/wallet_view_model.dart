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


/// Beta
// class WalletViewModel extends ChangeNotifier with WidgetsBindingObserver{
//   ReownAppKitModal? appKitModal;
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
//    Web3Client? _web3Client;
//   bool _isModalEventsSubscribed = false;
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
//
//   static const String ALCHEMY_URL = "https://eth-sepolia.g.alchemy.com/v2/FPbP1-XUOoRxMpYioocm5i4rdPSJSGKU";
//    static const String SALE_CONTRACT_ADDRESS = '0x02f2aA15675aED44A117aC0c55E795Be9908543D';
//   static const String ECM_TOKEN_CONTRACT_ADDRESS = '0x30C8E35377208ebe1b04f78B3008AAc408F00D1d';
//   static const String STAKING_CONTRACT_ADDRESS = '0x0Bce6B3f0412c6650157DC0De959bf548F063833';
//
//   WalletViewModel() {
//      _web3Client = Web3Client(ALCHEMY_URL, Client());
//      WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     _web3Client?.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//     // Unsubscribe all events when disposing to prevent memory leaks
//     appKitModal?.onModalConnect.unsubscribeAll();
//     appKitModal?.onModalUpdate.unsubscribeAll();
//     appKitModal?.onModalDisconnect.unsubscribeAll();
//     appKitModal?.onSessionExpireEvent.unsubscribeAll();
//     appKitModal?.onSessionUpdateEvent.unsubscribeAll();
//      super.dispose();
//   }
//
//
//
//    @override
//   Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//     if (state == AppLifecycleState.resumed) {
//       print("App resumed from background. Checking wallet connection status.");
//       if (appKitModal != null) {
//         print("Attempting to re-initialize AppKitModal session.");
//         try {
//           await appKitModal?.init();
//
//            if (appKitModal!.session != null && appKitModal!.selectedChain != null) {
//             final chainId = appKitModal!.selectedChain!.chainId;
//             final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//             _walletAddress = appKitModal!.session!.getAddress(namespace)!;
//             _isConnected = true; // Mark as connected if session and chain are present
//             print("Wallet successfully re-connected on resume. Wallet Address: $_walletAddress");
//
//              await fetchConnectedWalletData(isReconnecting: true);
//             await getCurrentStageInfo();
//           } else {
//             // If session or selectedChain is not available after init,
//             // check if it was previously connected and clear state if necessary.
//             final prefs = await SharedPreferences.getInstance();
//             final wasConnectedInPrefs = prefs.getBool('isConnected') ?? false;
//
//             if (wasConnectedInPrefs) {
//               print("App resumed: Session not active after re-initialization despite prior connection. Clearing state.");
//               await _clearWalletAndStageInfo(shouldNotify: true);
//             } else {
//               print("App resumed: Wallet was not connected, and session is still not active after re-initialization. No action needed.");
//             }
//           }
//         } catch (e, stack) {
//           // Catch any exception during re-initialization or data fetching
//           print("Error during app resume processing: $e");
//           print("Stack trace: $stack");
//           await _clearWalletAndStageInfo(shouldNotify: true);
//         } finally {
//           notifyListeners();
//         }
//       } else {
//         print("App resumed, but AppKitModal is not initialized. Cannot re-connect.");
//       }
//     }
//   }
//
//   Future<void> init(BuildContext context) async {
//
//     if (_isLoading) return;
//
//     _isLoading = true;
//     notifyListeners();
//
//
//     if (appKitModal == null) {
//       appKitModal = ReownAppKitModal(
//         context: context,
//         projectId: 'f3d7c5a3be3446568bcc6bcc1fcc6389',
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
//
//         await appKitModal?.init();
//
//          if (appKitModal != null && !_isModalEventsSubscribed) {
//           final prefs = await SharedPreferences.getInstance();
//           _subscribeToModalEvents(prefs);
//           _isModalEventsSubscribed = true;
//         }
//
//       } catch (e) {
//         print("Error initializing ReownAppKitModal: $e");
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }
//     }else{
//       if (!_isModalEventsSubscribed) {
//         final prefs = await SharedPreferences.getInstance();
//         _subscribeToModalEvents(prefs);
//         _isModalEventsSubscribed = true;
//       }
//     }
//
//     await getCurrentStageInfo();
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   void _subscribeToModalEvents(SharedPreferences prefs) {
//
//     appKitModal!.onModalConnect.unsubscribeAll();
//     appKitModal!.onModalUpdate.unsubscribeAll();
//     appKitModal!.onModalDisconnect.unsubscribeAll();
//     appKitModal!.onSessionExpireEvent.unsubscribeAll();
//     appKitModal!.onSessionUpdateEvent.unsubscribeAll();
//
//     appKitModal!.onModalConnect.subscribe((session) async {
//       _isConnected = true;
//       if (appKitModal!.session != null && appKitModal!.selectedChain != null) {
//         final chainId = appKitModal!.selectedChain!.chainId;
//         print("Chain ID: $chainId");
//         final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
//         _walletAddress = appKitModal!.session!.getAddress(namespace)!;
//         await prefs.setBool('isConnected', true);
//         await prefs.setString('walletAddress', _walletAddress);
//         await prefs.setInt('chainId', int.parse(chainId));
//
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
//   Future<bool> connectWallet(BuildContext context) async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       if (appKitModal == null) {
//         await init(context);
//       }
//       await appKitModal?.openModalView();
//
//
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
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
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
//     _usdtPrice = 0.0;
//     _stageIndex = 0;
//     _currentECM = 0.0;
//     _maxECM = 0.0;
//     _ecmRefBonus = 0;
//     _paymentRefBonus = 0;
//     _isCompleted = false;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
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
//       // If the address is gone, assume a broader disconnection and clear more state.
//       await _clearWalletAndStageInfo(shouldNotify: !isReconnecting);
//       return;
//     }
//
//     // Update _walletAddress to reflect the *actual* address from the live session
//     // This is important as _walletAddress is used by UI and other functions.
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
//       // If fetching fails, clear wallet-specific info to avoid displaying stale/incorrect data.
//       _clearWalletSpecificInfo(shouldNotify: true);
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
//       // If fetching fails, clear existing stage info to reflect no data
//       _clearStageInfoOnly(shouldNotify: true); // Ensure notifyListeners is called if clear
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners(); // Notify listeners after fetching is done, or if an error occurs
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
//     // Only update connected-specific info if connected
//     if (isConnected) {
//       _stageIndex = _safeParseBigInt(result[0]).toInt();
//       _maxECM = (_safeParseBigInt(result[1]).toDouble() / 1e18);
//       _ecmRefBonus = _safeParseBigInt(result[4]).toInt();
//       _paymentRefBonus = _safeParseBigInt(result[5]).toInt();
//       _currentECM = (_safeParseBigInt(result[6]).toDouble() / 1e18);
//       _isCompleted = result[7] as bool;
//     } else {
//       // Clear connected-specific info if not connected
//       _stageIndex = 0;
//       _maxECM = 0.0;
//       _ecmRefBonus = 0;
//       _paymentRefBonus = 0;
//       _currentECM = 0.0;
//       _isCompleted = false;
//     }
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
//   // Helper to clear only stage-related info without affecting connection
//   void _clearStageInfoOnly({bool shouldNotify = true}) {
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
//   // Helper to clear only connected wallet specific info (not prices/stage info)
//   void _clearWalletSpecificInfo({bool shouldNotify = true}) {
//     _balance = null;
//     _minimumStake = null;
//     _maximumStake = null;
//     if (shouldNotify) {
//       notifyListeners();
//     }
//   }
//
//   Future<String> getBalance() async {
//     // No _isLoading and notifyListeners here if called by fetchConnectedWalletData
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
//     // No _isLoading and notifyListeners here if called by a parent function
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
//     // No _isLoading and notifyListeners here if called by fetchConnectedWalletData
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final decimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS); // Use ECM token decimals for staking amounts
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
//     // No _isLoading and notifyListeners here if called by fetchConnectedWalletData
//     try {
//       final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final decimals = await getTokenDecimals(contractAddress: ECM_TOKEN_CONTRACT_ADDRESS); // Use ECM token decimals for staking amounts
//       print("Decimals for staking: $decimals");
//
//       final stakingContract = DeployedContract(
//         ContractAbi.fromJson(
//           jsonEncode(abiData),
//           'eCommerce Coin', // Assuming this is the contract name in ABI for staking
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
//       await launchUrl(metaMaskUrl, mode: LaunchMode.externalApplication); // Use externalApplication for MetaMask
//
//       // No Future.delayed here. Rely on requestWriteContract to await user interaction.
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
//       print('runtimeType: ${result.runtimeType}');
//       Fluttertoast.showToast(
//         msg: "Transaction sent successfully!",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//
//       await fetchConnectedWalletData();
//       await getCurrentStageInfo();
//
//       return result;
//     } catch (e) {
//       print('Error Sending transferToken: $e');
//       Fluttertoast.showToast(
//         msg: "Error: ${e.toString()}",
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 3,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
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
//       Fluttertoast.showToast(
//         msg: "Transaction sent successfully!",
//         backgroundColor: Colors.green,
//       );
//       await fetchConnectedWalletData();
//       await getCurrentStageInfo();
//       return result;
//     } catch (e) {
//       print("Error buying ECM with ETH: $e");
//       Fluttertoast.showToast(
//         msg: "Error: ${e.toString()}",
//         backgroundColor: Colors.red,
//       );
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
//       Fluttertoast.showToast(
//         msg: "Transaction sent successfully!",
//         backgroundColor: Colors.green,
//       );
//       await fetchConnectedWalletData();
//       await getCurrentStageInfo();
//       return result;
//     } catch (e) {
//       print("Error buying ECM with USDT: $e");
//       Fluttertoast.showToast(
//         msg: "Error: ${e.toString()}",
//         backgroundColor: Colors.red,
//       );
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


      try {

        await appKitModal?.init();

         if (appKitModal != null && !_isModalEventsSubscribed) {
          final prefs = await SharedPreferences.getInstance();
          _subscribeToModalEvents(prefs);
          _isModalEventsSubscribed = true;
        }

      } catch (e) {
        print("Error initializing ReownAppKitModal: $e");
        _isLoading = false;
        notifyListeners();
        return;
      }
    }else{
      if (!_isModalEventsSubscribed) {
        final prefs = await SharedPreferences.getInstance();
        _subscribeToModalEvents(prefs);
        _isModalEventsSubscribed = true;
      }
    }

    await getCurrentStageInfo();
    _isLoading = false;
    notifyListeners();
  }

  void _subscribeToModalEvents(SharedPreferences prefs) {

    appKitModal!.onModalConnect.unsubscribeAll();
    appKitModal!.onModalUpdate.unsubscribeAll();
    appKitModal!.onModalDisconnect.unsubscribeAll();
    appKitModal!.onSessionExpireEvent.unsubscribeAll();
    appKitModal!.onSessionUpdateEvent.unsubscribeAll();

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
    _isLoading = true;
    notifyListeners();
    try {
      if (appKitModal == null) {
        await init(context);
      }else{
        appKitModal!.updateContext(context);
      }
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
  Future<void> forceReinitModal(BuildContext context) async {
     try {
      // If the modal has a dispose method, call it (if not, just set to null)
      await appKitModal?.dispose();
    } catch (e) {
      print("Error disposing previous AppKitModal: $e");
    }
    appKitModal = null;
    _isModalEventsSubscribed = false;
    _isConnected = false;
    _walletAddress = '';
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

    // Optionally clear SharedPreferences if you want a full reset
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print("Error clearing SharedPreferences: $e");
    }

    notifyListeners();

    // Re-initialize the modal as if the app just started
    await init(context);
  }
  Future<void> recoverWallet(BuildContext context) async {
    // 1. Dispose and nullify the modal
    try {
      await appKitModal?.dispose();
    } catch (_) {}
    appKitModal = null;
    _isModalEventsSubscribed = false;

    // 2. Clear all wallet state
    await _clearWalletAndStageInfo();

    // 3. Re-initialize the modal
    await init(context);

    // 4. Prompt user to reconnect
    await connectWallet(context);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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

    // Only update connected-specific info if connected
    // if (isConnected) {
      _stageIndex = _safeParseBigInt(result[0]).toInt();
      _maxECM = (_safeParseBigInt(result[1]).toDouble() / 1e18);
      _ecmRefBonus = _safeParseBigInt(result[4]).toInt();
      _paymentRefBonus = _safeParseBigInt(result[5]).toInt();
      _currentECM = (_safeParseBigInt(result[6]).toDouble() / 1e18);
      _isCompleted = result[7] as bool;
    // } else {
      // Clear connected-specific info if not connected
      // _stageIndex = 0;
      // _maxECM = 0.0;
      // _ecmRefBonus = 0;
      // _paymentRefBonus = 0;
      // _currentECM = 0.0;
      // _isCompleted = false;
    // }

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
      Fluttertoast.showToast(
        msg: "Transaction sent successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      await fetchConnectedWalletData();
      await getCurrentStageInfo();

      return result;
    } catch (e) {
      print('Error Sending transferToken: $e');
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
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
      // Fluttertoast.showToast(
      //   msg: "Transaction sent successfully!",
      //   backgroundColor: Colors.green,
      // );
      await fetchConnectedWalletData();
      await getCurrentStageInfo();
      return result;
    } catch (e) {
      print("Error buying ECM with ETH: $e");
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        backgroundColor: Colors.red,
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
      // Fluttertoast.showToast(
      //   msg: "Transaction sent successfully!",
      //   backgroundColor: Colors.green,
      // );
      await fetchConnectedWalletData();
      await getCurrentStageInfo();
      return result;
    } catch (e) {
      print("Error buying ECM with USDT: $e");
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        backgroundColor: Colors.red,
      );
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

