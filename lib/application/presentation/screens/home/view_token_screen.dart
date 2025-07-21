import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import '../../../../framework/components/AddressFieldComponent.dart';
import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/InfoCard.dart';
import '../../../../framework/components/badgeComponent.dart';
import '../../../../framework/components/buy_Ecm.dart';
import '../../../../framework/components/buy_ecm_button.dart';
import '../../../../framework/components/customInputField.dart';
import '../../../../framework/components/custonButton.dart';
import '../../../../framework/components/loader.dart';
import '../../../../framework/utils/customToastMessage.dart';
import '../../../../framework/utils/dynamicFontSize.dart';
import '../../../../framework/utils/enums/toast_type.dart';
import '../../../../framework/utils/general_utls.dart';
import '../../../../framework/widgets/roadMapHelper.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/download_white_paper.dart';
import '../../countdown_timer_helper.dart';
import '../../models/token_model.dart';
import '../../viewmodel/countdown_provider.dart';
import '../../viewmodel/wallet_view_model.dart';


class ViewTokenScreen extends StatefulWidget {
  const ViewTokenScreen({super.key});

  @override
  State<ViewTokenScreen> createState() => _ViewTokenScreenState();
}

class _ViewTokenScreenState extends State<ViewTokenScreen>with WidgetsBindingObserver {

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

