import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../framework/components/AddressFieldComponent.dart';
import '../../../framework/components/buy_ecm_button.dart';
import '../../../framework/components/customInputField.dart';
import '../../../framework/components/custonButton.dart';
import '../../../framework/components/disconnectButton.dart';
import '../../../framework/components/loader.dart';
import '../../../framework/utils/routes/route_names.dart';
import '../viewmodel/wallet_view_model.dart';
import 'dashboard.dart';




class DigitalModelScreen extends StatefulWidget {
  const DigitalModelScreen({super.key});

  @override
  State<DigitalModelScreen> createState() =>
      _DigitalModelScreenState();
}

class _DigitalModelScreenState extends State<DigitalModelScreen> {

  final usdtController = TextEditingController();
  final ecmController = TextEditingController();
  final readingMoreController = TextEditingController();
  final referredController = TextEditingController();
  final String defaultReferrerAddress = '0x0000000000000000000000000000000000000000';

  bool isETHActive = true;
  bool isUSDTActive = false;

  double _ethPrice = 0.0;
  double _usdtPrice = 0.0;

  int  _stageIndex = 0;
  double _currentECM = 0.0;
  double _maxECM = 0.0;
  bool isDisconnecting = false;




  @override
  void initState() {
     super.initState();
     ecmController.addListener(_updatePayableAmount);

     WidgetsBinding.instance.addPostFrameCallback((_) async {
       final walletVM = Provider.of<WalletViewModel>(context, listen: false);

       try {
         final stageInfo = await walletVM.getCurrentStageInfo();
         final ethPrice = stageInfo['ethPrice'];
         final usdtPrice = stageInfo['usdtPrice'];
         final currentECM = stageInfo['ecmSold'];
         final maxECM = stageInfo['target'];
         final stageIndex = stageInfo['stageIndex'];

         setState(() {
           _stageIndex = stageIndex;
           _currentECM = currentECM;
           _maxECM = maxECM;
           _ethPrice = ethPrice;
           _usdtPrice = usdtPrice;

         });
       } catch (e) {
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Failed to fetch stage info: ${e.toString()}'),
               backgroundColor: Colors.red,
             ),
           );
         }
       }
     });
  }

  void _updatePayableAmount() {
    final ecmAmount = double.tryParse(ecmController.text) ?? 0.0;
    double result = isETHActive ? ecmAmount * _ethPrice : ecmAmount * _usdtPrice;

    // Display converted amount in the usdtController
    usdtController.text =  isETHActive ? result.toStringAsFixed(5) : result.toStringAsFixed(1);

  }

  @override
  void dispose() {
    ecmController.removeListener(_updatePayableAmount);
    ecmController.dispose();
    usdtController.dispose();
    readingMoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenSize.height > screenSize.width;
    final double textScale = isPortrait ? screenWidth / 400 : screenHeight / 400;
    final double paddingScale = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Color(0xFF0A1C2F),
       body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0x4d03080e),
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.centerRight,
          //   colors: [
          //     Color(0xFF0A1C2F),
          //     Color(0xFF060D13),
          //   ],
          // ),

        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                // padding: const EdgeInsets.all(16.0),
                padding: EdgeInsets.symmetric(
                    horizontal: paddingScale,
                    vertical: paddingScale),

                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    // width: screenWidth * 0.92,
                    width: screenWidth ,
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(

                      image:const DecorationImage(
                        image: AssetImage('assets/icons/buyEcmContainerImage.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    child: Consumer<WalletViewModel>(builder: (context, walletVM, child) {

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 8),

                              ECMProgressIndicator(
                                stageIndex: _stageIndex,
                                  currentECM: _currentECM,
                                  maxECM: _maxECM,
                              ),
                              const SizedBox(
                                  height: 1),

                              const Divider(
                                color: Colors
                                    .white12,
                                thickness: 2,
                                height: 20,
                              ),
                              const SizedBox(
                                  height: 3),
                              // const SizedBox(height: 8),
                              if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
                                CustomLabeledInputField(
                                // labelText: '',
                                labelText: 'Your Address:',
                                hintText: '${walletVM.walletAddress}',
                                controller: readingMoreController,
                                isReadOnly: true,
                              ),
                              const SizedBox(height: 3),

                              if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
                                CustomLabeledInputField(
                                labelText: 'Referred By:',
                                hintText: 'Show and Enter Referred id..',
                                controller: referredController,
                                isReadOnly:
                                    false, // or false
                              ),

                              const SizedBox(height: 3),

                              const Divider(
                                color: Colors.white12,
                                thickness: 2,
                                height: 20,
                              ),
                              const SizedBox(height: 8),

                              Text(
                                'ICO is Live',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Oxanium',
                                  height: 1.07,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 14),

                              ///Action Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  //Buy with ETH Button
                                  Expanded(
                                    child: CustomButton(
                                      text: 'Buy with ETH',
                                      icon: 'assets/icons/eth.png',
                                      isActive: isETHActive,
                                      onPressed: ()async {
                                        try {
                                          final stageInfo = await walletVM.getCurrentStageInfo();
                                          final ethPrice = stageInfo['ethPrice'];

                                           setState(() {
                                            _ethPrice = ethPrice;
                                            isETHActive = true;
                                            isUSDTActive = false;

                                           });
                                          _updatePayableAmount();

                                        } catch (e) {
                                          if (context.mounted) {
                                            print('Error fetching stage info: ${e.toString()}');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Error fetching stage info: ${e.toString()}'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }

                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  //Buy with USDT Button
                                  Expanded(
                                    child:
                                        CustomButton(
                                      text: 'Buy with USDT',
                                      icon: 'assets/icons/usdt.png',
                                      isActive: isUSDTActive,
                                      onPressed: ()async {
                                        try {
                                          final stageInfo = await walletVM.getCurrentStageInfo(); // Get the stage info
                                           final usdtPrice = stageInfo['usdtPrice'];

                                           setState(() {
                                             _usdtPrice = usdtPrice;
                                             isETHActive = false;
                                             isUSDTActive = true;
                                          });
                                          _updatePayableAmount();
                                          print("Switched to USDT mode. USDT Price: $_usdtPrice");

                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Error fetching stage info: ${e.toString()}'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }

                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              Text(
                                isETHActive
                                    ? "1 ECM = ${_ethPrice.toStringAsFixed(5)} ETH"
                                    : "1 ECM = ${_usdtPrice.toStringAsFixed(1)} USDT",

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 22),

                              CustomInputField(
                                hintText: 'ECM Amount',
                                iconAssetPath: 'assets/icons/ecm.png',
                                controller: ecmController,
                              ),
                              const SizedBox(height: 12),
                              CustomInputField(
                                hintText: isETHActive ? 'ETH Payable' : 'USDT Payable',
                                iconAssetPath: isETHActive ? 'assets/icons/eth.png' : 'assets/icons/usdt.png',
                                controller: usdtController,

                              ),

                              const SizedBox(height: 14),
                              CustomGradientButton(
                                label: 'Buy ECM',
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 40,
                                onTap: () async {
                                  print("ECM Purchase triggered");
                                  try{
                                    final inputEth = ecmController.text.trim();
                                    print("User input: $inputEth");
                                    final ethDouble = double.tryParse(inputEth);
                                    print("Parsed double: $ethDouble");
                                    if (ethDouble == null || ethDouble <= 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Enter a valid ECM amount')),
                                      );
                                      return;
                                    }

                                    final ecmAmountInWeiETH = BigInt.from(ethDouble * 1e18);
                                    // final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e16);
                                    final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e6);
                                    print("ETH in Wei: $ecmAmountInWeiETH");
                                    print("USDT in smallest unit: $ecmAmountInWeiUSDT");

                                    final isETH = isETHActive;
                                    final amount = isETH ? ecmAmountInWeiETH : ecmAmountInWeiUSDT;
                                    print("Calling ${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} with: $amount");
                                    print("Purchase Button Pressed");

                                    if (isETH) {
                                      print("Calling buyECMWithETH with: $ecmAmountInWeiETH");
                                      await walletVM.buyECMWithETH(EtherAmount.inWei(amount),context);
                                    } else  {
                                      print("Calling buyECMWithUSDT with: $ecmAmountInWeiUSDT");
                                      await walletVM.buyECMWithUSDT(amount,context);
                                    }
                                    print("${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} completed");

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Purchase successful')),
                                    );
                                  }catch (e) {
                                    debugPrint("Buy ECM failed: $e");
                                   }
                                  },
                                gradientColors: [
                                  Color(0xFF2D8EFF),
                                  Color(0xFF2EE4A4)
                                ],
                              ),
                              const SizedBox(height: 14),


                              if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
                                isDisconnecting ? Center(child: CircularProgressIndicator())
                                    :
                                DisconnectButton(
                                label: 'Disconnect',
                                color: Colors.redAccent,
                                icon: Icons.visibility_off_rounded,
                                onPressed: () async {
                                  setState(() {
                                    isDisconnecting = true;
                                  });
                                  try {
                                    await walletVM.disconnectWallet(context);
                                    walletVM.reset();
                                    if (context.mounted && !walletVM.isConnected) {
                                      Navigator.pushReplacementNamed(context, RoutesName.walletLogin);
                                    }

                                   } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error disconnecting: ${e.toString()}'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }finally{
                                    if (mounted) {
                                      setState(() {
                                        isDisconnecting = false;
                                      });
                                    }
                                  }
                                },

                              ),
                            ],
                          ),
                        ],
                      );
                    }
                         ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class _BodyPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double notchWidth = 30;
    const double notchHeight = 10;
    const double cutSize = 20;

    const double topNotchOffset = 20;
    const double bottomNotchOffset = 120;

    // Start at top-left (sharp corner, no rounded cut)
    path.moveTo(0, 0);

    // Move to just before the top-right cut corner
    path.lineTo(size.width - cutSize, 0);

    // Top-right corner cu-
    path.lineTo(size.width, cutSize);

    // Right edge down
    path.lineTo(
      size.width,
      size.height,
    );

    // Bottom-right (sharp corner)
    path.lineTo(size.width, size.height);

    // Bottom notch (slightly left of center)
    double bottomNotchCenter =
        (size.width / 2) + bottomNotchOffset;
    path.lineTo(
        bottomNotchCenter + (notchWidth / 2),
        size.height);
    path.lineTo(
        bottomNotchCenter + (notchWidth / 2),
        size.height - notchHeight);
    path.lineTo(
        bottomNotchCenter - (notchWidth / 2),
        size.height - notchHeight);
    path.lineTo(
        bottomNotchCenter - (notchWidth / 2),
        size.height);

    // Move to bottom-left cut corner
    path.lineTo(cutSize, size.height);
    path.lineTo(0, size.height - cutSize);

    // Left edge up (sharp corner)
    path.lineTo(0, 0);

    // Top notch (slightly right of center)
    double topNotchCenter =
        (size.width / 2) + topNotchOffset;
    path.moveTo(
        topNotchCenter - (notchWidth / 2), 0);
    path.lineTo(topNotchCenter - (notchWidth / 2),
        notchHeight);
    path.lineTo(topNotchCenter + (notchWidth / 2),
        notchHeight);
    path.lineTo(
        topNotchCenter + (notchWidth / 2), 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(
          CustomClipper<Path> oldClipper) =>
      false;
}
