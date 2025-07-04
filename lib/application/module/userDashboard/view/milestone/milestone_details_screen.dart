 import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/milestone/widget/user_activity_table.dart';
import 'package:provider/provider.dart';
 import '../../../../../framework/components/rewardInfoCardComponent.dart';
import '../../../../../framework/components/userActivityProgressBarComponent.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../framework/utils/enums/milestone_status.dart';
import '../../../../../framework/utils/milestone_test_styles.dart';
import '../../../../../framework/utils/status_styling_utils.dart';
import '../../../../data/dummyData/user_activity_dummy_data.dart';
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

  List<Map<String, dynamic>> _filteredData = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filteredData = List.from(activityData);

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final textScale = screenWidth / 375;

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
                    horizontal: screenWidth * 0.01,
                    vertical: screenHeight * 0.01,
                  ),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),

                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),

                      child: Column(
                        children: [

                          /// Activity Status
                          headerStatistic(),

                          SizedBox(height: screenHeight * 0.03),

                          ///Progress Bar
                          Container(
                            width: double.infinity,
                            // height: screenHeight,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icons/userActivityProgressBg.png'),
                                fit: BoxFit.fill,
                               ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04,vertical: screenHeight * 0.02),

                            child: UserActivityProgressBar(
                              title: "Progress",
                              currentValue: 2,
                              maxValue: 5,
                              barColor: Color(0xff1CD494),
                              ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          /// Reward section
                          rewardInfoCard(),


                          SizedBox(height: screenHeight * 0.03),


                          Container(
                            width: double.infinity,
                             padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02,horizontal: screenWidth * 0.04),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/icons/userActivityLogBg2.png'),fit: BoxFit.fill,filterQuality: FilterQuality.high),

                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                Text(
                                  'User Activity Log',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: getResponsiveFontSize(context, 16),
                                    height: 1.6,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.02),
                                ...[
                                  _filteredData.isNotEmpty
                                      ? buildUserActivity(_filteredData, screenWidth, context)
                                      : Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(20),
                                    child: const Text(
                                      'No data found',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                ],

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



  Widget headerStatistic(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final containerWidth = screenWidth;


    final horizontalPadding = containerWidth * 0.028;

    return  Container(
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
                      '${widget.task.title}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: getResponsiveFontSize(context, 16),
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
                    // value: '10.000 ECM',
                    value: '${widget.task.targetSales}',
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
                    value: '${widget.task.deadline}',
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
                       fontSize: getResponsiveFontSize(context, 12),
                       color: Colors.white.withOpacity(0.8),
                       fontWeight: FontWeight.w400,
                       height: 1.6,
                     ),
                   ),
                 ),
               ] 
            ),
            SizedBox(height: screenHeight * 0.001),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: getResponsiveFontSize(context, 16),
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


  Widget rewardInfoCard(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image:  DecorationImage(
            image: AssetImage('assets/icons/rewardContainerBg.png'),filterQuality: FilterQuality.high,fit: BoxFit.fill
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04,vertical: screenHeight * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rewards',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: getResponsiveFontSize(context, 16),
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.6),
          ),

          SizedBox(height: screenHeight * 0.02),

          RewardInfoCard(
            imageUrl: 'assets/icons/worldTrip.png',
            message: 'We will provide you a tour trip from Dhaka to Cox’s Bazar for 2–3 days.',
          ),
          SizedBox(height: screenHeight * 0.02),

          RewardInfoCard(
            imageUrl: 'assets/icons/money.png',
            message: 'You will Get \$200 after completing the milestone',
          ),
          SizedBox(height: screenHeight * 0.02),

          RewardInfoCard(
            imageUrl: 'assets/icons/coin.png',
            message: 'You will Get 150 ECM after completing the milestone',
          ),


        ],
      ),
    );
  }


}


