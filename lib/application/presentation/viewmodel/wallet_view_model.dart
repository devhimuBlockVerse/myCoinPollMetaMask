import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';





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

        if(event != null){
          _isConnected = true;

          final chainId =  appKitModal!.selectedChain?.chainId;
          if(chainId != null){
            final namespace = ReownAppKitModalNetworks.getNamespaceForChainId(chainId);
            final updatedAddress = event.session.getAddress(namespace);

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
        print("Session expired: ${event.topic}");
        _isConnected = false;
        _walletAddress = '';
        await reset();
        notifyListeners();
      });
      appKitModal!.onSessionUpdateEvent.subscribe((event)async{
        print("Session Update : ${event.topic}");

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
          await getCurrentStageInfo();


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
  // Future<bool> connectWallet(BuildContext context) async {
  //
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     if (appKitModal == null){
  //       appKitModal = ReownAppKitModal(
  //         context: context,
  //         projectId:
  //         'f3d7c5a3be3446568bcc6bcc1fcc6389',
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
  //         enableAnalytics: true,
  //         featuresConfig: FeaturesConfig(
  //           email: true,
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
  //       // Open the modal view
  //       await appKitModal!.openModalView();
  //       notifyListeners();
  //     }else{
  //       await appKitModal!.openModalView();
  //       // notifyListeners();
  //     }
  //
  //     return _isConnected;
  //
  //    } catch (e) {
  //     print('Error connecting to wallet: $e');
  //     rethrow;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
  Future<bool> connectWallet(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (appKitModal == null) {
        await init(context); // Reusing init method
      }

      // Open the modal view if appKitModal is initialized
      await appKitModal?.openModalView();

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
      await reset();
      _isLoading = false;
      notifyListeners();
    }
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

  // Future<Map<String, dynamic>> getCurrentStageInfo() async{
  //
  //   try{
  //     _isLoading = true;
  //     notifyListeners();
  //
  //
  //      if (appKitModal == null || appKitModal!.session == null || appKitModal!.selectedChain == null) {
  //       print('getCurrentStageInfo failed: appKitModal, session, or selectedChain is null.');
  //        throw Exception("Wallet not fully connected or initialized.");
  //     }
  //
  //     final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
  //     final abiData = jsonDecode(abiString);
  //
  //     final stageContract = DeployedContract(
  //       ContractAbi.fromJson(
  //         jsonEncode(abiData),
  //         'eCommerce Coin',
  //       ),
  //       EthereumAddress.fromHex('0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
  //     );
  //
  //     final chainID = appKitModal!.selectedChain!.chainId;
  //
  //     print('Attempting to read contract:');
  //     print('  Chain ID: $chainID');
  //     print('  Contract Address: ${stageContract.address.hex}');
  //     print('  Function Name: currentStageInfo');
  //     print('  Session Topic: ${appKitModal!.session!.topic}');
  //
  //     final result = await appKitModal!.requestReadContract(
  //         topic: appKitModal!.session!.topic,
  //         chainId: chainID,
  //         deployedContract: stageContract,
  //         functionName: 'currentStageInfo',
  //
  //     );
  //
  //     if(result.isEmpty || result.length < 5){
  //       throw Exception("Unexpected response from contract");
  //     }
  //
  //
  //     final stageInfo = {
  //       'stageIndex': (result[0] as BigInt).toInt(),
  //       'target': (result[1] as BigInt) / BigInt.from(10).pow(18),
  //       'ethPrice': (result[2] as BigInt) / BigInt.from(10).pow(18),
  //       'usdtPrice': (result[3] as BigInt) / BigInt.from(10).pow(6),
  //       'ecmRefBonus': (result[4] as BigInt).toInt(),
  //       'paymentRefBonus': (result[5] as BigInt).toInt(),
  //       'ecmSold':  result[6] is BigInt ? (result[6] as BigInt)/ BigInt.from(10).pow(18) : result[6],
  //     'isCompleted': result[7] as bool,
  //     };
  //
  //
  //     print("Stage info successfully parsed:");
  //     stageInfo.forEach((key, value){
  //       print('$key: $value (Type: ${value.runtimeType})');
  //     });
  //
  //
  //
  //     return stageInfo ;
  //
  //   }catch(e){
  //     print('Error fetching stage info: $e');
  //     rethrow;
  //   }finally{
  //     _isLoading = false ;
  //     notifyListeners();
  //   }
  //
  // }

  Future<Map<String, dynamic>> getCurrentStageInfo() async {
    try {
      _isLoading = true;
      notifyListeners();

      if (appKitModal == null || appKitModal!.session == null || appKitModal!.selectedChain == null) {
        throw Exception("Wallet not connected or initialized.");
      }

      final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
      final abiData = jsonDecode(abiString);
      final stageContract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(abiData), 'ECMCoinICO'), // contract name from ABI
        EthereumAddress.fromHex('0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
      );
      final chainID = appKitModal!.selectedChain!.chainId;

      print('Attempting to read contract function: currentStageInfo');

      final result = await appKitModal!.requestReadContract(
        topic: appKitModal!.session!.topic,
        chainId: chainID,
        deployedContract: stageContract,
        functionName: 'currentStageInfo',
      );

      if (result.isEmpty || result.length < 8) {
        throw Exception("Unexpected or incomplete response from the contract.");
      }

      // Helper function for safe BigInt parsing
      BigInt _safeParseBigInt(dynamic value) {
        if (value is BigInt) {
          return value;
        }
        return BigInt.parse(value.toString());
      }

      final stageInfo = {
        'stageIndex': _safeParseBigInt(result[0]).toInt(),
        'target': _safeParseBigInt(result[1]) / BigInt.from(10).pow(18),
        'ethPrice': _safeParseBigInt(result[2]) / BigInt.from(10).pow(18),
        'usdtPrice': _safeParseBigInt(result[3]) / BigInt.from(10).pow(6),
        'ecmRefBonus': _safeParseBigInt(result[4]).toInt(),
        'paymentRefBonus': _safeParseBigInt(result[5]).toInt(),
        'ecmSold': _safeParseBigInt(result[6]) / BigInt.from(10).pow(18),
        'isCompleted': result[7] as bool,
      };

      print("Stage info successfully parsed:");
      stageInfo.forEach((key, value) {
        print('$key: $value (Type: ${value.runtimeType})');
      });

      return stageInfo;
    } catch (e,s) {
      print('--- ERROR FETCHING STAGE INFO ---');
      print('Exception details: ${e.toString()}'); // <-- ADD THIS LINE
      print('Stack Trace: ${s.toString()}');
      print('Error fetching stage info: $e');
      rethrow; // Rethrow to be caught by the UI
    } finally {
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


///
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
//    static const String INFURA_URL = "https://sepolia.infura.io/v3/b6521574dded4cc4b16f0975d484da49"; //  Infura URL
//
//   // Private helper for Web3Client instance
//   Web3Client? _publicWeb3Client;
//
//   // Function to get or create the public Web3Client
//   Web3Client _getPublicWeb3Client() {
//     _publicWeb3Client ??= Web3Client(INFURA_URL, Client());
//     return _publicWeb3Client!;
//   }
//
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
//           try{
//             final balance = await getBalance();
//             print("Updated new Balance : $balance");
//             await getMinimunStake();
//             await getMaximumStake();
//             await getCurrentStageInfo();
//
//           }catch(e){
//             print("Failed to refresh balance: $e");
//           }
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
//          print("Session Update : ${event.topic}");
//
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
//           print("onSessionUpdateEvent: Attempting to fetch connected wallet data...");
//
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
//     }else {
//       print("Init: Wallet was not previously connected or data was incomplete.");
//       _isConnected = false;
//       _walletAddress = '';
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   /// Connect the wallet using the ReownAppKitModal UI.
//     Future<bool> connectWallet(BuildContext context) async {
//      _isLoading = true;
//      notifyListeners();
//
//      try {
//         if (appKitModal == null) {
//          await init(context); // Reusing init method
//        }
//
//        // Open the modal view if appKitModal is initialized
//        await appKitModal?.openModalView();
//
//        return _isConnected;
//      } catch (e) {
//        print('Error connecting to wallet: $e');
//        return false;
//      } finally {
//        _isLoading = false;
//        notifyListeners();
//      }
//    }
//
//    /// Disconnect from the wallet and clear stored wallet info.
//   Future<void> disconnectWallet(BuildContext context) async {
//     if (appKitModal == null) return;
//     _isLoading = true;
//     notifyListeners();
//     try {
//        if (_isConnected && appKitModal!.session != null) {
//         await appKitModal!.disconnect();
//       }
//     } catch (e) {
//       print("Error during disconnect: $e");
//      } finally {
//        await reset();
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
//               topic: appKitModal!.session!.topic,
//               chainId: chainID,
//               deployedContract: tetherContract,
//               functionName: 'decimals');
//
//
//        print("Wallet address used: $walletAddress");
//
//       final balanceOf = await appKitModal!.requestReadContract(
//               topic: appKitModal!.session!.topic,
//               chainId: chainID,
//               deployedContract: tetherContract,
//               functionName: 'balanceOf',
//               parameters: [ EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!)]
//     );
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
//      if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
//       throw Exception("Wallet not Connected");
//     }
//
//     try{
//
//        _isLoading = true;
//        notifyListeners();
//
//     final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
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
//        final metaMaskUrl = Uri.parse(
//          'metamask://dapp/exampleapp',
//        );
//        await launchUrl(metaMaskUrl,);
//
//       await Future.delayed(const Duration(seconds: 2));
//
//       final result = await appKitModal!.requestWriteContract(
//           topic: appKitModal!.session!.topic,
//           chainId: chainID,
//           deployedContract: tetherContract,
//           functionName: 'transfer',
//           transaction: Transaction(
//             from: EthereumAddress.fromHex(appKitModal!.session!.getAddress(nameSpace)!)
//           ),
//         parameters: [ EthereumAddress.fromHex(recipientAddress),transferValue,
//         ]
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
//
//   Future<Map<String, dynamic>> fetchPublicStageInfo() async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//       final abiData = jsonDecode(abiString);
//       final stageContract = DeployedContract(
//         ContractAbi.fromJson(jsonEncode(abiData), 'ECMCoinICO'),
//         EthereumAddress.fromHex('0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
//       );
//
//       final Web3Client web3client = _getPublicWeb3Client(); //public client
//
//       final result = await web3client.call(
//         contract: stageContract,
//         function: stageContract.function('currentStageInfo'),
//         params: [],
//       );
//
//       BigInt _safeParse(dynamic value) => value is BigInt ? value : BigInt.parse(value.toString());
//
//       final stageInfo = {
//         // 'stageIndex': _safeParse(result[0]).toInt(),
//         // 'target': _safeParse(result[1]) / BigInt.from(10).pow(18),
//         'ethPrice': _safeParse(result[2]) / BigInt.from(10).pow(18),
//         'usdtPrice': _safeParse(result[3]) / BigInt.from(10).pow(6),
//         // 'ecmRefBonus': _safeParse(result[4]).toInt(),
//         // 'paymentRefBonus': _safeParse(result[5]).toInt(),
//         // 'ecmSold': _safeParse(result[6]) / BigInt.from(10).pow(18),
//         'isCompleted': result[7] as bool,
//       };
//       return stageInfo;
//     } catch (e, s) {
//       print("Error fetching stage info (public read): $e");
//       print("Stack: $s");
//       rethrow;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//   Future<Map<String, dynamic>> getCurrentStageInfo() async {
//     if (appKitModal == null || appKitModal!.selectedChain == null) {
//       throw Exception("Wallet not connected or chain not selected for currentStageInfo.");
//     }
//     final chainID = appKitModal!.selectedChain!.chainId;
//         final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//         final abiData = jsonDecode(abiString);
//         final stageContract = DeployedContract(
//           ContractAbi.fromJson(jsonEncode(abiData), 'ECMCoinICO'), // contract name from ABI
//           EthereumAddress.fromHex('0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
//         );
//
//         print('Attempting to read contract function: currentStageInfo');
//
//         final result = await appKitModal!.requestReadContract(
//           topic: appKitModal!.session!.topic,
//           chainId: chainID,
//           deployedContract: stageContract,
//           functionName: 'currentStageInfo',
//         );
//
//         if (result.isEmpty || result.length < 8) {
//           throw Exception("Unexpected or incomplete response from the contract.");
//         }
//
//         // Helper function for safe BigInt parsing
//         BigInt _safeParseBigInt(dynamic value) {
//           if (value is BigInt) {
//             return value;
//           }
//           return BigInt.parse(value.toString());
//         }
//
//         final stageInfo = {
//           'stageIndex': _safeParseBigInt(result[0]).toInt(),
//           'target': _safeParseBigInt(result[1]) / BigInt.from(10).pow(18),
//           'ethPrice': _safeParseBigInt(result[2]) / BigInt.from(10).pow(18),
//           'usdtPrice': _safeParseBigInt(result[3]) / BigInt.from(10).pow(6),
//           'ecmRefBonus': _safeParseBigInt(result[4]).toInt(),
//           'paymentRefBonus': _safeParseBigInt(result[5]).toInt(),
//           'ecmSold': _safeParseBigInt(result[6]) / BigInt.from(10).pow(18),
//           'isCompleted': result[7] as bool,
//         };
//
//         print("Stage info successfully parsed:");
//         stageInfo.forEach((key, value) {
//           print('$key: $value (Type: ${value.runtimeType})');
//         });
//
//     return stageInfo;
//   }
//   // Future<Map<String, dynamic>> getCurrentStageInfo() async {
//   //   try {
//   //     _isLoading = true;
//   //     notifyListeners();
//   //
//   //     if (appKitModal == null || appKitModal!.session == null) {
//   //        throw Exception("Wallet not connected or session is invalid.");
//   //     }
//   //      if (appKitModal!.selectedChain == null) {
//   //       print("DEBUG: appKitModal!.selectedChain is null in getCurrentStageInfo.");
//   //       throw Exception("No selected chain found. Wallet might be connected but chain not active.");
//   //     }
//   //
//   //     final chainID = appKitModal!.selectedChain!.chainId;
//   //
//   //     final abiString = await rootBundle.loadString("assets/abi/SaleContractABI.json");
//   //     final abiData = jsonDecode(abiString);
//   //     final stageContract = DeployedContract(
//   //       ContractAbi.fromJson(jsonEncode(abiData), 'ECMCoinICO'), // contract name from ABI
//   //       EthereumAddress.fromHex('0x02f2aA15675aED44A117aC0c55E795Be9908543D'),
//   //     );
//   //
//   //     print('Attempting to read contract function: currentStageInfo');
//   //
//   //     final result = await appKitModal!.requestReadContract(
//   //       topic: appKitModal!.session!.topic,
//   //       chainId: chainID,
//   //       deployedContract: stageContract,
//   //       functionName: 'currentStageInfo',
//   //     );
//   //
//   //     if (result.isEmpty || result.length < 8) {
//   //       throw Exception("Unexpected or incomplete response from the contract.");
//   //     }
//   //
//   //     // Helper function for safe BigInt parsing
//   //     BigInt _safeParseBigInt(dynamic value) {
//   //       if (value is BigInt) {
//   //         return value;
//   //       }
//   //       return BigInt.parse(value.toString());
//   //     }
//   //
//   //     final stageInfo = {
//   //       'stageIndex': _safeParseBigInt(result[0]).toInt(),
//   //       'target': _safeParseBigInt(result[1]) / BigInt.from(10).pow(18),
//   //       'ethPrice': _safeParseBigInt(result[2]) / BigInt.from(10).pow(18),
//   //       'usdtPrice': _safeParseBigInt(result[3]) / BigInt.from(10).pow(6),
//   //       'ecmRefBonus': _safeParseBigInt(result[4]).toInt(),
//   //       'paymentRefBonus': _safeParseBigInt(result[5]).toInt(),
//   //       'ecmSold': _safeParseBigInt(result[6]) / BigInt.from(10).pow(18),
//   //       'isCompleted': result[7] as bool,
//   //     };
//   //
//   //     print("Stage info successfully parsed:");
//   //     stageInfo.forEach((key, value) {
//   //       print('$key: $value (Type: ${value.runtimeType})');
//   //     });
//   //
//   //     return stageInfo;
//   //   } catch (e,s) {
//   //     print('--- ERROR FETCHING STAGE INFO ---');
//   //     print('Exception details: ${e.toString()}');
//   //     print('Stack Trace: ${s.toString()}');
//   //     print('Error fetching stage info: $e');
//   //     rethrow; // Rethrow to be caught by the UI
//   //   } finally {
//   //     _isLoading = false;
//   //     notifyListeners();
//   //   }
//   // }
//
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
//        await Future.delayed(const Duration(seconds: 3));
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
//             ),
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
//      final abiString = await rootBundle.loadString("assets/abi/MyContract.json");
//      final abiData = jsonDecode(abiString);
//
//      final contract = DeployedContract(
//        ContractAbi.fromJson(jsonEncode(abiData), 'eCommerce Coin'),
//        EthereumAddress.fromHex('0x30C8E35377208ebe1b04f78B3008AAc408F00D1d'),
//      );
//
//      final decimalsResult = await appKitModal!.requestReadContract(
//        deployedContract: contract,
//        topic: appKitModal!.session!.topic,
//        chainId: appKitModal!.selectedChain!.chainId,
//        functionName: 'decimals',
//      );
//
//      return (decimalsResult[0] as BigInt).toInt();
//    }
//
//   Future<String> getMinimunStake() async {
//      if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
//        throw Exception("Wallet not Connected");
//      }
//
//      try {
//        _isLoading = true;
//        notifyListeners();
//
//        final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//        final abiData = jsonDecode(abiString);
//        final decimals = await getTokenDecimals();
//        print("Decimals: $decimals");
//
//        final tetherContract = DeployedContract(
//          ContractAbi.fromJson(
//            jsonEncode(abiData),
//            'eCommerce Coin',
//          ),
//          EthereumAddress.fromHex(
//              '0x0Bce6B3f0412c6650157DC0De959bf548F063833'),
//        );
//
//        final chainID = appKitModal!.selectedChain!.chainId;
//        print("Chain ID : $chainID");
//
//
//
//        final minimumStakeResult = await appKitModal!.requestReadContract(
//            topic: appKitModal!.session!.topic,
//            chainId: chainID,
//            deployedContract: tetherContract,
//            functionName: 'minimumStake',
//         );
//
//        final min = (minimumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
//        _minimumStake = min.toDouble().toStringAsFixed(0);
//        print("Raw minimumStakeResult: ${minimumStakeResult[0]}");
//
//        notifyListeners();
//        return _minimumStake!;
//
//      } catch (e) {
//        print('Error getting minimum stake: $e');
//        _minimumStake = null;
//        rethrow;
//      } finally {
//        _isLoading = false;
//        notifyListeners();
//      }
//    }
//
//   Future<String> getMaximumStake() async {
//      if (appKitModal == null || !_isConnected || appKitModal!.session == null) {
//        throw Exception("Wallet not Connected");
//      }
//
//      try {
//        _isLoading = true;
//        notifyListeners();
//
//        final abiString = await rootBundle.loadString("assets/abi/ECMStakingContractABI.json");
//        final abiData = jsonDecode(abiString);
//        final decimals = await getTokenDecimals();
//        print("Decimals: $decimals");
//
//        final tetherContract = DeployedContract(
//          ContractAbi.fromJson(
//            jsonEncode(abiData),
//            'eCommerce Coin',
//          ),
//          EthereumAddress.fromHex(
//              '0x0Bce6B3f0412c6650157DC0De959bf548F063833'),
//        );
//
//        final chainID = appKitModal!.selectedChain!.chainId;
//        print("Chain ID : $chainID");
//
//
//
//        final maximumStakeResult = await appKitModal!.requestReadContract(
//            topic: appKitModal!.session!.topic,
//            chainId: chainID,
//            deployedContract: tetherContract,
//            functionName: 'maximumStake',
//         );
//
//        final max = (maximumStakeResult[0] as BigInt) / BigInt.from(10).pow(decimals);
//        _maximumStake = max.toDouble().toStringAsFixed(0);
//        print("Raw maximumStakeResult: ${maximumStakeResult[0]}");
//
//        notifyListeners();
//        return _maximumStake!;
//
//      } catch (e) {
//        print('Error getting Maximum stake: $e');
//        _maximumStake = null;
//        rethrow;
//
//      } finally {
//        _isLoading = false;
//        notifyListeners();
//      }
//    }
//
//
//
//   @override
//   void dispose() {
//     // Close the public Web3Client when the ViewModel is disposed
//     _publicWeb3Client?.dispose();
//     super.dispose();
//   }
//
//
//
//    /// Mock function to format decimal value to token unit (BigInt)
//   BigInt _formatValue(double amount, {required BigInt decimals}) {
//     final decimalPlaces = decimals.toInt(); // e.g., 6 for USDT, 18 for ETH
//     final factor = BigInt.from(10).pow(decimalPlaces);
//     return BigInt.from(amount * factor.toDouble());
//   }
//
//
//
// }





