import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/personal_information_viewmodel/personal_view_model.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/ListingFields.dart';
import '../../../../../framework/components/customDropDownComponent.dart';
import '../../../../../framework/utils/customToastMessage.dart';
import '../../../../../framework/utils/enums/toast_type.dart';
import '../../../viewmodel/bottom_nav_provider.dart';


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
  String _selectedGender = 'Male';
  String _selectedCountry = 'USA';
  bool _isProfileUpdated = false;
  bool _isLoading = false;
  // String fullName = '';




  // Store original values to check for changes
  String _originalFirstName = '';
  String _originalLastName = '';
  String _originalEmailAddress = '';
  String _originalPhoneNumber = '';
  String _originalAddress = '';
  String _originalSelectedGender = '';
  String _originalSelectedCountry = '';
  String _storedPassword = '';


  @override
  void initState() {
    super.initState();
    // fullName = '${firstNameController.text} ${lastNameController.text}';

    _loadInitialProfileData().then((_) {
      firstNameController.addListener(_onFieldChanged);
      lastNameController.addListener(_onFieldChanged);
      emailAddressController.addListener(_onFieldChanged);
      phoneNumberController.addListener(_onFieldChanged);
      addressController.addListener(_onFieldChanged);

      Provider.of<PersonalViewModel>(context, listen: false).addListener(_onImageChanged);


    });
  }

  @override
  void dispose() {
    firstNameController.removeListener(_onFieldChanged);
    lastNameController.removeListener(_onFieldChanged);
    emailAddressController.removeListener(_onFieldChanged);
    phoneNumberController.removeListener(_onFieldChanged);
    addressController.removeListener(_onFieldChanged);

    Provider.of<PersonalViewModel>(context, listen: false).removeListener(_onImageChanged);


    // Dispose controllers to free up resources
    emailAddressController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    // For demonstration, let's pre-fill some data
    // In a real api fetch this from an API
    firstNameController.text = prefs.getString('firstName') ?? 'John';
    lastNameController.text = prefs.getString('lastName') ?? 'Doe';
    emailAddressController.text = prefs.getString('emailAddress') ?? 'john.doe@example.com';
    phoneNumberController.text = prefs.getString('phoneNumber') ?? '1234567890';
    addressController.text = prefs.getString('address') ?? '123 Main St, Anytown';
    _storedPassword = prefs.getString('password') ?? '123456';  // fallback
    oldPasswordController.text = _storedPassword;

    String? loadedGender = prefs.getString('gender');
    String? loadedCountry = prefs.getString('country');
    setState(() {
      _selectedGender = (loadedGender != null && ['Male', 'Female', 'Other'].contains(loadedGender))
          ? loadedGender
          : 'Male';
      _selectedCountry = (loadedCountry != null && ['Dubai', 'USA', 'Bangladesh'].contains(loadedCountry))
          ? loadedCountry
          : 'USA';

      // Store original values from loaded data (ensuring they are non-nullable)
      _originalFirstName = firstNameController.text;
      _originalLastName = lastNameController.text;
      _originalEmailAddress = emailAddressController.text;
      _originalPhoneNumber = phoneNumberController.text;
      _originalAddress = addressController.text;
      _originalSelectedGender = _selectedGender;
      _originalSelectedCountry = _selectedCountry;
      // Initially, no changes have been made after loading
      _isProfileUpdated = false;
    });
  }

  void _onFieldChanged() {
    final profileVM = Provider.of<PersonalViewModel>(context, listen: false);

    bool hasChanges =
        firstNameController.text != _originalFirstName ||
            lastNameController.text != _originalLastName ||
            emailAddressController.text != _originalEmailAddress ||
            phoneNumberController.text != _originalPhoneNumber ||
            addressController.text != _originalAddress ||
            _selectedGender != _originalSelectedGender ||
            _selectedCountry != _originalSelectedCountry;
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
        lastNameController.text != _originalLastName ||
        emailAddressController.text != _originalEmailAddress ||
        phoneNumberController.text != _originalPhoneNumber ||
        addressController.text != _originalAddress ||
        _selectedGender != _originalSelectedGender ||
        _selectedCountry != _originalSelectedCountry ||
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

    // Collect all data
    final Map<String, dynamic> updatedProfile = {
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "emailAddress": emailAddressController.text.trim(),
      "phoneNumber": phoneNumberController.text.trim(),
      "country": _selectedCountry ?? '',
      "gender": _selectedGender ?? '',
      "address": addressController.text.trim(),
    };

    try {
      await Future.delayed(const Duration(seconds: 1));

      // ✅ Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', updatedProfile['firstName']);
      await prefs.setString('lastName', updatedProfile['lastName']);
      await prefs.setString('emailAddress', updatedProfile['emailAddress']);
      await prefs.setString('phoneNumber', updatedProfile['phoneNumber']);
      await prefs.setString('country', updatedProfile['country']);
      await prefs.setString('gender', updatedProfile['gender']);
      await prefs.setString('address', updatedProfile['address']);

      final profileVM = Provider.of<PersonalViewModel>(context, listen: false);
      if (profileVM.hasImageChanged()) {
        await profileVM.saveImageToPrefs();
      }

      // ✅ Update originals
      _originalFirstName = updatedProfile['firstName'];
      _originalLastName = updatedProfile['lastName'];
      _originalEmailAddress = updatedProfile['emailAddress'];
      _originalPhoneNumber = updatedProfile['phoneNumber'];
      _originalSelectedCountry = updatedProfile['country'];
      _originalSelectedGender = updatedProfile['gender'];
      _originalAddress = updatedProfile['address'];


      setState(() {
        _isProfileUpdated = false;
      });


      if (mounted) {

        if (mounted) {
          ToastMessage.show(
            message: "Profile Updated",
            subtitle: "Your changes have been saved successfully.",
            type: MessageType.success,
            duration: CustomToastLength.LONG,
            gravity: CustomToastGravity.BOTTOM,
          );

        // Navigate back
        Provider.of<BottomNavProvider>(context, listen: false).setFullName(
          '${updatedProfile['firstName']} ${updatedProfile['lastName']}',
        );
        Provider.of<BottomNavProvider>(context, listen: false).setIndex(4);


      }}


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
    String oldPass = oldPasswordController.text.trim();
    String newPass = newPasswordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    if (oldPass != _storedPassword) {
    ToastMessage.show(
    message: "Incorrect Password",
    subtitle: "The old password you entered is incorrect.",
    type: MessageType.error,
    duration: CustomToastLength.SHORT,
    gravity: CustomToastGravity.BOTTOM,
    );
      return;
    }

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
    await prefs.setString('password', newPass);

    setState(() {
      _storedPassword = newPass;
      oldPasswordController.text = newPass;
      newPasswordController.clear();
      confirmPasswordController.clear();
    });

    if (mounted) {
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
    }
  }


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
                                            onChanged: (value) => _onFieldChanged(),

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
                                             onChanged: (value) => _onFieldChanged(),

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
                                      onChanged: (value) => _onFieldChanged(),

                                    ),

                                    SizedBox(height: screenHeight * 0.02),


                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: ListingField(
                                            controller: TextEditingController(text: '+880'), // Fixed country code prefix
                                            labelText: '',
                                            height: screenHeight * 0.05,
                                            expandable: false,
                                            keyboard: TextInputType.name,
                                            onChanged: (value) {
                                              // later implement
                                            },
                                          ),
                                        ),

                                        SizedBox(width: screenWidth * 0.01),

                                        Expanded(
                                          flex: 4,
                                           child: ListingField(
                                            controller: phoneNumberController,
                                            labelText: 'Contract Number',
                                            height: screenHeight * 0.05,
                                            expandable: false,
                                            keyboard: TextInputType.number,
                                             onChanged: (value) => _onFieldChanged(),
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
                                             selectedValue: _selectedCountry,
                                             onChanged: (value) {
                                               setState(() {
                                                 _selectedCountry = value ?? _selectedCountry;
                                                 _onFieldChanged();

                                               });
                                             },
                                           ),
                                         ),
                                         SizedBox(width: screenWidth * 0.01),

                                         Expanded(
                                           child: CustomDropdown(
                                             label: 'Gender',
                                             items: const ['Male', 'Female', 'Other'],
                                             selectedValue: _selectedGender,
                                             onChanged: (value) {
                                               setState(() {
                                                 _selectedGender = value ?? _selectedCountry;
                                                 _onFieldChanged();
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
                                      onChanged: (value) => _onFieldChanged(),

                                    ),

                                     SizedBox(height: screenHeight * 0.05),

                                    if (_isLoading)
                                      const Center(child: CircularProgressIndicator(color: Colors.white))
                                    else
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

                                        onTap: _isProfileUpdated ? _updateProfile : () {

                                        ToastMessage.show(
                                          message: "No Changes Detected",
                                          subtitle: "You haven't made any edits to your profile.",
                                          type: MessageType.info,duration: CustomToastLength.SHORT,
                                          gravity: CustomToastGravity.BOTTOM);

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

                                      onTap: () => validateAndUpdatePassword(),

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

    final fullName = (firstNameController.text.isNotEmpty || lastNameController.text.isNotEmpty)
        ? "${firstNameController.text} ${lastNameController.text}".trim()
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
                        // image: pickedImage != null
                        //     ? FileImage(pickedImage)
                        //     : const NetworkImage("https://picsum.photos/90/90") as ImageProvider,

                        image: pickedImage != null
                            ? FileImage(pickedImage)
                            : (profileVM.originalImagePath != null && File(profileVM.originalImagePath!).existsSync())
                            ? FileImage(File(profileVM.originalImagePath!))
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