  List<TokenModel> tokens = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchTokens();
    ecmController.addListener(_updatePayableAmount);
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final walletVM = Provider.of<WalletViewModel>(context, listen: false);
      try {
        final stageInfo = await walletVM.getCurrentStageInfo();
        final ethPrice = stageInfo['ethPrice'];
        final usdtPrice = stageInfo['usdtPrice'];
        final currentECM = stageInfo['ecmSold'];
        final maxECM = stageInfo['target'];
        final stageIndex = stageInfo['stageIndex'];

        if(walletVM.isConnected){
          setState(() {
            _stageIndex = stageIndex;
            _currentECM = currentECM;
            _maxECM = maxECM;
            _ethPrice = ethPrice;
            _usdtPrice = usdtPrice;

          });
        }else{
          setState(() {

            _ethPrice = ethPrice;
            _usdtPrice = usdtPrice;

          });
        }

      } catch (e) {
        if (mounted) {
          Utils.flushBarErrorMessage("Please connect your wallet", context);

        }
      }
    });

  }
  Future<void> fetchTokens() async {
    try {
      final response = await ApiService().fetchTokens();
      setState(() {
        tokens = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tokens: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _initializeWalletData() async {
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    await walletVM.init(context);
    try {

      final ethPrice = walletVM.ethPrice;
      final usdtPrice = walletVM.usdtPrice;
      final currentECM = walletVM.currentECM;
      final maxECM = walletVM.maxECM;
      final stageIndex = walletVM.stageIndex;


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
  }

  void _updatePayableAmount() {
    final ecmAmount = double.tryParse(ecmController.text) ?? 0.0;
    double result = isETHActive ? ecmAmount * _ethPrice : ecmAmount * _usdtPrice;

    // Display converted amount in the usdtController
    usdtController.text =  isETHActive ? result.toStringAsFixed(5) : result.toStringAsFixed(1);

  }


  Future<void> downloadWhitepaperPdf(BuildContext context) async {
    const String fileUrl = 'https://raw.githubusercontent.com/devhimuBlockVerse/ecm-whitepaper/main/ECM-Whitepaper.pdf';
    const String fileName = 'ECM-Whitepaper.pdf';

    try {
      // Request permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ToastMessage.show(
          message: "Permission Denied",
          subtitle: "Storage permission is required to download the file.",
          type: MessageType.info,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );
        return;
      }

      // Save to Download folder directly
      final directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }


      final filePath = '${directory!.path}/$fileName';

      // Start downloading
      final dio = Dio();
      await dio.download(fileUrl, filePath);

      ToastMessage.show(
        message: "Download Complete",
        subtitle: "Saved to: Download/$fileName",
        type: MessageType.success,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );

    } catch (e) {

      ToastMessage.show(
        message: "Download Failed",
        subtitle: "An error occurred while downloading the file.",
        type: MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      print("Download errorL: $e");
    }
  }


  @override
  void dispose() {
    ecmController.removeListener(_updatePayableAmount);
    ecmController.dispose();
    usdtController.dispose();
    readingMoreController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("App resumed from background, refreshing wallet data.");
      _initializeWalletData();
    }
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
             color: Color(0xFF01090B),
            image: DecorationImage(
              image: AssetImage('assets/images/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
              filterQuality: FilterQuality.medium,
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
                      height: screenWidth * 0.04,


                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              /// Main Scrollable Content
              isLoading || tokens.isEmpty ? const Center(child: CircularProgressIndicator()) :
              Expanded(
                child: Padding(

                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.02,
                  ),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),

                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [


                        /// White Paper Section
                          // _buildTokenCard(),
                          ...tokens.map((token) => _buildTokenCard(context, token)).toList(),

                          SizedBox(height: screenHeight * 0.04),


                          /// Buy ECM section
                          _buildBuyEcmSection(),

                          SizedBox(height: screenHeight * 0.04),

                            InfoCard(
                              label1: tokens.first.symbol,
                              label2: tokens.first.fullName,
                              description: tokens.first.description
                                  .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '')
                                  .trim(),
                              imagePath: 'assets/images/ecmLogo.png',
                              // imagePath: tokens.first.logo,
                              backgroundImagePath: 'assets/images/bg.png',
                              width: screenWidth ,
                            ),

                            /// Submit & Clear Button Section

                            SizedBox(height: screenHeight * 0.04),

                            InfoCard(
                              // label1: 'METAFUSION LABS',
                              label1: tokens.first.tokenCompany,
                              label2: 'Founder',
                              description: tokens.first.companyDetails,
                              imagePath: 'assets/images/metaFutionImg.png',
                               width: screenWidth ,
                            ),

                            SizedBox(height: screenHeight * 0.04),

                            _strategicTokenSection(tokens.first),





                          Center(
                            child: Container(
                              width: screenWidth * 0.82,
                              height: screenHeight * 0.19,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/discoverIMG2.png'),
                                  fit: BoxFit.fitWidth,
                                  filterQuality: FilterQuality.medium,

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
                                        // 'assets/images/discoverIMG.png',
                                        'assets/images/ecmLarge.png',
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
                                            // fontSize: baseSize * 0.036,
                                            fontSize: baseSize * 0.045,
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
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// White Paper section With timer
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

          /// Token Card
          Container(
            width: screenWidth,
            decoration:const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/viewTokenFrameBg.png'),
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
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // 'eCommerce Coin (ECM)',
                              token.fullName,
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
                              // 'Join the ECM Token ICO to revolutionize e-commerce',
                              token.shortDescription,
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
                        // 'Supporter: 726',
                        'Supporters: ${token.supporter}',
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
                            // 'Raised: 1.12%',
                            'Raised: ${token.sellPercentage.toStringAsFixed(2)}%',
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
                            // '1118527.50 / 10000000.00',
                            '${token.alreadySell} / ${token.sellTarget}',
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

                   LinearProgressIndicator(
                    // value: 0.5,
                    value: token.sellPercentage / 100,
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
                      ),
                      SizedBox(width: baseSize * 0.02),
                      BlockButton(
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.04,
                        label: "White Paper",
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: getResponsiveFontSize(context, 12),
                        ),
                        gradientColors: const [
                          Color(0xFF2680EF),
                          Color(0xFF1CD494),
                        ],

                        onTap: () async {
                           await DownloadService.downloadWhitepaperPdf(context);

                        },
                      ),

                      BlockButtonV2(
                        text: 'Official Website',
                        onPressed: () async{
                          const url = 'https://ecmcoin.com/';
                          if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                          } else {
                          debugPrint('Could not launch $url');
                          }
                        },
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: getResponsiveFontSize(context, 12),
                        ),
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.04,
                      ),

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
  Widget _imageButton(BuildContext context, String imagePath,  String url) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.04; // 5% of screen width

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
          filterQuality: FilterQuality.medium,

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
                  filterQuality: FilterQuality.medium,
                ),
              ),
              child: Consumer<WalletViewModel>(builder: (context, walletVM, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _updatePayableAmount();
                });
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                        height: 20,
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
                              labelText: 'Referral Link:',
                              hintText: ' https://mycoinpoll.com?ref=125482458661',
                              controller: referredController,
                              isReadOnly: true,
                              trailingIconAsset: 'assets/icons/copyImg.svg',
                               onTrailingIconTap: () {

                                const referralLink = 'https://mycoinpoll.com?ref=125482458661';

                                Clipboard.setData(const ClipboardData(text:referralLink));

                                ToastMessage.show(
                                  message: "Referral link copied!",
                                  subtitle: referralLink,
                                  type: MessageType.success,
                                  duration: CustomToastLength.SHORT,
                                  gravity: CustomToastGravity.BOTTOM,
                                );

                              },

                            ),
                            SizedBox(height: screenHeight * 0.02),
                            CustomLabeledInputField(
                              labelText: 'Referred By:',
                              hintText: '0x0000000000000000000000000000000000000000',
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

                        if (!walletVM.isConnected) {

                          try {
                            await walletVM.ensureModalWithValidContext(context);
                            await walletVM.appKitModal?.openModalView();
                          } catch (e) {
                            debugPrint("Failed to open wallet modal: $e");
                            return;
                          }

                          return;
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
                          Navigator.pop(context);
                          ecmController.clear();
                        }catch (e) {
                          Navigator.pop(context);
                          debugPrint("Buy ECM failed: $e");
                          ToastMessage.show(
                            message: "Transaction Failed",
                            subtitle: e.toString().contains("reverted") ? "Transaction reverted by EVM." : "An error occurred while processing your transaction.",
                            type: MessageType.error,
                          );
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
  Widget _strategicTokenSection(TokenModel token){
    final Size screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = screenWidth / 375;
    final bool isPortrait = screenSize.height > screenSize.width;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    // final token = tokens.first;

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
                image: AssetImage('assets/images/gradientImg.png'),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,

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
                                  child: Image.network(
                                    token.distributionImage!,
                                    fit: BoxFit.contain,

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
                            image: AssetImage('assets/images/progressFrameBg.png'),
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.medium,

                          ),
                         ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                            vertical: screenHeight * 0.02,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                             children: token.distributions.map((dist) {
                              final percent = double.tryParse(dist.value) ?? 0.0;
                              return Column(
                                children: [
                                  buildProgressBarRow(
                                    title: dist.title,
                                    percent: percent / 100,
                                    percentText: "${percent.toStringAsFixed(0)}%",
                                    barColor: _getBarColor(dist.title),
                                    textScale: textScale,
                                    screenHeight: screenHeight,
                                    screenWidth: screenWidth,
                                  ),
                                  SizedBox(height: screenHeight * 0.012),
                                ],
                              );
                            }).toList(),
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
              image: AssetImage('assets/images/progressFrameBg.png'),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,

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


Color _getBarColor(String title) {
  switch (title.toLowerCase()) {
    case 'presale & ico':
      return const Color(0xFF1CD494);
    case 'founder team':
      return const Color(0xFFF0B90B);
    case 'angel investors':
      return const Color(0xFF009951);
    default:
      return Colors.blueAccent;
  }
}


