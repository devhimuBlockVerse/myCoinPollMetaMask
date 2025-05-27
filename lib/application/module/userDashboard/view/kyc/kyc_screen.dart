import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/module/userDashboard/view/kyc/widget/milestone_lists.dart';
import 'package:provider/provider.dart';

import '../../../../../framework/res/colors.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';


//enum CLass
enum EcmTaskStatus { active, ongoing, completed }
//Model
class RewardModel {
  final String? primaryReward; // e.g., "$200 USD" or "Tour Trip"
  final String? secondaryReward; // e.g., "200 USD" (if primary is "Tour Trip")

  RewardModel({this.primaryReward, this.secondaryReward});
}

class EcmTaskModel {
  final String id;
  final String title;
  final String imageUrl; // URL or local asset path for the image
  final String targetSales; // e.g., "1000 ECM"
  final String deadline; // e.g., "10 May 2025"
  final RewardModel reward;
  final String milestoneMessage; // e.g., "You will Get $200 after completing the milestone."
  final EcmTaskStatus status;

  EcmTaskModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.targetSales,
    required this.deadline,
    required this.reward,
    required this.milestoneMessage,
    required this.status,
  });
}

//Test style

class AppTextStyles {
   static const String _fontFamily = 'Poppins';



  static TextStyle  cardTitle(BuildContext context) {
    return  TextStyle(
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      fontSize: getResponsiveFontSize(context,16), // Adjust based on Figma
      fontWeight: FontWeight.w500,
      height: 1.3,
    );
  }

  static TextStyle cardSubtitle(BuildContext context) {
    return  TextStyle(
      fontFamily: _fontFamily,
      color: AppColors.textPrimary,
      fontSize: getResponsiveFontSize(context,12),
      fontWeight: FontWeight.w400,
      height: 0.8,


    );
  }

  static TextStyle rewardText (BuildContext context){
    return  TextStyle(
      fontFamily: _fontFamily,
      color: AppColors.accentGreen,
       fontWeight: FontWeight.w400,
      fontSize: getResponsiveFontSize(context,12),

    );
  }

  static TextStyle get rewardSecondaryText {
    return const TextStyle(
      fontFamily: _fontFamily,
      color: AppColors.accentGreen,
      fontSize: 13, // Adjust based on Figma
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle get buttonText {
    return const TextStyle(
      fontFamily: _fontFamily,
      color: Colors.white,
      fontSize: 14, // Adjust based on Figma
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get statusBadgeText {
    return const TextStyle(
      fontFamily: _fontFamily,
      color: Colors.white,
      fontSize: 10, // Adjust based on Figma
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle  milestoneText(BuildContext context) {
    return TextStyle(
      fontFamily: _fontFamily,
      color: AppColors.textSecondary,
      fontSize: getResponsiveFontSize(context,12),
      height: 1.3,
      fontStyle: FontStyle.italic
    );
  }
}




class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // In a real app, this data would come from an API via a state management solution
  final List<EcmTaskModel> _tasks = [
    EcmTaskModel(
      id: '1',
      title: 'Sell 1000 ECM Coin',
      imageUrl: 'https://picsum.photos/seed/1/200/220', // Placeholder image
      targetSales: '1000 ECM',
      deadline: '10 May 2025',
      reward: RewardModel(primaryReward: '\$200 USD'),
      milestoneMessage: 'You will Get \$200 after completing the milestone.',
      status: EcmTaskStatus.active,
    ),
    EcmTaskModel(
      id: '2',
      title: 'Engage Community for ECM',
      imageUrl: 'https://picsum.photos/seed/2/200/220', // Placeholder image
      targetSales: '500 Interactions',
      deadline: '15 June 2025',
      reward: RewardModel(primaryReward: 'Tour Trip; 200 USD'),
      milestoneMessage: 'You will Get Tour & \$200 after completing the milestone.',
      status: EcmTaskStatus.completed,
    ),
    EcmTaskModel(
      id: '3',
      title: 'Develop New ECM Feature',
      imageUrl: 'https://picsum.photos/seed/3/200/220', // Placeholder image
      targetSales: '1 Feature',
      deadline: '30 July 2025',
      reward: RewardModel(primaryReward: '\$350 USD'),
      milestoneMessage: 'You will Get \$350 after completing the milestone.',
      status: EcmTaskStatus.ongoing,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final containerWidth = screenWidth;
    final containerHeight = screenHeight * 0.10;
    final minContainerHeight = screenHeight * 0.002;

    final horizontalPadding = containerWidth * 0.03;
    final itemSpacing = screenWidth * 0.02;

    double getResponsiveRadius(double base) => base * (screenWidth / 360);
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
          width: screenWidth,
          height: screenHeight,
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                        'Kyc Screen',
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
                      // Stat Cards
                      Container(
                        width: screenWidth,
                        height: containerHeight < minContainerHeight
                            ? minContainerHeight
                            : containerHeight,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/icons/buildStatCardBG.png'),
                            fit: BoxFit.fill,
                          ),
                         ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  title: 'Total Milestone',
                                  value: '1250',
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.99, 0.14),
                                    end: Alignment(-0.99, -0.14),
                                    colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                  ),
                                  imageUrl: "assets/icons/milestoneStatFrameBg.png",
                                ),
                              ),
                              SizedBox(width: itemSpacing),
                              Expanded(
                                child: _buildStatCard(
                                  title: 'Active Milestone',
                                  value: '1200',
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.99, 0.14),
                                    end: Alignment(-0.99, -0.14),
                                    colors: [Color(0xFF040C16), Color(0xFF162B4A)],
                                  ),
                                  imageUrl: "assets/icons/milestoneStatFrameBg.png",
                                ),
                              ),
                              SizedBox(width: itemSpacing),
                              Expanded(
                                child: _buildStatCard(
                                  title: 'Complete',
                                  value: '1000',
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.99, 0.14),
                                    end: Alignment(-0.99, -0.14),
                                    colors: [Color(0xFF101A29), Color(0xFF162B4A), Color(0xFF132239)],
                                  ),
                                  imageUrl: "assets/icons/milestoneStatFrameBg.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.030),

                      // Milestone list
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          return MilestoneLists(task: _tasks[index]);
                        },
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


  Widget _buildStatCard({
    required String title,
    required String value,
    required LinearGradient gradient,
    String? imageUrl,
    Color? borderColor,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final borderRadius = screenWidth * 0.009;
    final verticalContentPadding = screenWidth * 0.02;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient,
        border: Border.all(
          color: borderColor ?? const Color(0xFF2B2D40),
          width: 1,
        ),
        image: imageUrl != null
            ? DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.fill,
        )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: verticalContentPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, 12),
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, 16),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
