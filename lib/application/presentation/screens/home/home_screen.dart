import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
import '../../../../framework/utils/customToastMessage.dart';
import '../../../../framework/utils/decimalFormat.dart';
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedBadge = 'AIRDROP';

  void _onBadgeTap(String badge) {
    setState(() {
      selectedBadge = badge;
    });
  }

  final ethController = TextEditingController();
  final ecmController = TextEditingController();
  final readingMoreController = TextEditingController();
  final referredController = TextEditingController();
  final String defaultReferrerAddress =
      '0x0000000000000000000000000000000000000000';

  bool isDisconnecting = false;

  List<TokenModel> tokens = [];
  bool isLoading = true;

  String _referredByAddress = '';
  bool _isReferredByLoading = false;
  bool _isUpdating = false;

  bool _isCheckingLocation = false;
  bool _isLocationAllowed = true;
  String _locationMessage = '';

  @override
  void initState() {
    super.initState();
    ecmController.addListener(_updateEthFromECM);
    ethController.addListener(_updateECMFromEth);
    fetchTokens();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      await walletVM.ensureModalWithValidContext(context);
      await walletVM.rehydrate();
      await _initializeWalletData();
      await _fetchReferredByAddress();
      await _checkGeolocation();
    });
  }

  Future<void> _checkGeolocation() async {
    setState(() {
      _isCheckingLocation = true;
    });

    try {
      final geoData = await ApiService().checkGeolocation();
      final bool isShow = geoData['is_show'] ?? true;
      final String message = geoData['message'] ?? '';
      final String country = geoData['country'] ?? 'Unknown';

      setState(() {
        _isLocationAllowed = isShow;
        _locationMessage =
            message.isNotEmpty ? message : 'Service not available in $country';
      });
    } catch (e) {
      // If API fails, allow purchase (fail-safe)
      setState(() {
        _isLocationAllowed = true;
        _locationMessage = '';
      });
    } finally {
      setState(() {
        _isCheckingLocation = false;
      });
    }
  }

  /// Helper function to fetch contract data and update the UI state.

  void _updateEthFromECM() {
    if (_isUpdating) return;
    _isUpdating = true;

    final ecmAmount = double.tryParse(ecmController.text) ?? 0.0;
    if (ecmAmount <= 0) {
      ethController.clear();
      _isUpdating = false;
      return;
    }

    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    // Use the new conversion method
    final ethAmountInWei = walletVM.convertECMtoWei(ecmAmount);
    if (ethAmountInWei != null) {
      final ethAmount = ethAmountInWei / BigInt.from(10).pow(18);
      ethController.text = ethAmount.toStringAsFixed(6);
    } else {
      ethController.clear();
    }

    _isUpdating = false;
  }

  void _updateECMFromEth() {
    if (_isUpdating) return;
    _isUpdating = true;
    final ethAmount = double.tryParse(ethController.text) ?? 0.0;

    if (ethAmount <= 0) {
      ecmController.clear();
      _isUpdating = false;
      return;
    }

    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    if (walletVM.ethPrice > 0) {
      final ecmAmount = ethAmount / walletVM.ethPrice;
      ecmController.text = ecmAmount.toStringAsFixed(1);
      // ecmController.text = ecmAmount.toStringAsFixed(6);
    } else {
      ecmController.clear();
    }
    _isUpdating = false;
  }

  Future<void> _refreshData() async {
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    await walletVM.ensureModalWithValidContext(context);

    if (!walletVM.isConnected) {
      await walletVM.init(context);
    }

    await Future.wait([
      walletVM.fetchLatestETHPrice(),
      fetchTokens(),
      _fetchReferredByAddress(),
      if (walletVM.isConnected)
        walletVM.fetchConnectedWalletData(isReconnecting: true),
    ]);
    _updateEthFromECM();
    _updateECMFromEth();
  }

  Future<void> _initializeWalletData() async {
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    if (walletVM.isConnected) {
      await walletVM.fetchConnectedWalletData(isReconnecting: true);
    }
    await walletVM.fetchLatestETHPrice();
    _updateECMFromEth();
    _updateEthFromECM();
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
    } finally {
      setState(() {
        _isReferredByLoading = false;
      });
    }
  }

  @override
  void dispose() {
    ecmController.removeListener(_updateEthFromECM);
    ethController.removeListener(_updateECMFromEth);
    ecmController.dispose();
    ethController.dispose();
    readingMoreController.dispose();
    referredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
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
                                right: screenWidth * 0.02),
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
                              border: Border.all(color: Colors.transparent),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/applyForListingBG.png'),
                                fit: BoxFit.fill,
                                filterQuality: FilterQuality.low,
                              ),
                            ),

                            /// Apply For Lisign Button

                            child: Stack(children: [
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
                                        fontSize:
                                            getResponsiveFontSize(context, 17),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                    ),

                                    /// Apply For Lising Button
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: screenWidth * 0.010,
                                          top: screenHeight * 0.014),
                                      child: BlockButton(
                                        height: screenHeight * 0.05,
                                        width: screenWidth * 0.4,
                                        label: 'Apply For Listing',
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontSize: getResponsiveFontSize(
                                              context, 12),
                                        ),
                                        gradientColors: const [
                                          Color(0xFF2680EF),
                                          Color(0xFF1CD494)
                                          // 1CD494
                                        ],
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ApplyForListingScreen()),
                                          );
                                        },
                                        iconPath: 'assets/icons/arrowIcon.svg',
                                        iconSize: screenHeight * 0.009,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: screenWidth * 0.02),
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
                            ]),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        ...tokens
                            .map((token) => RepaintBoundary(
                                child: _buildTokenCard(context, token)))
                            .toList(),

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
          SizedBox(height: baseSize * 0.04),

          /// Token Card
          Container(
            width: screenWidth,
            decoration: const BoxDecoration(
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
                          isLoading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ClipRRect(
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
                                  padding: EdgeInsets.only(
                                      right: screenWidth * 0.01),
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

                            if (tokens.isNotEmpty &&
                                tokens.first.stageStatus) ...[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: baseSize * 0.01,
                                    vertical: baseSize * 0.01),
                                child: ChangeNotifierProvider(
                                  create: (_) => CountdownTimerProvider(
                                    targetDateTime:
                                        DateTime.parse(tokens.first.stageDate),
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
                          height: 1.6,
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
                              height: 1.6,
                            ),
                          ),
                          Text(
                            '${token.alreadySell} / ${token.sellTarget}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: getResponsiveFontSize(context, 12),
                              color: const Color(0xffFFF5ED),
                              height: 1.6,
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
                            if (token.socialMedia?.twitter != null &&
                                token.socialMedia!.twitter!.isNotEmpty)
                              _imageButton(
                                context,
                                'assets/icons/xIcon.svg',
                                token.socialMedia!.twitter!,
                              ),
                            SizedBox(width: baseSize * 0.02),
                            if (token.socialMedia?.telegram != null &&
                                token.socialMedia!.telegram!.isNotEmpty)
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
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ViewTokenScreen()),
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
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
                border: Border.all(color: Colors.transparent),
                image: const DecorationImage(
                  image: AssetImage('assets/images/buyEcmContainerImageV.png'),
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.low,
                ),
              ),
              child: Consumer<WalletViewModel>(
                  builder: (context, walletVM, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 18),

                    /// Address Section
                    if (walletVM.isConnected) ...[
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: const Divider(
                          color: Colors.white12,
                          thickness: 1,
                          height: 15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomLabeledInputField(
                              labelText: 'Your Address:',
                              hintText: walletVM.isConnected &&
                                      walletVM.walletAddress.isNotEmpty
                                  ? walletVM.walletAddress
                                  : 'Not connected',
                              controller: readingMoreController,
                              isReadOnly: true,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            CustomLabeledInputField(
                              labelText: 'Referred By:',
                              hintText: _isReferredByLoading
                                  ? 'Loading...'
                                  : (_referredByAddress.isNotEmpty
                                      ? _referredByAddress
                                      : 'Not found'),
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
                    const SizedBox(height: 5),
                    Text(
                      walletVM.ethPrice > 0
                          ? "1 ECM = ${walletVM.ethPrice.toStringAsFixed(6)} ETH"
                          : "Loading...",
                      style: TextStyle(
                        color: Colors.white,
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
                      onChanged: _updateEthFromECM,
                      inputFormatters: [
                        DecimalTextInputFormatter(),
                      ],
                    ),

                    const SizedBox(height: 12),
                    CustomInputField(
                      hintText: 'ETH ',
                      iconAssetPath: 'assets/images/eth.png',
                      controller: ethController,
                      onChanged: _updateECMFromEth,
                      inputFormatters: [
                        DecimalTextInputFormatter(),
                      ],
                    ),

                    const SizedBox(height: 18),
                    CustomGradientButton(
                      // label: 'Buy ECM',
                      label: _isLocationAllowed
                          ? 'Buy ECM'
                          : (_locationMessage.isNotEmpty)
                              ? _locationMessage
                              : 'Loading...',
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.05,
                      leadingImagePath: 'assets/icons/buyEcmLeadingImg.svg',
                      onTap: () async {
                        if (!_isLocationAllowed) {
                          ToastMessage.show(
                            message: _locationMessage.isNotEmpty
                                ? _locationMessage
                                : "ECM purchase is not available in your region",
                            subtitle: "Service Not Available",
                            type: MessageType.info,
                            duration: CustomToastLength.LONG,
                            gravity: CustomToastGravity.BOTTOM,
                          );
                          return;
                        }

                        final walletVM = Provider.of<WalletViewModel>(context,
                            listen: false);

                        if (!walletVM.isConnected) {
                          await walletVM.ensureModalWithValidContext(context);
                          final ok = await walletVM.connectWallet(context);
                          if (ok) return;
                        }
                        final ecmAmount =
                            double.tryParse(ecmController.text.trim());
                        if (ecmAmount == null || ecmAmount <= 0) {
                          ToastMessage.show(
                            message: "Invalid Amount",
                            subtitle: "Please enter a valid ECM amount.",
                            type: MessageType.info,
                            duration: CustomToastLength.SHORT,
                            gravity: CustomToastGravity.BOTTOM,
                          );
                          return;
                        }
                        if (!walletVM.isValidECMAmount(ecmAmount)) {
                          ToastMessage.show(
                            message: "Minimum Amount Required",
                            subtitle:
                                "Minimum 50 ECM tokens per purchase required.",
                            type: MessageType.info,
                            duration: CustomToastLength.SHORT,
                            gravity: CustomToastGravity.BOTTOM,
                          );
                          return;
                        }

                        try {
                          final ethAmountInWei =
                              walletVM.convertECMtoWei(ecmAmount);
                          if (ethAmountInWei == null) {
                            ToastMessage.show(
                              message: "Conversion Error",
                              subtitle:
                                  "Failed to calculate ETH amount. Please try again.",
                              type: MessageType.error,
                              duration: CustomToastLength.SHORT,
                              gravity: CustomToastGravity.BOTTOM,
                            );
                            return;
                          }

                          // Convert BigInt to EtherAmount
                          final ethAmount = EtherAmount.fromBigInt(
                              EtherUnit.wei, ethAmountInWei);

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                          );

                          final referralInput = referredController.text.trim();

                          final referralAddress = referralInput.isNotEmpty &&
                                  EthereumAddress.fromHex(referralInput).hex !=
                                      defaultReferrerAddress
                              ? EthereumAddress.fromHex(referralInput)
                              : EthereumAddress.fromHex(defaultReferrerAddress);

                          final txHash = await walletVM.buyECMWithETH(
                            // ethAmount: ethAmountInWei,
                            ethAmount: ethAmount,
                            referralAddress: referralAddress,
                            context: context,
                          );
                          Navigator.of(context).pop();
                          ecmController.clear();
                          ethController.clear();
                          if (txHash != null) {
                            ToastMessage.show(
                              message: "Purchase Successful",
                              subtitle: "Transaction hash: $txHash",
                              type: MessageType.success,
                              duration: CustomToastLength.LONG,
                              gravity: CustomToastGravity.BOTTOM,
                            );
                          }
                        } catch (e, stackTrace) {
                          Navigator.of(context).pop();
                        }
                      },
                      // gradientColors: const [
                      //   Color(0xFF2D8EFF),
                      //   Color(0xFF2EE4A4)
                      // ],
                      gradientColors: _isLocationAllowed
                          ? const [Color(0xFF2D8EFF), Color(0xFF2EE4A4)]
                          : const [Colors.white38, Colors.white38],
                    ),

                    const SizedBox(height: 18),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _learnAndEarnContainer() {
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
              child: Image.asset(
                'assets/images/learnAndEarnImg.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.low,
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
                            MaterialPageRoute(
                                builder: (context) => const LearnEarnScreen()),
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
