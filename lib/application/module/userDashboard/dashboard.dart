import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/pei_chart.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/wallet_view_model.dart';
import 'package:provider/provider.dart';
import '../../../framework/components/AddressFieldComponent.dart';
import '../../../framework/components/BlockButton.dart';
import '../../../framework/components/buildProgressBar.dart';
import '../../../framework/components/statusIndicatorComponent.dart';
import '../../../framework/components/userBadgeLevelCompoenet.dart';
import '../../../framework/components/walletAddressComponent.dart';
import '../../../framework/utils/dynamicFontSize.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {



  @override
  void initState() {
    super.initState();
    _setGreeting();


  }



  String greeting = "";

  void _setGreeting() {
    final hour = DateTime.now().hour;
    greeting = hour >= 5 && hour < 12
        ? "Good Morning"
        : hour >= 12 && hour < 17
        ? "Good Afternoon"
        : hour >= 17 && hour < 21
        ? "Good Evening"
        : "Good Night";
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    // Dynamic multipliers
    final baseSize = isPortrait ? screenWidth : screenHeight;
    return Scaffold(

      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
             image: DecorationImage(
               image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  /// User Name Data & Wallet Address
                  _headerSection(),
                  SizedBox(height: screenHeight * 0.02),

                  /// User Graph Chart and Level
                  _EcmWithGraphChart(),
                  SizedBox(height: screenHeight * 0.03),


                  /// Referral Link
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff040C16),
                    borderRadius: BorderRadius.circular(12)
                    ),

                    child: ClipRRect(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CustomLabeledInputField(
                        labelText: 'Referral Link:',
                        hintText: ' https://mycoinpoll.com?ref=125482458661',
                         isReadOnly: true,
                        trailingIconAsset: 'assets/icons/copyImg.svg',
                        onTrailingIconTap: () {
                          debugPrint('Trailing icon tapped');
                        },
                      ),
                    ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),



                  _joinPromoteEarn(),
                  SizedBox(height: screenHeight * 0.03),

                  _milestoneSection(),
                  SizedBox(height: screenHeight * 0.03),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _headerSection(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;
    // Dynamic multipliers
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return Consumer<WalletViewModel>(
    builder: (context, model, _){
     return   Container(
       width: double.infinity,
       decoration: BoxDecoration(
         color: Colors.transparent.withOpacity(0.1),
       ),
       child: ClipRRect(
         child: BackdropFilter(
           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
           child: Padding(
             padding: EdgeInsets.symmetric(
               horizontal: screenWidth * 0.03,
               vertical: screenHeight * 0.015,
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 /// User Info & Ro Text + Notification
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       "$greeting",
                       style: TextStyle(
                         fontFamily: 'Poppins',
                         fontWeight: FontWeight.w400,
                         fontSize: getResponsiveFontSize(context, 14),
                         height: 1.6,
                         color: Color(0xffFFF5ED),
                       ),
                     ),
                     Text(
                       'User Name', // your Ro text
                       style: TextStyle(
                         fontFamily: 'Poppins',
                         fontWeight: FontWeight.w600,
                         fontSize: getResponsiveFontSize(context, 18),
                         height: 1.3,
                         color: Color(0xffFFF5ED),
                       ),
                     ),
                     SizedBox(width: 8),

                   ],
                 ),

                 /// Wallet Address
                 Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                     Transform.translate(
                       offset: Offset(screenWidth * 0.025, 0),
                       child:  WalletAddressComponent(
                         // address: formatAddress(model.walletAddress),
                         address: "0xe2...e094",
                       ),
                     ),

                     GestureDetector(
                       onTap: (){},
                       child: SvgPicture.asset(
                         'assets/icons/nofitication.svg',
                         height: getResponsiveFontSize(context, 24),
                       ),
                     ),
                   ],
                 ),
               ],
             ),
           ),
         ),
       ),
     );
    });
  }

  Widget _EcmWithGraphChart(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        width: screenWidth,
        height: screenHeight * 0.16,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.transparent
          ),
          image: const DecorationImage(
            image: AssetImage('assets/icons/applyForListingBG.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.035,
                vertical: screenHeight * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/ecm.png',
                              height: screenWidth * 0.04,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              'ECM Coin',
                              textAlign:TextAlign.start,
                              style: TextStyle(
                                color: Color(0xffFFF5ED),
                                fontFamily: 'Poppins',
                                fontSize: getResponsiveFontSize(context, 16),
                                fontWeight: FontWeight.normal,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                          Text(
                            '20000000', /// Get the Real Value  from Wallet
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: getResponsiveFontSize(context, 24),
                                fontWeight: FontWeight.w600,
                                height: 1.3
                          ),

                        ),
                        SizedBox(height: screenHeight * 0.01),

                        /// Badge Icons (assuming this is related to the left text)
                        Padding(
                          padding:  EdgeInsets.only(left: screenWidth * 0.00), // Adjusted padding
                          child:Text('Show Badge Icons',style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.025),), // Added font size
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        // Badge
                        UserBadgeLevel(
                          label: 'Level-1',
                          iconPath: 'assets/icons/check.svg',
                        ),

                         Image.asset(
                          'assets/icons/staticChart.png',
                          width: screenWidth * 0.48 ,
                          height: screenHeight * 0.08,
                          fit: BoxFit.contain,
                        ),

                         RichText(
                          text:  TextSpan(
                            text: 'Today up to ',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal,
                                color: Colors.grey, fontSize: getResponsiveFontSize(context, 10)),
                            children: <TextSpan>[
                              TextSpan(
                                text: '+5.34%', // This text will be dynamically updated by the RealtimeChart widget
                                style: TextStyle(color: Color(0xFF29FFA5),  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal,
                                  fontSize: getResponsiveFontSize(context, 10),
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
            ),
                ],
        )
    );
  }

  Widget _joinPromoteEarn(){
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
                'Join. Promote. Earn.',
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
              vertical: screenHeight * 0.003,
              horizontal: screenWidth * 0.03,
            ),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/icons/linearFrame.png'),
                fit: BoxFit.fill,
              ),

            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      SizedBox(height: screenHeight * 0.015),
                      Container(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/icons/linearFrame2.png'),
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
                              ProgressBarUserDashboard(
                                title: "ECM Holding",
                                percent: 0.9,
                                percentText: "280/300",
                                barColor: const Color(0xFF1CD494),
                                textScale: textScale,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                              ),
                              SizedBox(height: screenHeight * 0.012),
                              ProgressBarUserDashboard(
                                title: "Referral Sales (ECM)",
                                percent: 0.4,
                                percentText: "1200/2500",
                                barColor: const Color(0xFFF0B90B),
                                textScale: textScale,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                              ),
                              SizedBox(height: screenHeight * 0.016),

                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [

                                   /// Refactor This Component Later with status Active or Inactive Variation.
                                   StatusIndicator(
                                    statusText: 'Not Yet an Affiliator',       /// Variation ->  Already an Affiliate
                                    statusColor: Color(0xFFE04043),            /// Variation -> Color(0xff1CD494)
                                    iconPath: 'assets/icons/crossIcon.svg',   ///Variation ->  checkIconAffiliate.svg
                                   ),

                                   Align(
                                     alignment: Alignment.centerRight,
                                     child: BlockButton(
                                       height: baseSize * 0.08,
                                       width: screenWidth * 0.3,
                                       label: "View Details",
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
                                         debugPrint('Button tapped');
                                        },
                                     ),
                                   ),

                                 ],
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


  Widget _milestoneSection(){
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Milestone',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: baseSize * 0.045,
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: baseSize * 0.038,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.003,
              horizontal: screenWidth * 0.03,
            ),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/icons/linearFrame.png'),
                fit: BoxFit.fill,
              ),

            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                /// PetChart

                Flexible(
                  flex: 2,
                  child: Container(
                    height: screenHeight * 0.25, // Responsive height for the chart container
                    constraints: BoxConstraints(
                      maxWidth: screenHeight * 0.25, // Ensure chart doesn't get too wide relative to its height
                    ),
                    child: PieChartWidget(),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03), // Add some spacing between chart and details

                /// Details - Example placeholder
                // Option 2: Use Expanded for the "Details" section to take remaining space
                Expanded(
                  flex: 1, // Give less flex to details, or adjust as needed
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Wrap content
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details Title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getResponsiveFontSize(context, 14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Some description here about the chart data. This text might wrap.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: getResponsiveFontSize(context, 10),
                        ),
                      ),
                    ],
                  ),
                ),
                /// Details


              ],
            ),
          ),
        ],
      ),
    );
  }





}


