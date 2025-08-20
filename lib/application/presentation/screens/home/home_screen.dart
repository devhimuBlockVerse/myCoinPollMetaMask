import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/apply_for_listing_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/learn_earn_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/home/view_token_screen.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
 import 'package:provider/provider.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import '../../../../framework/components/AddressFieldComponent.dart';
import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/badgeComponent.dart';
import '../../../../framework/components/buy_ecm_button.dart';
import '../../../../framework/components/customInputField.dart';
import '../../../../framework/components/custonButton.dart';
import '../../../../framework/components/loader.dart' show ECMProgressIndicator;
import '../../../../framework/utils/customToastMessage.dart';
import '../../../../framework/utils/enums/toast_type.dart';
import '../../../../framework/widgets/animated_blockchain_images.dart';
import '../../../data/services/api_service.dart';
import '../../countdown_timer_helper.dart';
import '../../models/token_model.dart';
import '../../viewmodel/countdown_provider.dart';
import '../../viewmodel/wallet_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
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
  bool isDisconnecting = false;

  List<TokenModel> tokens = [];
  bool isLoading = true;

    String _referredByAddress = '';
  bool _isReferredByLoading = false;


  @override
  void initState() {
    super.initState();
    fetchTokens();
    ecmController.addListener(_updatePayableAmount);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      await walletVM.ensureModalWithValidContext(context);
      await walletVM.rehydrate();
      await _initializeWalletData();
      await _fetchReferredByAddress();

    });
  }
  Future<void>_refreshData()async{
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    await  walletVM.ensureModalWithValidContext(context);


    if(!walletVM.isConnected){
      await walletVM.init(context);
    }

    await Future.wait([
      fetchTokens(),
      _fetchReferredByAddress(),
      walletVM.getCurrentStageInfo(),
      if(walletVM.isConnected)
        walletVM.fetchConnectedWalletData(isReconnecting: true),

    ]);
    _updatePayableAmount();
  }

  Future<void> fetchTokens() async {
    try {
      final response = await ApiService().fetchTokens();
      setState(() {
        tokens = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }
  Future<void> _fetchReferredByAddress() async {
   setState(() {
     _isReferredByLoading = true;
     _referredByAddress = '';
   });
    try {
      final address = await ApiService().fetchPurchaseReferral();
      setState(() {
       _referredByAddress = address;
      });
    } catch (e) {
      setState(() {
        _referredByAddress = 'Error fetching referral address';
      });
    }finally{
      setState(() {
        _isReferredByLoading = false;
      });
    }
  }
  Future<void> _initializeWalletData() async {
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    if (walletVM.isConnected) {
      await walletVM.fetchConnectedWalletData(isReconnecting: true);
    }

    await walletVM.getCurrentStageInfo();
    _updatePayableAmount();
  }

  /// Helper function to fetch contract data and update the UI state.
  void _updatePayableAmount() {
    final ecmAmount = double.tryParse(ecmController.text) ?? 0.0;
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    double result = isETHActive ? ecmAmount * walletVM.ethPrice : ecmAmount * walletVM.usdtPrice;
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
              filterQuality: FilterQuality.low,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.01,
                    vertical: screenHeight * 0.02,
                  ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      ///MyCoinPoll & Connected Wallet Button
                      RepaintBoundary(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight * 0.01,
                              right: screenWidth * 0.02
                          ),
                          child: Image.asset(
                            'assets/images/mycoinpolllogo.png',
                            width: screenWidth * 0.40,
                            height: screenHeight * 0.040,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.low,
                          ),
                        ),
                      ),


                      SizedBox(height: screenHeight * 0.03),

                      /// Apply For Lisign Button


                      RepaintBoundary(
                        child: Container(
                          width: screenWidth,
                          height: screenHeight * 0.18,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent
                            ),
                            image:const DecorationImage(
                              image: AssetImage('assets/images/applyForListingBG.png'),
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.low,
                            ),
                          ),

                          /// Apply For Lisign Button

                          child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.035,
                                    vertical: screenHeight * 0.015,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Blockchain Innovation \nLaunchpad Hub',
                                        style: TextStyle(
                                          color: const Color(0xFFFFF5ED),
                                          fontFamily: 'Poppins',
                                          // fontSize: screenWidth * 0.04,
                                          fontSize: getResponsiveFontSize(context, 17),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                      ),

                                      /// Apply For Lising Button
                                      Padding(
                                        padding:  EdgeInsets.only(left: screenWidth * 0.010, top: screenHeight * 0.014),
                                        child: BlockButton(
                                          height: screenHeight * 0.05,
                                          width: screenWidth * 0.4,
                                          label: 'Apply For Listing',
                                          textStyle:  TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: getResponsiveFontSize(context, 12),

                                          ),
                                          gradientColors: const [
                                            Color(0xFF2680EF),
                                            Color(0xFF1CD494)
                                            // 1CD494
                                          ],
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const ApplyForListingScreen()),
                                            );

                                          },
                                          iconPath: 'assets/icons/arrowIcon.svg',
                                          iconSize : screenHeight * 0.009,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: screenWidth * 0.02),
                                    child: RepaintBoundary(
                                      child: AnimatedBlockchainImages(
                                        containerWidth: screenWidth * 0.3,
                                        containerHeight: screenHeight * 0.3,
                                        imageAssets: const [
                                          'assets/images/animatedImg4.png',
                                          'assets/images/animatedImg1.png',
                                          'assets/images/animatedImg5.png',


                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      ...tokens.map((token) => RepaintBoundary(child: _buildTokenCard(context, token))).toList(),

                      SizedBox(height: screenHeight * 0.05),

                      RepaintBoundary(child: _buildBuyEcmSection()),


                      SizedBox(height: screenHeight * 0.03),

                      RepaintBoundary(child: _learnAndEarnContainer()),


                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTokenCard(BuildContext context, TokenModel token) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    const baseWidth = 375.0;
    const baseHeight = 812.0;
    double scaleWidth(double size) => size * screenWidth / baseWidth;
    double scaleHeight(double size) => size * screenHeight / baseHeight;
    double scaleText(double size) => size * screenWidth / baseWidth;

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Running Tokens',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  // fontSize: baseSize * 0.045,
                  fontSize: getResponsiveFontSize(context, 16),
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ViewTokenScreen()),
                  );

                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    // fontSize: baseSize * 0.038,
                    fontSize: getResponsiveFontSize(context, 14),
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          /// Token Card
          Container(
            width: screenWidth,
            decoration:const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/viewTokenFrameBg.png'),
                fit: BoxFit.fill,
                filterQuality: FilterQuality.low,
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

                          ClipRRect(
                            child: Image.network(
                              token.featureImage,
                              width: screenWidth * 0.4,
                              height: screenHeight * 0.18,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),

                          Positioned(
                            top: screenHeight * 0.01,
                            left: screenWidth * 0.02,
                            right: screenWidth * 0.01,
                            child: Row(
                              children: token.tags.map((tag) {
                                final normalizedTag = tag.toUpperCase();
                                return Padding(
                                  padding: EdgeInsets.only(right: screenWidth * 0.01),
                                  child: BadgeComponent(
                                    text: normalizedTag,
                                    isSelected: selectedBadge == normalizedTag,
                                    onTap: () => _onBadgeTap(normalizedTag),
                                  ),
                                );
                              }).toList(),

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
                              // 'eCommerce Coin (ECM)',
                              token.fullName,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: getResponsiveFontSize(context, 14),
                                color: const Color(0xffFFF5ED),
                                height: 1.6,
                              ),
                            ),
                            SizedBox(height: baseSize * 0.02),
                            Text(
                              token.shortDescription,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,

                                fontSize: getResponsiveFontSize(context, 13),
                                color: const Color(0xffFFF5ED),
                                height: null,
                              ),
                            ),
                            SizedBox(height: baseSize * 0.01),


                            /// Timer Section

                            if (tokens.isNotEmpty && tokens.first.stageStatus) ...[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: baseSize * 0.01, vertical: baseSize * 0.01),
                                child: ChangeNotifierProvider(
                                  create: (_) => CountdownTimerProvider(
                                    targetDateTime: DateTime.parse(tokens.first.stageDate),
                                  ),
                                  child: CountdownTimer(
                                    scaleWidth: scaleWidth,
                                    scaleHeight: scaleHeight,
                                    scaleText: scaleText,
                                  ),
                                ),
                              ),
                            ]

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
                        'Supporters: ${token.supporter}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,

                          fontSize: getResponsiveFontSize(context, 12),
                          color: const Color(0xffFFF5ED),
                          height : 1.6,

                        ),
                      ),
                      SizedBox(height: baseSize * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Raised: ${token.sellPercentage.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,

                              fontSize: getResponsiveFontSize(context, 12),

                              color: const Color(0xffFFF5ED),
                              height : 1.6,

                            ),
                          ),
                          Text(

                            '${token.alreadySell} / ${token.sellTarget}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,

                              fontSize: getResponsiveFontSize(context, 12),

                              color: const Color(0xffFFF5ED),
                              height : 1.6,

                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: baseSize * 0.02),

                  LinearProgressIndicator(

                    value: token.sellPercentage / 100,
                    minHeight: 3,
                    backgroundColor: Colors.white24,
                    color: Colors.cyanAccent,
                  ),
                  SizedBox(height: baseSize * 0.02),

                  /// Action Buttons
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Row(
                          children: [
                            SizedBox(width: baseSize * 0.02),
                            if (token.socialMedia?.twitter != null && token.socialMedia!.twitter!.isNotEmpty)
                              _imageButton(
                                context,
                                'assets/icons/xIcon.svg',
                                token.socialMedia!.twitter!,

                              ),
                            SizedBox(width: baseSize * 0.02),
                            if (token.socialMedia?.telegram != null && token.socialMedia!.telegram!.isNotEmpty)
                              _imageButton(
                                context,
                                'assets/icons/teleImage.svg',
                                token.socialMedia!.telegram!,
                              )
                          ],
                        ),
                        SizedBox(width: baseSize * 0.02),

                        BlockButton(
                          height: screenHeight * 0.045,
                          width: screenWidth * 0.35,
                          label: ' View Token',
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,

                            fontSize: getResponsiveFontSize(context, 12),

                          ),
                          gradientColors: const [
                            Color(0xFF2680EF),
                            Color(0xFF1CD494),
                          ],
                          onTap: () {
                            // Navigate
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const ViewTokenScreen()),
                            );

                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: baseSize * 0.02),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// _imageButton Widget
  Widget _imageButton(BuildContext context, String imagePath, String url) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.05; // 5% of screen width

    final isSvg = imagePath.toLowerCase().endsWith('.svg');

    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ToastMessage.show(
            message: "Could not open the link",
            subtitle: "Invalid or inaccessible URL",
            type: MessageType.error,
            duration: CustomToastLength.SHORT,
            gravity: CustomToastGravity.BOTTOM,
          );
        }
      },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Initial Coin Offering',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  // fontSize: baseSize * 0.045,
                  fontSize: getResponsiveFontSize(context, 16),
                  color: Colors.white,
                ),
              ),
            ],
          ),
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
                  image: AssetImage('assets/images/buyEcmContainerImageV.png'),
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.low,
                ),
              ),
              child: Consumer<WalletViewModel>(builder: (context, walletVM, child) {

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const SizedBox(height: 9),
                    const SizedBox(height: 18),

                    ECMProgressIndicator(
                      stageIndex: walletVM.stageIndex,
                      currentECM: walletVM.currentECM,
                      maxECM:  walletVM.maxECM,
                    ),


                    SizedBox(
                      width: screenWidth * 0.9,
                      child: const Divider(
                        color: Colors.white12,
                        thickness: 1,
                        height: 15,
                      ),
                    ),
                    /// Address Section
                    if (walletVM.isConnected)...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomLabeledInputField(
                              labelText: 'Your Address:',
                              hintText: walletVM.isConnected && walletVM.walletAddress.isNotEmpty
                                  ? walletVM.walletAddress
                                  : 'Not connected',
                              controller: readingMoreController,
                              isReadOnly: true,
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            CustomLabeledInputField(
                              labelText: 'Referred By:',
                              // hintText: '0x0000000000000000000000000000000000000000',
                              hintText: _isReferredByLoading ?'Loading...'
                              : (_referredByAddress.isNotEmpty ? _referredByAddress : 'Not found'),
                              controller: referredController,
                              isReadOnly: false,
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
                    ],


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
                              icon: 'assets/images/eth.png',
                              isActive: isETHActive,
                              onPressed: () {
                                if (isETHActive) return;
                                setState(() {
                                  isETHActive = true;
                                  isUSDTActive = false;
                                });
                                _updatePayableAmount();
                              },


                            ),
                          ),
                          const SizedBox(width: 12),
                          //Buy with USDT Button
                          Expanded(
                            child:
                            CustomButton(
                              text: 'Buy with USDT',
                              icon: 'assets/images/usdt.png',
                              isActive: isUSDTActive,
                              onPressed: () {
                                if (isUSDTActive) return;
                                setState(() {
                                  isUSDTActive = true;
                                  isETHActive = false;
                                });
                                _updatePayableAmount();
                              },



                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),

                    Text(
                      isETHActive
                          ? "1 ECM = ${walletVM.ethPrice.toStringAsFixed(5)} ETH"
                          : "1 ECM = ${walletVM.usdtPrice.toStringAsFixed(1)} USDT",


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
                      iconAssetPath: 'assets/images/ecm.png',
                      controller: ecmController,
                    ),
                    const SizedBox(height: 12),
                    CustomInputField(
                      hintText: isETHActive ? 'ETH ' : 'USDT ',
                      iconAssetPath: isETHActive ? 'assets/images/eth.png' : 'assets/images/usdt.png',
                      controller: usdtController,

                    ),

                    const SizedBox(height: 18),
                    CustomGradientButton(
                      label: 'Buy ECM',
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.05,
                      leadingImagePath: 'assets/icons/buyEcmLeadingImg.svg',
                      onTap: () async {
                        final walletVM = Provider.of<WalletViewModel>(context, listen: false);

                        if (!walletVM.isConnected) {
                          final ok = await walletVM.connectWallet(context);
                          if (!ok) return;
                        }

                        try{
                          final inputEth = ecmController.text.trim();

                          final ethDouble = double.tryParse(inputEth);

                          if (ethDouble == null || ethDouble <= 0) {
                            ToastMessage.show(
                              message: "Invalid Amount",
                              subtitle: "Please enter a valid ECM amount.",
                              type: MessageType.info,
                              duration: CustomToastLength.SHORT,
                              gravity: CustomToastGravity.BOTTOM,
                            );

                            return;
                          }

                          final ecmAmountInWeiETH = BigInt.from(ethDouble * 1e18);
                          final ecmAmountInWeiUSDT = BigInt.from(ethDouble * 1e6);

                          final isETH = isETHActive;
                          final amount = isETH ? ecmAmountInWeiETH : ecmAmountInWeiUSDT;
                          debugPrint("Calling ${isETH ? 'buyECMWithETH' : 'buyECMWithUSDT'} with: $amount");
                          debugPrint("Purchase Button Pressed");

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                          );

                          if (isETH) {
                            await walletVM.buyECMWithETH(EtherAmount.inWei(amount),context);

                          } else  {
                            final referralAddress = EthereumAddress.fromHex("0x0000000000000000000000000000000000000000");
                            await walletVM.buyECMWithUSDT(amount,referralAddress,context);
                          }
                          Navigator.of(context).pop();
                          ecmController.clear();
                        }catch (e) {
                          Navigator.of(context).pop();
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

  Widget _learnAndEarnContainer(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Container(
      width: screenWidth,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/learnAndEarnFrame.png'),
          fit: BoxFit.fill,
          filterQuality: FilterQuality.low,

        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: baseSize * 0.02,
          horizontal: baseSize * 0.02,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: screenWidth * 0.28,
              height: screenHeight * 0.14,
              child: Image.asset('assets/images/learnAndEarnImg.png',fit: BoxFit.fill,filterQuality: FilterQuality.low,
              ),
            ),

            // Right Side: Text and Button
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: baseSize * 0.015,
                  horizontal: baseSize * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    AutoSizeText(
                      'Earn Crypto While You Learn',
                      textAlign: TextAlign.right,

                      style: TextStyle(
                        color: const Color(0XFFFFF5ED),
                        // fontSize: baseSize * 0.040,
                        fontSize: getResponsiveFontSize(context, 14),
                        fontWeight: FontWeight.w500,
                        height: 1.3,

                      ),
                    ),
                    SizedBox(height: baseSize * 0.01),
                    AutoSizeText(
                      'Boost your crypto knowledge and earn free tokens by learning blockchain basics.',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0XFFFFF5ED),
                        // fontSize: baseSize * 0.030,
                        fontSize: getResponsiveFontSize(context, 12),
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: baseSize * 0.03),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BlockButton(
                        height: baseSize * 0.10,
                        width: screenWidth * 0.4,
                        label: "Get Started",
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: baseSize * 0.030,
                        ),
                        gradientColors: const [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494),
                        ],
                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LearnEarnScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

