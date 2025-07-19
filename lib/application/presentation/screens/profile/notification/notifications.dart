import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../framework/components/SwitcherComponent.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {


  String? selectedGender;
  String? selectedCountry;


  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;


    return  Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:  Colors.transparent,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: Color(0xFF01090B),
            image: DecorationImage(

              image: AssetImage('assets/images/solidBackGround.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: screenHeight * 0.01),

              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                        'assets/icons/back_button.svg',
                        color: Colors.white,
                        width: screenWidth * 0.04,
                        height: screenWidth * 0.04
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Notification Settings',
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
                  SizedBox(width: screenWidth * 0.12), // Responsive spacer for balance
                ],
              ),

              SizedBox(height: screenHeight * 0.01),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,


                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.03),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Common",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.05,
                              ),),
                            ),
                            SizedBox(height: screenHeight * 0.02),


                            SwitcherComponent(
                              title: 'General Notification',
                              //call the api data  apiResponseData['isNotificationEnabled'] ?? false,
                              initialSwitchValue: false,
                              onToggle: (value) {
                                // Call your API to update value
                                // updateNotificationSetting(value);
                              },
                            ),
                            SwitcherComponent(
                              title: 'Sound',
                              //call the api data  apiResponseData['isNotificationEnabled'] ?? false,
                              initialSwitchValue: false,
                              onToggle: (value) {
                                // Call your API to update value
                                // updateNotificationSetting(value);
                              },
                            ),
                            SwitcherComponent(
                              title: 'Vibrate',
                              //call the api data  apiResponseData['isNotificationEnabled'] ?? false,
                              initialSwitchValue: false,
                              onToggle: (value) {
                                // Call your API to update value
                                // updateNotificationSetting(value);
                              },
                            ),


                            SizedBox(height: screenHeight * 0.03),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "System & services update",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.05,
                                ),),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            SwitcherComponent(
                              title: 'App updates',
                              //call the api data  apiResponseData['isNotificationEnabled'] ?? false,
                              initialSwitchValue: false,
                              onToggle: (value) {
                                // Call your API to update value
                                // updateNotificationSetting(value);
                              },
                            ),
                            SwitcherComponent(
                              title: 'Bill Reminder',
                              //call the api data  apiResponseData['isNotificationEnabled'] ?? false,
                              initialSwitchValue: false,
                              onToggle: (value) {
                                // Call your API to update value
                                // updateNotificationSetting(value);
                              },
                            ),
                            SwitcherComponent(
                              title: 'Promotion',
                              //call the api data  apiResponseData['isNotificationEnabled'] ?? false,
                              initialSwitchValue: false,
                              onToggle: (value) {
                                // Call your API to update value
                                // updateNotificationSetting(value);
                              },
                            ),
                            SwitcherComponent(
                              title: 'Discount Available',
                              //call the api data  apiResponseData['isNotificationEnabled'] ?? false,
                              initialSwitchValue: false,
                              onToggle: (value) {
                                // Call your API to update value
                                // updateNotificationSetting(value);
                              },
                            ),
                            SwitcherComponent(
                              title: 'Payment Request',
                              //call the api data  apiResponseData['isNotificationEnabled'] ?? false,
                              initialSwitchValue: false,
                              onToggle: (value) {
                                // Call your API to update value
                                // updateNotificationSetting(value);
                              },
                            ),


                            SizedBox(height: screenHeight * 0.03),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "System & services update",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.05,
                                ),),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            SwitcherComponent(
                              title: 'New Service Available',
                              //call the api data  apiResponseData['isNotificationEnabled'] ?? false,
                              initialSwitchValue: false,
                              onToggle: (value) {
                                // Call your API to update value
                                // updateNotificationSetting(value);
                              },
                            ),
                            SwitcherComponent(
                              title: 'New Tips Available',
                              //call the api data  apiResponseData['isNotificationEnabled'] ?? false,
                              initialSwitchValue: false,
                              onToggle: (value) {
                                // Call your API to update value
                                // updateNotificationSetting(value);
                              },
                            ),

                          ],
                        )
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


