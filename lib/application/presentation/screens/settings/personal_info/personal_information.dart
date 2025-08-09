import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/ListingFields.dart';
import '../../../../../framework/utils/customToastMessage.dart';
import '../../../../../framework/utils/enums/toast_type.dart';
import '../../../../domain/constants/api_constants.dart';
import '../../../models/user_model.dart';
import '../../../viewmodel/bottom_nav_provider.dart';
import 'package:http/http.dart' as http;

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _isProfileUpdated = false;
  bool _isLoading = false;

  String _originalFirstName = '';
  String _originalLastName = '';
  String _originalEmailAddress = '';
  String _originalPhoneNumber = '';
  String _originalAddress = '';

  @override
  void initState() {
    super.initState();

    _loadInitialProfileData().then((_) {
      firstNameController.addListener(_onFieldChanged);
      userNameController.addListener(_onFieldChanged);
      emailAddressController.addListener(_onFieldChanged);
      phoneNumberController.addListener(_onFieldChanged);
      addressController.addListener(_onFieldChanged);

      Provider.of<PersonalViewModel>(context, listen: false)
          .addListener(_onImageChanged);
    });
  }

  @override
  void dispose() {
    firstNameController.removeListener(_onFieldChanged);
    userNameController.removeListener(_onFieldChanged);
    emailAddressController.removeListener(_onFieldChanged);
    phoneNumberController.removeListener(_onFieldChanged);
    addressController.removeListener(_onFieldChanged);

    Provider.of<PersonalViewModel>(context, listen: false)
        .removeListener(_onImageChanged);

    // Dispose controllers to free up resources
    emailAddressController.dispose();
    firstNameController.dispose();
    userNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      final user = UserModel.fromJson(jsonDecode(userJson));
      firstNameController.text = user.name ?? '';
      userNameController.text = user.username ?? '';
      emailAddressController.text = user.email ?? '';
      phoneNumberController.text = user.phone ?? '';
      addressController.text = user.ethAddress ?? '';
    } else {
      firstNameController.text = prefs.getString('firstName') ?? '';
      userNameController.text = prefs.getString('userName') ?? '';
      emailAddressController.text = prefs.getString('emailAddress') ?? '';
      phoneNumberController.text = prefs.getString('phoneNumber') ?? '';
      addressController.text = prefs.getString('ethAddress') ?? '';
    }

    setState(() {
      _originalFirstName = firstNameController.text;
      _originalLastName = userNameController.text;
      _originalEmailAddress = emailAddressController.text;
      _originalPhoneNumber = phoneNumberController.text;
      _originalAddress = addressController.text;

      _isProfileUpdated = false;
    });
  }

  void _onFieldChanged() {
    final profileVM = Provider.of<PersonalViewModel>(context, listen: false);

    bool hasChanges = firstNameController.text != _originalFirstName ||
        userNameController.text != _originalLastName ||
        emailAddressController.text != _originalEmailAddress ||
        phoneNumberController.text != _originalPhoneNumber ||
        addressController.text != _originalAddress ||
        profileVM.hasImageChanged();

    if (hasChanges != _isProfileUpdated) {
      setState(() {
        _isProfileUpdated = hasChanges;
      });
    }
  }

  void _onImageChanged() {
    _checkForProfileChanges();
  }

  void _checkForProfileChanges() {
    final profileVM = Provider.of<PersonalViewModel>(context, listen: false);

    bool hasChanges = firstNameController.text != _originalFirstName ||
        userNameController.text != _originalLastName ||
        emailAddressController.text != _originalEmailAddress ||
        phoneNumberController.text != _originalPhoneNumber ||
        addressController.text != _originalAddress ||
        profileVM.hasImageChanged();

    if (hasChanges != _isProfileUpdated) {
      setState(() {
        _isProfileUpdated = hasChanges;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_isProfileUpdated) {
      ToastMessage.show(
        message: "No Changes Found",
        subtitle: "You haven't updated any profile information.",
        type: MessageType.info,
        duration: CustomToastLength.SHORT,
        gravity: CustomToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updatedProfile = {
      "name": firstNameController.text.trim(),
      "username": userNameController.text.trim(),
      "email": emailAddressController.text.trim(),
      "phone": phoneNumberController.text.trim(),
      "eth_address": addressController.text.trim(),
    };
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print(">>> No token found in SharedPreferences");
      ToastMessage.show(
        message: "Authentication Error",
        subtitle: "User token missing. Please log in again.",
        type: MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/update-profile');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updatedProfile),
      );

      print(">>> Token: $token");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          _originalFirstName = updatedProfile['name'] ?? '';
          _originalLastName = updatedProfile['username'] ?? '';
          _originalEmailAddress = updatedProfile['email'] ?? '';
          _originalPhoneNumber = updatedProfile['phone'] ?? '';
          _originalAddress = updatedProfile['eth_address'] ?? '';
          _isProfileUpdated = false;
        });

        await prefs.setString('firstName', updatedProfile['name'] ?? '');
        await prefs.setString('userName', updatedProfile['username'] ?? '');
        await prefs.setString('emailAddress', updatedProfile['email'] ?? '');
        await prefs.setString('phoneNumber', updatedProfile['phone'] ?? '');
        await prefs.setString(
            'ethAddress', updatedProfile['eth_address'] ?? '');

        Provider.of<BottomNavProvider>(context, listen: false)
            .setFullName("${updatedProfile['name'] ?? ''}".trim());

        print(">> Profile update successful:");
        print(">>Profile Updated : $responseData");
        ToastMessage.show(
          message: "Profile Updated",
          subtitle: "Your changes have been saved successfully.",
          type: MessageType.success,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );
      } else {
        print(">> Failed response: ${response.statusCode}");
        print(">> Response body: ${response.body}");
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print("Error updating profile: $e");
      if (mounted) {
        ToastMessage.show(
          message: "Update Failed",
          subtitle: "Could not update profile. Please try again.",
          type: MessageType.error,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> validateAndUpdatePassword() async {
    String newPass = newPasswordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty || newPass.length < 6) {
      ToastMessage.show(
        message: "Weak Password",
        subtitle: "New password must be at least 6 characters.",
        type: MessageType.info,
        duration: CustomToastLength.SHORT,
        gravity: CustomToastGravity.BOTTOM,
      );
      return;
    }

    if (newPass != confirmPass) {
      ToastMessage.show(
        message: "Password Mismatch",
        subtitle: "New password and confirmation do not match.",
        type: MessageType.error,
        duration: CustomToastLength.SHORT,
        gravity: CustomToastGravity.BOTTOM,
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/update-password');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'password': newPass,
          'password_confirmation': confirmPass,
        }),
      );

      if (response.statusCode == 200) {
        newPasswordController.clear();
        confirmPasswordController.clear();

        ToastMessage.show(
          message: "Password Updated",
          subtitle: "Your password has been changed successfully.",
          type: MessageType.success,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );

        Navigator.popUntil(context, (route) => route.isFirst);
        Future.delayed(const Duration(milliseconds: 100), () {
          Provider.of<BottomNavProvider>(context, listen: false).setIndex(4);
        });
      } else {
        throw Exception('Password update failed');
      }
    } catch (e) {
      print("Error updating password: $e");
      ToastMessage.show(
        message: "Update Failed",
        subtitle: "Could not update password. Please try again.",
        type: MessageType.error,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/icons/back_button.svg',
                        color: Colors.white,
                        width: screenWidth * 0.04,
                        height: screenWidth * 0.04),
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
                  SizedBox(width: screenWidth * 0.12),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: screenHeight * 0.01),
                            Center(child: _profileHeaderSection(context)),
                            SizedBox(height: screenHeight * 0.03),
                            Container(
                              width: double.infinity,
                              height: screenHeight,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/profileFrameBg.png'),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                border: const Border(
                                  top: BorderSide(
                                      color: Color(0xFFFFF5ED), width: 0.1),
                                  left: BorderSide(
                                      color: Color(0xFFFFF5ED), width: 0.1),
                                  right: BorderSide(
                                      color: Color(0xFFFFF5ED), width: 0.1),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    /// First & last Name
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ListingField(
                                            controller: firstNameController,
                                            labelText: 'Name',
                                            height: screenHeight * 0.05,
                                            expandable: false,
                                            keyboard: TextInputType.name,
                                            onChanged: (value) =>
                                                _onFieldChanged(),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        Expanded(
                                          child: ListingField(
                                            controller: userNameController,
                                            labelText: 'Username',
                                            height: screenHeight * 0.05,
                                            expandable: false,
                                            keyboard: TextInputType.name,
                                            onChanged: (value) =>
                                                _onFieldChanged(),
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
                                      width: screenWidth * 0.88,
                                      expandable: false,
                                      keyboard: TextInputType.name,
                                      onChanged: (value) => _onFieldChanged(),
                                    ),

                                    SizedBox(height: screenHeight * 0.02),

                                    ListingField(
                                      controller: phoneNumberController,
                                      labelText: 'Contract Number',
                                      height: screenHeight * 0.05,
                                      expandable: false,
                                      keyboard: TextInputType.number,
                                      onChanged: (value) => _onFieldChanged(),
                                    ),

                                    SizedBox(height: screenHeight * 0.02),

                                    /// Address
                                    ListingField(
                                      controller: addressController,
                                      labelText: 'Address',
                                      height: screenHeight * 0.05,
                                      width: screenWidth * 0.88,
                                      expandable: false,
                                      keyboard: TextInputType.emailAddress,
                                      onChanged: (value) => _onFieldChanged(),
                                    ),

                                    SizedBox(height: screenHeight * 0.05),

                                    if (_isLoading)
                                      const Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white))
                                    else
                                      BlockButton(
                                        height: screenHeight * 0.045,
                                        width: screenWidth * 0.7,
                                        label: 'Update Profile',
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          // fontSize: baseSize * 0.030,
                                          fontSize: getResponsiveFontSize(
                                              context, 16),
                                        ),
                                        gradientColors: const [
                                          Color(0xFF2680EF),
                                          Color(0xFF1CD494),
                                        ],
                                        onTap: _isProfileUpdated
                                            ? _updateProfile
                                            : () {
                                                ToastMessage.show(
                                                    message:
                                                        "No Changes Detected",
                                                    subtitle:
                                                        "You haven't made any edits to your profile.",
                                                    type: MessageType.info,
                                                    duration:
                                                        CustomToastLength.SHORT,
                                                    gravity: CustomToastGravity
                                                        .BOTTOM);
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
                                          fontSize: getResponsiveFontSize(
                                              context, 16),
                                          height: 1.6,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.03),

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
                                        fontSize:
                                            getResponsiveFontSize(context, 16),
                                      ),
                                      gradientColors: const [
                                        Color(0xFF2680EF),
                                        Color(0xFF1CD494),
                                      ],
                                      onTap: () => validateAndUpdatePassword(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
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

    final fullName = (firstNameController.text.isNotEmpty ||
            userNameController.text.isNotEmpty)
        ? "${firstNameController.text} ${userNameController.text}".trim()
        : "Your Name";

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
                        // image:profileImage,
                        image: pickedImage != null
                            ? FileImage(pickedImage)
                            : (profileVM.originalImagePath != null &&
                                    File(profileVM.originalImagePath!)
                                        .existsSync())
                                ? FileImage(File(profileVM.originalImagePath!))
                                : const NetworkImage(
                                        "https://mycoinpoll.com/_ipx/q_20&s_50x50/images/dashboard/icon/user.png")
                                    as ImageProvider,

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
                // 'Abdur Salam',
                fullName,
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
