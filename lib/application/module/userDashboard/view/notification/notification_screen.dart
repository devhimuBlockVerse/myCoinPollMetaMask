import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/utils/status_styling_utils.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Example notification data
  final List<Map<String, dynamic>> notifications = [
    {
      'avatar': 'https://randomuser.me/api/portraits/men/1.jpg',
      'message': 'Lorem Ipsum is simply dummy text',
      'mention': '@Nicholas Hyde',
      'mentionMessage': 'Lorem Ipsum is simply dummy text of the',
      'time': '1 hr',
      'actions': false,
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/men/2.jpg',
      'message': 'Lorem Ipsum is simply dummy text',
      'time': '1 hr',
      'actions': true,
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/men/1.jpg',
      'message': 'Lorem Ipsum is simply dummy text',
      'time': '1 hr',
      'actions': false,
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/men/1.jpg',
      'message': 'Lorem Ipsum is simply dummy text',
      'time': '1 hr',
      'actions': false,
    },
  ];


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

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
              image: AssetImage('assets/images/starGradientBg.png'),
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
                        'Notifications',
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
                     child: ListView.separated(
                       physics: const BouncingScrollPhysics(),
                       padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01,
                      ),
                      itemCount: notifications.length,
                      separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.02),
                      itemBuilder: (context, index) {
                        final notif = notifications[index];

                        double avatarRadius = screenWidth * 0.058;
                        double horizontalSpacing = screenWidth * 0.03;
                        double mainFontSize = screenWidth * 0.037;
                        double mentionFontSize = screenWidth * 0.032;
                         double timeFontSize = screenWidth * 0.032;
                         double buttonFontSize = screenWidth * 0.032;
                        double buttonPaddingH = screenWidth * 0.03;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: avatarRadius,
                              backgroundImage: NetworkImage(notif['avatar']),
                            ),
                            SizedBox(width: horizontalSpacing),
                            // Message and actions
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Main message
                                  Text(
                                    notif['message'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: mainFontSize,
                                    ),
                                  ),
                                  // Mentioned message (if any)
                                  if (notif['mention'] != null)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: screenHeight * 0.005,
                                        left: screenWidth * 0.02,
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: notif['mention'] + ' ',
                                              style: TextStyle(
                                                color: Color(0xFF3B82F6),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Poppins',
                                                fontSize: mentionFontSize,
                                              ),
                                            ),
                                            TextSpan(
                                              text: notif['mentionMessage'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                                fontSize: mentionFontSize,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  // Action buttons
                                  if (notif['actions'] == true)
                                    Padding(
                                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                                      child: Row(
                                        children: [

                                          ...['Accept', 'Decline'].map((action) {
                                            final style = getActionStatusStyle(action);
                                            return Padding(
                                              padding: EdgeInsets.only(right: action == 'Accept' ? screenWidth * 0.02 : 0),
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: style.backgroundColor,
                                                  side: BorderSide(color: style.borderColor),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(screenWidth * 0.016),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    // vertical: buttonPaddingV,
                                                    horizontal: buttonPaddingH,
                                                  ),
                                                ),
                                                onPressed: () {},
                                                child: Text(
                                                  action,
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: buttonFontSize,
                                                    color: style.textColor,
                                                    height: 1.6
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),

                                         ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Time
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.02,
                                top: screenHeight * 0.003,
                              ),
                              child: Text(
                                notif['time'],
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontFamily: 'Poppins',
                                  fontSize: timeFontSize,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
}
