import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/ListingFields.dart';
import '../../../../../framework/widgets/custom_contact_info.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {


  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

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

              image: AssetImage('assets/icons/solidBackGround.png'),
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
                        'Contact',
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

              SizedBox(height: screenHeight * 0.01),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          SizedBox(height: screenHeight * 0.02),


                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.05,
                              vertical: MediaQuery.of(context).size.height * 0.02,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff040C16),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min, // Content height
                              children: [

                                ListingField(
                                  controller: fullNameController,
                                  labelText: 'Full Name',
                                  height: screenHeight * 0.049,
                                  width: screenWidth* 0.88,
                                  expandable: false,
                                  keyboard: TextInputType.name,
                                ),

                                SizedBox(height: screenHeight * 0.02),

                                ListingField(
                                  controller: emailAddressController,
                                  labelText: 'Email',
                                  height: screenHeight * 0.049,
                                  width: screenWidth* 0.88,
                                  expandable: false,
                                  keyboard: TextInputType.emailAddress,
                                ),


                                SizedBox(height: screenHeight * 0.02),

                                ListingField(
                                  controller: subjectController,
                                  labelText: 'Subject',
                                  height: screenHeight * 0.049,
                                  width: screenWidth* 0.88,
                                  expandable: false,
                                  keyboard: TextInputType.multiline,
                                ),

                                SizedBox(height: screenHeight * 0.02),

                                ListingField(
                                  controller: messageController,
                                  labelText: 'Message',
                                  height: screenHeight * 0.3,
                                  width: screenWidth* 0.88,
                                  expandable: true,
                                  keyboard: TextInputType.multiline,
                                ),

                                SizedBox(height: screenHeight * 0.03),

                                BlockButton(
                                  height: screenHeight * 0.045,
                                  width: screenWidth * 0.6,
                                  label: 'Submit',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: baseSize * 0.044,
                                  ),
                                  gradientColors: const [
                                    Color(0xFF2680EF),
                                    Color(0xFF1CD494),
                                  ],
                                  onTap: () {

                                  },
                                ),

                                SizedBox(height: screenHeight * 0.01),



                              ],
                            ),
                          ),


                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.02,
                              vertical: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: const CustomContactInfo(
                              phoneNumber: '012 3456 789',
                              emailAddress: 'info@mycoinpoll.com',
                            ),
                          ),



                        ],
                      )
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



