import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/ListingFields.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';

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


                ContactInfoWidget(
                            phoneNumber: '012 3456 789',
                            emailAddress: 'info@mycoinpoll.com',
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


class ContactInfoWidget extends StatelessWidget {
  final String phoneNumber;
  final String emailAddress;

  const ContactInfoWidget({
    Key? key,
    required this.phoneNumber,
    required this.emailAddress,
  }) : super(key: key);

  // Function to launch phone dialer
  Future<void> _callPhone(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('Could not launch $launchUri');
    }
  }

  // Function to launch email client
  Future<void> _sendEmail(String emailAddress) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: emailAddress);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF101A29), // Dark background
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Flex(
        direction: isTablet ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _callPhone(phoneNumber),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.phone, color: Colors.tealAccent),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PHONE',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          phoneNumber,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isTablet ? 0 : screenHeight * 0.02, width: isTablet ? screenWidth * 0.04 : 0),
          Expanded(
            child: InkWell(
              onTap: () => _sendEmail(emailAddress),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.email, color: Colors.tealAccent),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EMAIL',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          emailAddress,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.04,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class ContactInfoWidget extends StatefulWidget {
//   final String phoneNumber;
//   final String emailAddress;
//
//   const ContactInfoWidget({
//     Key? key,
//     required this.phoneNumber,
//     required this.emailAddress,
//   }) : super(key: key);
//
//   @override
//   State<ContactInfoWidget> createState() => _ContactInfoWidgetState();
// }
//
// class _ContactInfoWidgetState extends State<ContactInfoWidget> {
//   // Function to launch phone dialer
//   Future<void> _callPhone(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     if (await canLaunchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     } else {
//       // Handle error, e.g., show a Snackbar
//       print('Could not launch $launchUri');
//     }
//   }
//
//   // Function to launch email client
//   Future<void> _sendEmail(String emailAddress) async {
//     final Uri launchUri = Uri(
//       scheme: 'mailto',
//       path: emailAddress,
//     );
//     if (await canLaunchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     } else {
//       // Handle error, e.g., show a Snackbar
//       print('Could not launch $launchUri');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Container(
//       width: screenWidth,
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[850], // Dark background color
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           // Phone Section
//           Expanded(
//             child: InkWell(
//               onTap: () => _callPhone(widget.phoneNumber),
//               child: Row(
//                 children: [
//                   const Icon(Icons.phone, color: Colors.tealAccent), // Phone icon
//                   const SizedBox(width: 8.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'PHONE',
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 12.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         widget.phoneNumber,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: 16.0), // Space between sections
//
//           // Email Section
//           Expanded(
//             child: InkWell(
//               onTap: () => _sendEmail(widget.emailAddress),
//               child: Row(
//                 children: [
//                   const Icon(Icons.email, color: Colors.tealAccent), // Email icon
//                   const SizedBox(width: 8.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'EMAIL',
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 12.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         widget.emailAddress,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16.0,
//                         ),
//                         overflow: TextOverflow.ellipsis, // Prevent overflow
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }