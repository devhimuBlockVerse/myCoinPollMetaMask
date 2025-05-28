import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/milestone_status.dart';
import '../../../../../framework/utils/milestone_test_styles.dart';
import '../../../../../framework/utils/status_styling_utils.dart';
import '../../../../domain/model/milestone_list_models.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';

class MilestoneDetailsScreen extends StatefulWidget {
  final EcmTaskModel task;

  const MilestoneDetailsScreen({super.key, required this.task});

  @override
  State<MilestoneDetailsScreen> createState() => _MilestoneDetailsScreenState();
}

class _MilestoneDetailsScreenState extends State<MilestoneDetailsScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final containerWidth = screenWidth;


    final horizontalPadding = containerWidth * 0.028;

     final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 80,
      drawer: SideNavBar(
        currentScreenId: currentScreenId,
        navItems: navItems,
        onScreenSelected: (id) => navProvider.setScreen(id),
        onLogoutTapped: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logout Pressed")),
          );
        },
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          // height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/starGradientBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              // App bar row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/back_button.svg',
                      color: Colors.white,
                      width: screenWidth * 0.04,
                      height: screenWidth * 0.04,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Milestone Details',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.05,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.12),
                ],
              ),

              // Main content area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  child: ListView(
                    children: [

                      Container(
                        width: double.infinity,
                        padding: EdgeInsetsDirectional.zero,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/icons/rootContentBg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding,vertical: screenHeight * 0.015,),
                          child: Column(
                            children: [


                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xff040C16),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03,
                                    vertical:  screenHeight * 0.005
                                ),

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Sell 1000 ECM Coin',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: getResponsiveFontSize(context, 18),
                                          height: 1.6,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,

                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: _buildStatusBadge(context))),
                                  ],
                                ),
                              ),


                              SizedBox(height: screenHeight * 0.03),

                              /// Target Sales , Achieved Sales
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      leadingImageUrl: 'assets/icons/targetSalesImg.svg',
                                      title: 'Target Sales',
                                      value: '10.000 ECM',
                                      gradient: const LinearGradient(
                                        begin: Alignment(0.99, 0.14),
                                        end: Alignment(-0.99, -0.14),
                                        colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                      ),
                                     ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Expanded(
                                    child: _buildStatCard(
                                      leadingImageUrl: 'assets/icons/achivedSalesImg.svg',

                                      title: 'Achieved Sales',
                                      value: '5.8589 ECM',
                                      gradient: const LinearGradient(
                                        begin: Alignment(0.99, 0.14),
                                        end: Alignment(-0.99, -0.14),
                                        colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                      ),
                                     ),
                                  ),
                                 ],
                              ),
                              SizedBox(height: screenHeight * 0.014),

                              /// Start Date , Deadline
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      leadingImageUrl: 'assets/icons/startDateImg.svg',
                                      title: 'Start Date',
                                      value: '1st June 2025',
                                      valueTextColor: Color(0xff8BE896),
                                      gradient: const LinearGradient(
                                        begin: Alignment(0.99, 0.14),
                                        end: Alignment(-0.99, -0.14),
                                        colors: [Color(0xFF101A29), Color(0xFF162B4A), Color(0xFF132239)],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),

                                  Expanded(
                                    child: _buildStatCard(
                                      leadingImageUrl: 'assets/icons/deadLineImg.svg',
                                      title: 'Deadline',
                                      value: '1st June 2025',
                                      valueTextColor: Color(0xffE04043),
                                      gradient: const LinearGradient(
                                        begin: Alignment(0.99, 0.14),
                                        end: Alignment(-0.99, -0.14),
                                        colors: [Color(0xFF101A29), Color(0xFF162B4A), Color(0xFF132239)],
                                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildStatusBadge(BuildContext context) {
    String text;

    switch (widget.task.status) {
      case EcmTaskStatus.ongoing:
        text = "On Going";
        break;
      case EcmTaskStatus.completed:
        text = "Completed";
        break;
      default:
        text = "Unknown";
    }

    final styling = getMilestoneStatusStyling(text);

     final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

     final horizontalPadding = screenWidth * 0.02;
    final verticalPadding = screenHeight * 0.005;
    final fontSize = 12 * textScale;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Color(0xff2680EF).withOpacity(0.20),
        border: Border.all(color: Color(0xff2680EF)),
        borderRadius: BorderRadius.circular(screenWidth * 0.01),
      ),
      child: Text(
        text,
        style: AppTextStyles.statusBadgeText.copyWith(
          fontSize: fontSize,
          color: styling.textColor,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    Color? valueTextColor,
    required LinearGradient gradient,
     String? leadingImageUrl,
    Color? borderColor,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final borderRadius = screenWidth * 0.009;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient,
        border: Border.all(
          color: borderColor ?? const Color(0xFF2B2D40),
          width: 1,
        ),
        image: DecorationImage(
          image: AssetImage('assets/icons/milestoneStatFrameBg.png'),
          fit: BoxFit.fill,
        )
      ),
      padding: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical:  screenHeight * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 SvgPicture.asset(
                   width: screenWidth * 0.03,
                   leadingImageUrl!,fit: BoxFit.fill,color: Colors.white.withOpacity(0.8),),

                 SizedBox(width: screenWidth * 0.008),
                 FittedBox(
                   fit: BoxFit.scaleDown,
                   alignment: Alignment.centerLeft,
                   child: Text(
                     title,
                     style: TextStyle(
                       fontFamily: 'Poppins',
                       fontSize: getResponsiveFontSize(context, 13),
                       color: Colors.white.withOpacity(0.8),
                       fontWeight: FontWeight.w400,
                       height: 1.6,
                     ),
                   ),
                 ),
               ] 
            ),
            SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: getResponsiveFontSize(context, 18),
                  fontWeight: FontWeight.w500,
                  color: valueTextColor ?? Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
