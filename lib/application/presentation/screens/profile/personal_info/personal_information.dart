
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/profile/profile_screen.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:provider/provider.dart';

import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/ListingFields.dart';
import '../../../../../framework/components/customDropDownComponent.dart';


class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {


  TextEditingController emailAddressController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


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
                        'Personal Information',
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

              // SizedBox(height: screenHeight * 0.01),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.01),

                          Center(
                              child: _profileHeaderSection(context)
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          Container(
                            width: double.infinity,
                            height: screenHeight ,

                            decoration: BoxDecoration(
                               image: const DecorationImage(
                                image: AssetImage('assets/icons/profileFrameBg.png'),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.circular(14),

                              border: const Border(
                                top: BorderSide(color: Color(0xFFFFF5ED), width: 0.1),
                                left: BorderSide(color: Color(0xFFFFF5ED), width: 0.1),
                                right: BorderSide(color: Color(0xFFFFF5ED), width: 0.1),
                                bottom: BorderSide.none,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),

                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                                vertical: screenHeight * 0.02,
                              ),
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  /// First & last Name
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                      Expanded(
                                        child: ListingField(
                                          controller: firstNameController,
                                          labelText: 'First Name',
                                          height: screenHeight * 0.05,
                                           expandable: false,
                                          keyboard: TextInputType.name,
                                        ),
                                      ),

                                       SizedBox(width: screenWidth * 0.01),

                                       Expanded(
                                         child: ListingField(
                                           controller: lastNameController,
                                           labelText: 'Last Name',
                                           height: screenHeight * 0.05,
                                            expandable: false,
                                           keyboard: TextInputType.name,
                                         ),
                                       ),

                                    ],
                                  ),

                                  SizedBox(height: screenHeight * 0.02),

                                  /// Email Address
                                  ListingField(
                                    controller: emailAddressController,
                                    labelText: 'Email Address',
                                    height: screenHeight * 0.05,
                                    width: screenWidth* 0.88,
                                    expandable: false,
                                    keyboard: TextInputType.name,
                                  ),

                                  SizedBox(height: screenHeight * 0.02),


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ListingField(
                                          // controller: firstNameController,
                                          labelText: '+880',
                                          height: screenHeight * 0.05,
                                          expandable: false,
                                          keyboard: TextInputType.name,
                                        ),
                                      ),

                                      SizedBox(width: screenWidth * 0.01),

                                      Expanded(
                                        flex: 4,
                                         child: ListingField(
                                          controller: lastNameController,
                                          labelText: 'Contract Number',
                                          height: screenHeight * 0.05,
                                          expandable: false,
                                          keyboard: TextInputType.number,
                                        ),
                                      ),

                                    ],
                                  ),



                                  SizedBox(height: screenHeight * 0.02),

                                   /// Country and Address
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                     crossAxisAlignment: CrossAxisAlignment.center,

                                     children: [
                                       Expanded(
                                         child: CustomDropdown(
                                           label: 'Country',
                                           items: const ['Dubai', 'USA', 'Bangladesh'],
                                           selectedValue: selectedGender,
                                           onChanged: (value) {
                                             setState(() {
                                               selectedGender = value;
                                             });
                                           },
                                         ),
                                       ),
                                       SizedBox(width: screenWidth * 0.01),

                                       Expanded(
                                         child: CustomDropdown(
                                           label: 'Gender',
                                           items: const ['Male', 'Female', 'Other'],
                                           selectedValue: selectedGender,
                                           onChanged: (value) {
                                             setState(() {
                                               selectedGender = value;
                                             });
                                           },
                                         ),
                                       ),
                                     ],
                                   ),


                                  SizedBox(height: screenHeight * 0.02),

                                  /// Address
                                  ListingField(
                                    controller: addressController,
                                    labelText: 'Address',
                                    height: screenHeight * 0.05,
                                    width: screenWidth* 0.88,
                                    expandable: false,
                                    keyboard: TextInputType.emailAddress,
                                  ),




                                   SizedBox(height: screenHeight * 0.05),

                                  BlockButton(
                                    height: screenHeight * 0.045,
                                    width: screenWidth * 0.7,
                                    label: 'Update Profile',
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      // fontSize: baseSize * 0.030,
                                      fontSize: getResponsiveFontSize(context, 16),
                                    ),
                                    gradientColors: const [
                                      Color(0xFF2680EF),
                                      Color(0xFF1CD494),
                                    ],
                                    onTap: () {
                                      // Update Personal Information , Save & Navigate back to Profile Screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const ProfileScreen(),
                                        ),
                                      );
                                    },
                                  ),

                                  SizedBox(height: screenHeight * 0.05),

                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Update Your Password',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: getResponsiveFontSize(context, 16),
                                        height: 1.6,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.03),

                                  ListingField(
                                    controller: oldPasswordController,
                                    labelText: 'Old Password',
                                    height: screenHeight * 0.05,
                                    expandable: false,
                                    keyboard: TextInputType.name,
                                  ),

                                  SizedBox(height: screenHeight * 0.02),
                                  ListingField(
                                    controller: newPasswordController,
                                    labelText: 'New Password',
                                    height: screenHeight * 0.05,
                                    expandable: false,
                                    keyboard: TextInputType.name,
                                  ),

                                  SizedBox(height: screenHeight * 0.02),

                                  ListingField(
                                    controller: confirmPasswordController,
                                    labelText: 'Confirm Password',
                                    height: screenHeight * 0.05,
                                    expandable: false,
                                    keyboard: TextInputType.name,
                                  ),

                                  SizedBox(height: screenHeight * 0.05),

                                  BlockButton(
                                    height: screenHeight * 0.045,
                                    width: screenWidth * 0.7,
                                    label: 'Update Password',
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      // fontSize: baseSize * 0.030,
                                      fontSize: getResponsiveFontSize(context, 16),
                                    ),
                                    gradientColors: const [
                                      Color(0xFF2680EF),
                                      Color(0xFF1CD494),
                                    ],
                                    onTap: () {
                                      // Update Personal Information , Save & Navigate back to Profile Screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const ProfileScreen(),
                                        ),
                                      );
                                    },
                                  ),


                                ],
                              ),
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


  Widget _profileHeaderSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double scale = screenWidth / 375;

    final profileVM = Provider.of<PersonalViewModel>(context);
    final pickedImage = profileVM.pickedImage;
    return Column(
      children: [
        Container(
          width: screenWidth * 0.5,
          padding: EdgeInsets.symmetric(vertical: 10 * scale),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: screenWidth * 0.26,
                    height: screenWidth * 0.26,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: pickedImage != null
                            ? FileImage(pickedImage)
                            : const NetworkImage("https://picsum.photos/90/90") as ImageProvider,
                        fit: BoxFit.contain,
                      ),
                      shape: OvalBorder(
                        side: BorderSide(width: 1 * scale, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => profileVM.pickImage(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          'assets/icons/editIcon.svg',
                          width: screenWidth * 0.055,
                          height: screenWidth * 0.05,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10 * scale),
              Text(
                'Abdur Salam',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20 * scale,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


}



