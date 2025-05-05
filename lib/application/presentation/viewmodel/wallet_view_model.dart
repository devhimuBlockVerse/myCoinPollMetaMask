import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../framework/utils/routes/route_names.dart';

class WalletViewModel extends ChangeNotifier {
   ReownAppKitModal? appKitModal;
  String _walletAddress = '';
  bool _isLoading = false;
  bool _isConnected = false;

  String? _balance;
  String? _minimumStake;
  String? _maximumStake;




  String? get balance => _balance;
  String? get minimumStake => _minimumStake;
  String? get maximumStake => _maximumStake;
  String get walletAddress => _walletAddress;
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;

  Future<void> init(BuildContext context) async {

    _isLoading = true;
    notifyListeners();


    final prefs = await SharedPreferences.getInstance();
    final wasConnected =  prefs.getBool('isConnected') ?? false;
    final savedWallet = prefs.getString('walletAddress');
    final savedChainId = prefs.getInt('chainId');


    if (appKitModal == null){
      appKitModal = ReownAppKitModal(
        context: context,
        projectId:
        'f3d7c5a3be3446568bcc6bcc1fcc6389',
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
        enableAnalytics: true,
        featuresConfig: FeaturesConfig(
          email: true,
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
      appKitModal!.onModalConnect.subscribe((session)async {
        _isConnected = true;
        if (appKitModal!.session != null && appKitModal!.selectedChain != null) {
          final chainId = appKitModal!.selectedChain!.chainId;
          print("Chain ID: $chainId");
          final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
          _walletAddress = appKitModal!.session!.getAddress(namespace)!;
          await prefs.setBool('isConnected', true);
          await prefs.setString('walletAddress', _walletAddress);
          await prefs.setInt('chainId', int.parse(chainId));
        }
        notifyListeners();
      });
      appKitModal!.onModalUpdate.subscribe((ModalConnect? event){
        print("Modal Update ; ${event.toString()}");

        if(event != null && event.session != null){
          _isConnected = true;

          final chainId =  appKitModal!.selectedChain?.chainId;
          if(chainId != null){
            final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
            final updatedAddress = event.session!.getAddress(namespace);

            if(updatedAddress != null && updatedAddress != _walletAddress){
              _walletAddress = updatedAddress;
              print("Modal Update - New Wallet Address: $_walletAddress");

            }
          }
        }else{
          _isConnected = false;
          _walletAddress = '';
          print("Modal Update - Session cleared or null");

        }

        notifyListeners();
      });
      appKitModal!.onModalDisconnect.subscribe((_)async {
        _isConnected = false;
        _walletAddress = '';
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        await reset();
        notifyListeners();
      });
      appKitModal!.onSessionExpireEvent.subscribe((event)async{
        print("Session expired: ${event?.topic}");
        _isConnected = false;
        _walletAddress = '';
        await reset();
        notifyListeners();
      });
      appKitModal!.onSessionUpdateEvent.subscribe((event)async{
        print("Session Update : ${event?.topic}");

        final chainId = appKitModal!.selectedChain!.chainId;
        final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
        final updateAddress = appKitModal!.session!.getAddress(namespace)!;

        if(appKitModal!.session != null && updateAddress != _walletAddress ){
          _walletAddress = updateAddress;
          print("Updated New Wallet Address: $_walletAddress");
        }

        try{
          final balance = await getBalance();
          print("Updated new Balance : $balance");
          await getMinimunStake();
          await getMaximumStake();


        }catch(e){
          print("Failed to refresh balance: $e");
        }

        _isConnected= true;
        notifyListeners();

      });
    }

    if (wasConnected && savedWallet != null && savedChainId != null) {
      _isConnected = true;
      _walletAddress = savedWallet;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Connect the wallet using the ReownAppKitModal UI.
  Future<bool> connectWallet(BuildContext context) async {

    _isLoading = true;
    notifyListeners();

    try {
      if (appKitModal == null){
        appKitModal = ReownAppKitModal(
          context: context,
          projectId:
          'f3d7c5a3be3446568bcc6bcc1fcc6389',
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
          enableAnalytics: true,
          featuresConfig: FeaturesConfig(
            email: true,
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
        // Open the modal view
        await appKitModal!.openModalView();
        notifyListeners();
      }else{
        await appKitModal!.openModalView();
        // notifyListeners();
      }

      return _isConnected;

     } catch (e) {
      print('Error connecting to wallet: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Disconnect from the wallet and clear stored wallet info.
  Future<void> disconnectWallet(BuildContext context) async {
    if (!_isConnected || appKitModal == null) return;

    try {
      await appKitModal!.disconnect();
      await reset();
      // await init(context);
      //  final prefs = await SharedPreferences.getInstance();
      // await prefs.clear();

    } catch (e) {
      print('Error disconnecting wallet: $e');
      rethrow;
    } finally {
      await reset();
      _isLoading = false;

      notifyListeners();
    }
  }

   Future<bool> reset() async{

     // Clear all appKitModal listeners safely
     if (appKitModal != null) {
       appKitModal!.onModalConnect.unsubscribeAll();
       appKitModal!.onModalDisconnect.unsubscribeAll();
       appKitModal!.onModalUpdate.unsubscribeAll();
       appKitModal!.onSessionExpireEvent.unsubscribeAll();
       appKitModal!.onSessionUpdateEvent.unsubscribeAll();
     }

     // Clear appKitModal instance
     appKitModal = null;
     // Clear wallet state
     _walletAddress = '';
     _isLoading = false;
     _isConnected = false;



     final SharedPreferences sp = await SharedPreferences.getInstance();
     sp.remove('isConnected');
     sp.remove('walletAddress');
     sp.remove('chainId');

     notifyListeners();
     return true;

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

      await Future.delayed(Duration(seconds: 2));

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

  Future<Map<String, dynamic>> getCurrentStageInfo() async{

    try{
      _isLoading = true;
      notifyListeners();


      final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
      final abiData = jsonDecode(abiString);

      final stageContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(abiData),
          'eCommerce Coin',
        ),
        EthereumAddress.fromHex(
            '0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
      );

      final chainID = appKitModal!.selectedChain!.chainId;


      final result = await appKitModal!.requestReadContract(
          topic: appKitModal!.session!.topic,
          chainId: chainID,
          deployedContract: stageContract,
          functionName: 'currentStageInfo',

      );

      if(result.isEmpty || result.length < 5){
        throw Exception("Unexpected response from contract");
      }


      final stageInfo = {
        'stageIndex': (result[0] as BigInt).toInt(),
        'target': (result[1] as BigInt) / BigInt.from(10).pow(18),
        'ethPrice': (result[2] as BigInt) / BigInt.from(10).pow(18),
        'usdtPrice': (result[3] as BigInt) / BigInt.from(10).pow(6),
        'ecmRefBonus': (result[4] as BigInt).toInt(),
        'paymentRefBonus': (result[5] as BigInt).toInt(),
        'ecmSold':  result[6] is BigInt ? (result[6] as BigInt)/ BigInt.from(10).pow(18) : result[6],
      'isCompleted': result[7] as bool,
      };

      print("Stage info:");

      stageInfo.forEach((key, value){
        print('$key: $value');
      });


      return stageInfo ;

    }catch(e){
      print('Error fetching stage info: $e');
      rethrow;
    }finally{
      _isLoading = false ;
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

      final referrerAddress = "0x0000000000000000000000000000000000000000";


      final metaMaskUrl = Uri.parse('metamask://dapp/exampleapp',);
      await launchUrl(metaMaskUrl,);


       await Future.delayed(Duration(seconds: 3));

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

      final referrerAddress = "0x0000000000000000000000000000000000000000";


      final metaMaskUrl = Uri.parse(
        'metamask://dapp/exampleapp',
      );
      await launchUrl(metaMaskUrl,);

      await Future.delayed(Duration(seconds: 3));

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
