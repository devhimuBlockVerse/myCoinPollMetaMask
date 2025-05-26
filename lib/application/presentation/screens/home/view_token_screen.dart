
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../../../../framework/components/AddressFieldComponent.dart';
import '../../../../framework/components/InfoCard.dart';
import '../../../../framework/components/WhitePaperButtonComponent.dart';
import '../../../../framework/components/badgeComponent.dart';
import '../../../../framework/components/buy_ecm_button.dart';
import '../../../../framework/components/customInputField.dart';
import '../../../../framework/components/custonButton.dart';
import '../../../../framework/components/loader.dart';
import '../../../../framework/utils/dynamicFontSize.dart';
import '../../../../framework/utils/general_utls.dart';
import '../../../../framework/widgets/roadMapHelper.dart';
import '../../viewmodel/wallet_view_model.dart';
import 'home_screen.dart';


class ViewTokenScreen extends StatefulWidget {
  const ViewTokenScreen({super.key});

  @override
  State<ViewTokenScreen> createState() => _ViewTokenScreenState();
}

class _ViewTokenScreenState extends State<ViewTokenScreen> {

  String selectedBadge = 'AIRDROP';

  void _onBadgeTap(String badge) {
    setState(() {
      selectedBadge = badge;
    });
  }


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
          Utils.flushBarErrorMessage("Please connect your wallet", context);

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            // color: const Color(0xFF0B0A1E),
            color: Color(0xFF01090B),
            image: DecorationImage(
              // image: AssetImage('assets/icons/gradientBgImage.png'),
              // fit: BoxFit.contain,
              image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              // SizedBox(height: screenHeight * 0.01),

              ///Back Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/back_button.svg',
                    color: Colors.white,
                      width: screenWidth * 0.04,
                      height: screenWidth * 0.04
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              /// Main Scrollable Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.01,
                    right: screenWidth * 0.01,
                    bottom: screenHeight * 0.02,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [


                        /// White Paper Section

                        _buildTokenCard(),
                        SizedBox(height: screenHeight * 0.04),


                        /// Buy ECM section
                        _buildBuyEcmSection(),

                        SizedBox(height: screenHeight * 0.04),

                         InfoCard(
                          label1: 'ECM',
                          label2: 'eCommerce Coin (ECM)',
                          description:
                          'ECM Coin (eCommerce Coin) is a blockchain-based crypto- currency built to transform the e-commerce industry. Powered by Ethereum, it supports a decentralized ecosystem including a crypto exchange, staking platform, and metaverse project. ECM Coin ensures secure, transparent, and efficient transactions. A dedicated blockchain launch is planned for 2025.',
                          imagePath: 'assets/icons/ecmLogo.png',
                          backgroundImagePath: 'assets/icons/bg.png',
                           width: screenWidth ,
                        ),

                        /// Submit & Clear Button Section

                        SizedBox(height: screenHeight * 0.04),

                        InfoCard(
                          label1: 'METAFUSION LABS',
                          label2: 'Founder',
                          description: 'METAFUSION LABS LLC, S.R.L. is a token issuance company company based in Republic of Panama, operating under the legal name "METAFUSION LABS LLC, S.R.L." The company is registered at Global Bank Building, 50th Street, 181h Level, Republic of Panama, with Folio No. 15576379.',
                           imagePath: 'assets/icons/metaFutionImg.png',
                          // backgroundImagePath: 'assets/icons/bg.png',
                          width: screenWidth ,
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        _strategicTokenSection(),

                        Center(
                          child: Container(
                            width: screenWidth * 0.7,
                            height: screenHeight * 0.19,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icons/discoverIMG2.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB( 0,0, screenWidth * 0.070,0),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: screenWidth * 0.03),

                                    Image.asset(
                                      // 'assets/icons/discoverIMG.png',
                                      'assets/icons/ecmLarge.png',
                                      fit: BoxFit.contain,
                                      width: screenWidth * 0.17,
                                    ),

                                    SizedBox(width: screenWidth * 0.01),
                                    Flexible(
                                      child: AutoSizeText(
                                        "Discover Our Visionary Roadmap",
                                        textAlign: TextAlign.left,
                                        maxLines: 2,

                                        style:  TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 1.3,
                                          fontSize: baseSize * 0.032,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            )
                          ),
                        ),


                        SizedBox(height: screenHeight * 0.06),

                        /// Road Map Component Functionalities

                         SizedBox(
                          width: double.infinity,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: buildRoadmapSection(context, screenHeight),
                              ),

                            ],
                          ),
                        ),



                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// White Paper section With timer
  Widget _buildTokenCard() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Token Card
          Container(
            width: screenWidth,
            // constraints: BoxConstraints(maxWidth: screenWidth * 0.95),
            decoration: BoxDecoration(

              border: Border.all(
                  color: Colors.transparent
              ),
              image:const DecorationImage(
                image: AssetImage('assets/icons/viewTokenFrameBg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(baseSize * 0.025),
              child: Column(
                children: [
                  /// Image and Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Token image with badges
                      Stack(
                        children: [

                          Image.asset(
                            'assets/icons/tokens.png',
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.15,
                            fit: BoxFit.fitWidth,
                          ),

                          Positioned(
                            top: screenHeight * 0.01,
                            left: screenWidth * 0.02,
                            right: screenWidth * 0.01,
                            child: Row(
                              children: [
                                BadgeComponent(
                                  text: 'AIRDROP',
                                  isSelected: selectedBadge == 'AIRDROP',
                                  onTap: () => _onBadgeTap('AIRDROP'),
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                BadgeComponent(
                                  text: 'INITIAL',
                                  isSelected: selectedBadge == 'INITIAL',
                                  onTap: () => _onBadgeTap('INITIAL'),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                      SizedBox(width: baseSize * 0.02),

                      /// Token details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'eCommerce Coin (ECM)',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                // fontSize: baseSize * 0.035,
                                fontSize: getResponsiveFontSize(context, 14),
                                height: 1.6,

                                color: const Color(0xffFFF5ED),
                              ),
                            ),
                            SizedBox(height: baseSize * 0.01),
                            Text(
                              'Join the ECM Token ICO to revolutionize e-commerce with blockchain.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                // fontSize: baseSize * 0.028,
                                fontSize: getResponsiveFontSize(context, 13),
                                height: null,
                                color: const Color(0xffFFF5ED),
                              ),
                            ),
                            SizedBox(height: baseSize * 0.01),

                            /// Timer Section
                            Padding(
                              padding: EdgeInsets.all(baseSize * 0.01),
                              child: Container(
                                // width: double.infinity,
                                width: screenWidth,
                                padding: EdgeInsets.symmetric(
                                  // horizontal: baseSize * 0.01,
                                  // vertical: baseSize * 0.015,
                                  horizontal: baseSize * 0.02,
                                  vertical: baseSize * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0x4D1F1F1F),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 0.3,
                                    color: const Color(0x4DFFFFFF),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _timeBlock(label: 'Days', value: '02'),
                                      _timerColon(baseSize),
                                      _timeBlock(label: 'Hours', value: '23'),
                                      _timerColon(baseSize),
                                      _timeBlock(label: 'Minutes', value: '05'),
                                      _timerColon(baseSize),
                                      _timeBlock(label: 'Seconds', value: '56'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: baseSize * 0.025),

                  /// Supporters and Raised
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Supporter: 726',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          // fontSize: baseSize * 0.025,
                          fontSize: getResponsiveFontSize(context, 12),
                          height : 1.6,

                          color: const Color(0xffFFF5ED),
                        ),
                      ),
                      SizedBox(height: baseSize * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Raised: 1.12%',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              // fontSize: baseSize * 0.025,
                              fontSize: getResponsiveFontSize(context, 12),

                              height : 1.6,

                              color: const Color(0xffFFF5ED),
                            ),
                          ),
                          Text(
                            '1118527.50 / 10000000.00',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              // fontSize: baseSize * 0.025,
                              fontSize: getResponsiveFontSize(context, 12),

                              height : 1.6,

                              color: const Color(0xffFFF5ED),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: baseSize * 0.02),

                  const LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 2,
                    backgroundColor: Colors.white24,
                    color: Colors.cyanAccent,
                  ),
                  SizedBox(height: baseSize * 0.04),

                  /// Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 9.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // SizedBox(width: baseSize * 0.02),
                            _imageButton(
                              context,
                              'assets/icons/xIcon.svg',
                                  () {
                                debugPrint('Image button tapped!');
                              },
                            ),
                            SizedBox(width: baseSize * 0.02),
                            _imageButton(
                              context,
                              'assets/icons/teleImage.svg',
                                  () {
                                debugPrint('Image button tapped!');
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: baseSize * 0.02),

                      WhitePaperButtonComponent(
                        label: 'White Paper',
                        color: Colors.white,
                        onPressed: () {},
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.04,
                      ) ,
                      // SizedBox(width: baseSize * 0.02),

                      WhitePaperButtonComponent(
                        label: 'Official Website',
                        color: Colors.white,
                        onPressed: () {},
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.04,
                      )

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// _imageButton Widget
  Widget _imageButton(BuildContext context, String imagePath, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.04; // 5% of screen width

    final isSvg = imagePath.toLowerCase().endsWith('.svg');

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(8),
        child: isSvg
            ? SvgPicture.asset(
          imagePath,
          width: imageSize,
          height: imageSize,
          color: Colors.white,
        )
            : Image.asset(
          imagePath,
          width: imageSize,
          height: imageSize,
          color: Colors.white,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
  /// Countdown Widget
  Widget _timerColon(double baseSize) {
    return Baseline(
      baseline: baseSize * 0.01,
      baselineType: TextBaseline.alphabetic,
      child: Text(
        ":",
        style: TextStyle(
          fontSize: baseSize * 0.045,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
  Widget _timeBlock({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 4),

          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            border: Border.all(color: const Color(0xFF2B2D40), width: 0.25),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              height: 0.2,
              letterSpacing: 0.16,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 8,
            height: 1.2,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }



  /// Buy ECM Section
   Widget _buildBuyEcmSection() {
    final Size screenSize = MediaQuery.of(context).size;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenSize.height > screenSize.width;
    final double textScale = isPortrait ? screenWidth / 400 : screenHeight / 400;
    final double paddingScale = screenWidth * 0.04;
    final baseSize = isPortrait ? screenWidth : screenHeight;
    return  Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [

          SizedBox(height: screenHeight * 0.02),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.transparent
                ),
                image:const DecorationImage(
                  image: AssetImage('assets/icons/buyEcmContainerImage.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Consumer<WalletViewModel>(builder: (context, walletVM, child) {

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 9),
                    const SizedBox(height: 18),

                    // Stage &  MAx Section
                    ECMProgressIndicator(
                      stageIndex: _stageIndex,
                      currentECM: _currentECM,
                      maxECM: _maxECM,
                    ),


                    SizedBox(
                      width: screenWidth * 0.9,
                      child: const Divider(
                        color: Colors.white12,
                        thickness: 1,
                        height: 20,
                      ),
                    ),
                    /// Address Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
                          CustomLabeledInputField(
                            labelText: 'Your Address:',
                            hintText: walletVM.walletAddress,
                            controller: readingMoreController,
                            isReadOnly: true,
                          ),
                          const SizedBox(height: 3),
                          CustomLabeledInputField(
                            labelText: 'Referral Link:',
                            hintText: ' https://mycoinpoll.com?ref=125482458661',
                            controller: referredController,
                            isReadOnly: true,
                            trailingIconAsset: 'assets/icons/copyImg.svg',
                            onTrailingIconTap: () {
                              debugPrint('Trailing icon tapped');
                            },
                          ),
                          const SizedBox(height: 3),
                          // if (walletVM.walletAddress != null && walletVM.walletAddress.isNotEmpty)
                          CustomLabeledInputField(
                            labelText: 'Referred By:',
                            hintText: 'Show and Enter Referred id..',
                            controller: referredController,
                            isReadOnly:
                            false, // or false
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.9,
                      child: const Divider(
                        color: Colors.white12,
                        thickness: 1,
                        height: 20,
                      ),
                    ),

                    ///Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 18.0 , vertical: 10),
                      child: Row(
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
                                    debugPrint('Error fetching stage info: ${e.toString()}');
                                    Utils.flushBarErrorMessage("We couldn't get the price details. Please connect your wallet and try again.", context);

                                  }
                                }

                              },

                            ),
                          ),
                          const SizedBox(width: 12),
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
                                  debugPrint("Switched to USDT mode. USDT Price: $_usdtPrice");

                                } catch (e) {
                                  if (context.mounted) {
                                    debugPrint('Error fetching stage info: ${e.toString()}');

                                    Utils.flushBarErrorMessage("We couldn't get the price details. Please connect your wallet and try again.", context);

                                  }
                                }

                              },

                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),

                    Text(
                      isETHActive
                          ? "1 ECM = ${_ethPrice.toStringAsFixed(5)} ETH"
                          : "1 ECM = ${_usdtPrice.toStringAsFixed(1)} USDT",

                      style:  TextStyle(
                        color: Colors.white,
                        // fontSize: screenWidth * 0.032,
                        fontSize: getResponsiveFontSize(context, 13),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 18),


                    /// ECm AMount INput Section
                    CustomInputField(
                      hintText: 'ECM',
                      iconAssetPath: 'assets/icons/ecm.png',
                      controller: ecmController,
                    ),
                    const SizedBox(height: 12),
                    CustomInputField(
                      hintText: isETHActive ? 'ETH ' : 'USDT ',
                      iconAssetPath: isETHActive ? 'assets/icons/eth.png' : 'assets/icons/usdt.png',
                      controller: usdtController,

                    ),

                    const SizedBox(height: 18),
                    CustomGradientButton(
                      label: 'Buy ECM',
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.05,
                      leadingImagePath: 'assets/icons/buyEcmLeadingImg.svg',
                      onTap: () async {
                        debugPrint("ECM Purchase triggered");
                        try{
                          final inputEth = ecmController.text.trim();
                          debugPrint("User input: $inputEth");
                          final ethDouble = double.tryParse(inputEth);
                          debugPrint("Parsed double: $ethDouble");
                          if (ethDouble == null || ethDouble <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter a valid ECM amount')),
                            );
                            return;
                          }

                          final ecmAmountInWeiETH = BigInt.from(ethDouble * 1e18);
                          // final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e16);
                          final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e6);
                          debugPrint("ETH in Wei: $ecmAmountInWeiETH");
                          debugPrint("USDT in smallest unit: $ecmAmountInWeiUSDT");

                          final isETH = isETHActive;
                          final amount = isETH ? ecmAmountInWeiETH : ecmAmountInWeiUSDT;
                          debugPrint("Calling ${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} with: $amount");
                          debugPrint("Purchase Button Pressed");

                          if (isETH) {
                            debugPrint("Calling buyECMWithETH with: $ecmAmountInWeiETH");
                            await walletVM.buyECMWithETH(EtherAmount.inWei(amount),context);
                          } else  {
                            debugPrint("Calling buyECMWithUSDT with: $ecmAmountInWeiUSDT");
                            await walletVM.buyECMWithUSDT(amount,context);
                          }
                          debugPrint("${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} completed");

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Purchase successful')),
                          );
                        }catch (e) {
                          debugPrint("Buy ECM failed: $e");
                        }
                      },
                      gradientColors: const [
                        Color(0xFF2D8EFF),
                        Color(0xFF2EE4A4)
                      ],
                    ),
                    const SizedBox(height: 18),


                  ],
                );
              }
              ),
            ),
          ),
        ],
      ),
    );
  }


  /// Strategic Token Section
  Widget _strategicTokenSection(){
    final Size screenSize = MediaQuery.of(context).size;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = screenWidth / 375;
    final bool isPortrait = screenSize.height > screenSize.width;

    final baseSize = isPortrait ? screenWidth : screenHeight;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Strategic Token Rollout',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: baseSize * 0.045,
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.015,
              horizontal: screenWidth * 0.03,
            ),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/icons/gradientImg.png'),
                fit: BoxFit.cover,
              ),
              border: Border.all(width: 0.5, color: const Color(0xFF2B2D40)),
              borderRadius: BorderRadius.circular(screenWidth * 0.02),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Text(
                              'Our strategic token distribution ensures a balanced, fair launch, maximizing growth and long-term community involvement.',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 12 * textScale,
                                height: 1.6,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(screenWidth * 0.02),
                              child: SizedBox(
                                height: screenWidth * 0.3,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                    'assets/icons/distribution_image.png',
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Container(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/icons/progressFrameBg.png'),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                            vertical: screenHeight * 0.03,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildProgressBarRow(
                                title: "Presale & ICO",
                                percent: 0.5,
                                percentText: "50%",
                                barColor: const Color(0xFF1CD494),
                                textScale: textScale,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                              ),
                              SizedBox(height: screenHeight * 0.012),
                              buildProgressBarRow(
                                title: "Founder Team",
                                percent: 0.4,
                                percentText: "40%",
                                barColor: const Color(0xFFF0B90B),
                                textScale: textScale,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                              ),
                              SizedBox(height: screenHeight * 0.012),
                              buildProgressBarRow(
                                title: "Angel Investors",
                                percent: 0.1,
                                percentText: "10%",
                                barColor: const Color(0xFF009951),
                                textScale: textScale,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );


  }

  Widget buildProgressBarRow({
    required String title,
    required double percent,
    required String percentText,
    required Color barColor,
    required double textScale,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 12 * textScale,
                  height: 1.23,
                ),
              ),
            ),
            Text(
              percentText,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 12 * textScale,
                height: 1.23,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.012),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
            image: const DecorationImage(
              image: AssetImage('assets/icons/progressFrameBg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: const Color(0xFF2B2D40),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: screenHeight * 0.01,
            ),
          ),
        ),
      ],
    );
  }




}




