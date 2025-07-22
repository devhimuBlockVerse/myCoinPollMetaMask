import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycoinpoll_metamask/application/presentation/screens/login/sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
 import '../../../../framework/components/BlockButton.dart';
import '../../../../framework/components/CustomRadioSelection.dart';
import '../../../../framework/components/ListingFields.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../framework/utils/customToastMessage.dart';
import '../../../../framework/utils/enums/toast_type.dart';
import '../../../domain/constants/api_constants.dart';
import '../../viewmodel/wallet_view_model.dart';


class ApplyForListingScreen extends StatefulWidget {
  const ApplyForListingScreen({super.key});

  @override
  _ApplyForListingScreenState createState() => _ApplyForListingScreenState();
}

class _ApplyForListingScreenState extends State<ApplyForListingScreen> {

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDetailsController = TextEditingController();
  TextEditingController projectStatusController = TextEditingController();

 TextEditingController backersAndAdvisorsController = TextEditingController();
 TextEditingController smartContractAuditController = TextEditingController();
 TextEditingController litepaperLinkController = TextEditingController();
 TextEditingController websiteLinkController = TextEditingController();
 TextEditingController mediumLinkController = TextEditingController();
 TextEditingController githubLinkController = TextEditingController();
 TextEditingController twitterLinkController = TextEditingController();
 TextEditingController telegramLinkController = TextEditingController();
 TextEditingController additionalDetailsController = TextEditingController();

  String selectedOptionPlatform = '';
  String selectedOptionTeam = '';

  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitApplication() async {

    final walletProvider = Provider.of<WalletViewModel>(context, listen: false);

     if (!walletProvider.isConnected) {
       ToastMessage.show(
         message: "Wallet Not Connected",
         subtitle: "Please connect your wallet before submitting the application.",
         type: MessageType.info,
         duration: CustomToastLength.LONG,
         gravity: CustomToastGravity.BOTTOM,
       );
      return;
    }


    if(!_validateForm(context)){
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final data = {
      "name": fullNameController.text.trim(),
      "email": emailAddressController.text.trim(),
      "project_name": projectNameController.text.trim(),
      "project_description": projectDetailsController.text.trim(),
      "project_status": projectStatusController.text.trim(),
      "platform": selectedOptionPlatform,
      "type": selectedOptionTeam,
      "investors": backersAndAdvisorsController.text.trim(),
      "smart_contract_audit": smartContractAuditController.text.trim(),
      "white_paper": litepaperLinkController.text.trim(),
      "website": websiteLinkController.text.trim(),
      "medium": mediumLinkController.text.trim(),
      "github": githubLinkController.text.trim(),
      "twitter": twitterLinkController.text.trim(),
      "telegram": telegramLinkController.text.trim(),
      "additional_comment": additionalDetailsController.text.trim(),
    };

    print(">>> JSON Body to Submit: ${jsonEncode(data)}");

    const apiUrl = "${ApiConstants.baseUrl}/submit-apply-launch";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

       print(">>> Apply For Listing API Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {

        ToastMessage.show(
          message: "Application Submitted",
          subtitle: "Your application has been submitted successfully.",
          type: MessageType.success,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );

        _clearFormFields();
      } else {
        String errorMessage = "Server responded with status: ${response.statusCode}";

        try{
          final errorBody = jsonDecode(response.body);
          if(errorBody is Map && errorBody.containsKey('message')){
            errorMessage = errorBody['message'];
          }else if(errorBody is Map && errorBody.containsKey('errors')){
            Map<String, dynamic> errors = errorBody['errors'];
            errorMessage = errors.values.expand((e)=> e as Iterable).join('\n');
          }
        }catch(e){
          print("Error parsing error response: $e");
        }

        ToastMessage.show(
          message: "Submission Failed",
          subtitle: "Server responded with status: ${response.statusCode}",
          type: MessageType.error,
          duration: CustomToastLength.LONG,
          gravity: CustomToastGravity.BOTTOM,
        );

      }
    } catch (e) {
      print(">>> Submission error: $e");

      ToastMessage.show(
        message: "Something Went Wrong",
        subtitle: "Unable to submit application. Please try again later.",
        type: MessageType.info,
        duration: CustomToastLength.LONG,
        gravity: CustomToastGravity.BOTTOM,
      );
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateForm(BuildContext context) {

    final Map<String, dynamic> fieldsToCheck = {
       "Full Name": fullNameController.text.trim(),
       "Email Address": emailAddressController.text.trim(),
       "Project Name": projectNameController.text.trim(),
       "Project Details": projectDetailsController.text.trim(),
       "Project Status": projectStatusController.text.trim(),
       "Blockchain/Platform": selectedOptionPlatform,
       "Team Type": selectedOptionTeam,
       "Backers/Advisors": backersAndAdvisorsController.text.trim(),
       "Smart Contract Audi": smartContractAuditController.text.trim(),
       "Litepaper/Whitepaper Link": litepaperLinkController.text.trim(),
       "Website Link": websiteLinkController.text.trim(),
       "Medium Link": mediumLinkController.text.trim(),
       "GitHub Link": githubLinkController.text.trim(),
       "Twitter Link": twitterLinkController.text.trim(),
       "Telegram Link": telegramLinkController.text.trim(),
       "Additional Comments": additionalDetailsController.text.trim(),
    };
 
    if(emailAddressController.text.trim().isNotEmpty && !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailAddressController.text.trim())){
      _showValidationError(context, 'Please enter a valid email address');
      return false;
    }

    for(final entry in fieldsToCheck.entries){
      if(entry.value == null || entry.value.toString().isEmpty){
        _showValidationError(context, '${entry.key} cannot be empty');
        return false;
      }
    }
    return true;
  }

  void _showValidationError(BuildContext context, String message) {
    ToastMessage.show(
      message: "Validation Error",
      subtitle: message,
      type: MessageType.error,
      duration: CustomToastLength.LONG,
      gravity: CustomToastGravity.TOP,
    );
  }

  void _clearFormFields() {
    fullNameController.clear();
    emailAddressController.clear();
    projectNameController.clear();
    projectDetailsController.clear();
    projectStatusController.clear();
    backersAndAdvisorsController.clear();
    smartContractAuditController.clear();
    litepaperLinkController.clear();
    websiteLinkController.clear();
    mediumLinkController.clear();
    githubLinkController.clear();
    twitterLinkController.clear();
    telegramLinkController.clear();
    additionalDetailsController.clear();

    setState(() {
      selectedOptionPlatform = '';
      selectedOptionTeam = '';
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailAddressController.dispose();
    projectNameController.dispose();
    projectDetailsController.dispose();
    projectStatusController.dispose();
    backersAndAdvisorsController.dispose();
    smartContractAuditController.dispose();
    litepaperLinkController.dispose();
    websiteLinkController.dispose();
    mediumLinkController.dispose();
    githubLinkController.dispose();
    twitterLinkController.dispose();
    telegramLinkController.dispose();
    additionalDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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

              image: AssetImage('assets/images/starGradientBg.png'),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,

              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [

              ///Back Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/back_button.svg',
                    color: Colors.white,
                      width: screenWidth * 0.04,
                      height: screenWidth * 0.04
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              /// Main Scrollable Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.01,
                    right: screenWidth * 0.01,
                    bottom: screenHeight * 0.02,
                  ),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),

                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),

                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                               _headerSection(context),

                              SizedBox(height: screenHeight * 0.02),

                              /// Login Button Section

                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0x232c2e41),
                                 ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: screenHeight * 0.012,
                                    left: screenWidth * 0.04,
                                    right: screenWidth * 0.04,
                                    bottom: screenHeight * 0.012,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      // Smaller Image
                                      Image.asset(
                                        'assets/images/warningImg.png',
                                        width: screenWidth * 0.07,
                                        height: screenWidth * 0.07,
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.medium,

                                      ),

                                      SizedBox(width: screenWidth * 0.02),

                                       Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: screenWidth * 0.027,
                                              height: 1.23,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              const TextSpan(text: 'Connect your '),
                                              WidgetSpan(
                                                alignment: PlaceholderAlignment.baseline,
                                                baseline: TextBaseline.alphabetic,
                                                child: ShaderMask(
                                                  shaderCallback: (bounds) => const LinearGradient(
                                                    colors: [Color(0xFF2680EF), Color(0xFF1CD494)],
                                                  ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                                  blendMode: BlendMode.srcIn,
                                                  child: Text(
                                                    'Web3 wallet',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: screenWidth * 0.027,
                                                      height: 1.23,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const TextSpan(text: ' to apply and verify.'),
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: screenWidth * 0.02),

                                      /// Login Now Button
                                      BlockButton(
                                        height: screenHeight * 0.038,
                                        width: screenWidth * 0.28,
                                        label: 'Login Now',
                                        textStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * 0.028,
                                          height: 0.8,
                                          color: Colors.white,
                                        ),
                                        gradientColors: const [
                                          Color(0xFF2680EF),
                                          Color(0xFF1CD494),
                                        ],
                                        onTap: () {
                                          // Action
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const SignIn()),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.06),


                              /// Listing  Section Form

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0XFF040C16),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xff000000),
                                      width: 1,

                                    )
                                  ),

                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             mainAxisSize: MainAxisSize.min,
                                             children: [

                                               /// Personal Information

                                               Text(
                                                'Personal Information:',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: baseSize * 0.045,
                                                  height: 1.2,
                                                  color: Colors.white,
                                                ),
                                              ),

                                               SizedBox(height: screenHeight * 0.02),

                                               ListingField(
                                                controller: fullNameController,
                                                 labelText: 'Full Name',
                                                 height: screenHeight * 0.05,
                                                  expandable: false,
                                                 keyboard: TextInputType.name,
                                              ),

                                               SizedBox(height: screenHeight * 0.02),

                                               ListingField(
                                                controller: emailAddressController,
                                                 labelText: 'Email Address',
                                                 height: screenHeight * 0.05,
                                                  expandable: false,
                                                 keyboard: TextInputType.emailAddress,
                                              ),

                                               SizedBox(height: screenHeight * 0.05),

                                               /// Project Information
                                               Text(
                                                 'Project Information:',
                                                 textAlign: TextAlign.start,
                                                 style: TextStyle(
                                                   fontFamily: 'Poppins',
                                                   fontWeight: FontWeight.w500,
                                                   fontSize: baseSize * 0.045,
                                                   height: 1.2,
                                                   color: Colors.white,
                                                 ),
                                               ),

                                               SizedBox(height: screenHeight * 0.02),

                                               ListingField(
                                                 controller: projectNameController,
                                                 labelText: 'Project Name',
                                                 height: screenHeight * 0.05,
                                                  expandable: false,
                                                 keyboard: TextInputType.name,
                                               ),

                                               SizedBox(height: screenHeight * 0.02),

                                               ListingField(
                                                 controller: projectDetailsController,
                                                 labelText: 'Project Details',
                                                 height:  screenHeight * 0.2,
                                                 expandable: true,
                                                 keyboard: TextInputType.multiline,
                                               ),

                                               SizedBox(height: screenHeight * 0.02),

                                               ListingField(
                                                 controller: projectStatusController,
                                                 labelText: 'Project Status (briefly)',
                                                 height: screenHeight * 0.1,
                                                 expandable: true,
                                                 keyboard: TextInputType.multiline,
                                               ),


                                               SizedBox(height: screenHeight * 0.05),

                                               ///Blockchain/Platform Radio Buttons
                                               Text(
                                                 'Blockchain/Platform:',
                                                 textAlign: TextAlign.start,
                                                 style: TextStyle(
                                                   fontFamily: 'Poppins',
                                                   fontWeight: FontWeight.w500,
                                                   fontSize: baseSize * 0.045,
                                                   height: 1.2,
                                                   color: Colors.white,
                                                 ),
                                               ),
                                               SizedBox(height: screenHeight * 0.02),
                                               CustomRadioOption(
                                                 label: 'Binance Smart Chain',
                                                 value: 'Binance Smart Chain',
                                                 selectedValue: selectedOptionPlatform,
                                                 onTap: () {
                                                   setState(() {
                                                     selectedOptionPlatform = 'Binance Smart Chain';
                                                   });
                                                 },
                                               ),
                                               SizedBox(height: screenHeight * 0.02),

                                               CustomRadioOption(
                                                 label: 'Solana',
                                                 value: 'Solana',
                                                 selectedValue: selectedOptionPlatform,
                                                 onTap: () {
                                                   setState(() {
                                                     selectedOptionPlatform = 'Solana';
                                                   });
                                                 },
                                               ),
                                               SizedBox(height: screenHeight * 0.02),

                                               CustomRadioOption(
                                                 label: 'Ethereum',
                                                 value: 'Ethereum',
                                                 selectedValue: selectedOptionPlatform,
                                                 onTap: () {
                                                   setState(() {
                                                     selectedOptionPlatform = 'Ethereum';
                                                   });
                                                 },
                                               ),
                                               SizedBox(height: screenHeight * 0.02),
                                               CustomRadioOption(
                                                 label: 'Polygon (Matic)',
                                                 value: 'Polygon (Matic)',
                                                 selectedValue: selectedOptionPlatform,
                                                 onTap: () {
                                                   setState(() {
                                                     selectedOptionPlatform = 'Polygon (Matic)';
                                                   });
                                                 },
                                               ),
                                               SizedBox(height: screenHeight * 0.02),
                                                CustomRadioOption(
                                                 label: 'Other',
                                                 value: 'Other',
                                                 selectedValue: selectedOptionPlatform,
                                                 onTap: () {
                                                   setState(() {
                                                     selectedOptionPlatform = 'Other';
                                                   });
                                                 },
                                               ),
                                               SizedBox(height: screenHeight * 0.05),

                                               ///Is your team Anon or Public?
                                               Text(
                                                 'Is your team Anon or Public?',
                                                 textAlign: TextAlign.start,
                                                 style: TextStyle(
                                                   fontFamily: 'Poppins',
                                                   fontWeight: FontWeight.w500,
                                                   fontSize: baseSize * 0.045,
                                                   height: 1.2,
                                                   color: Colors.white,
                                                 ),
                                               ),

                                               SizedBox(height: screenHeight * 0.02),
                                               CustomRadioOption(
                                                 label: 'Anon',
                                                 value: 'Anon',
                                                 selectedValue: selectedOptionTeam,
                                                 onTap: () {
                                                   setState(() {
                                                     selectedOptionTeam = 'Anon';
                                                   });
                                                 },
                                               ),
                                               SizedBox(height: screenHeight * 0.02),
                                               CustomRadioOption(
                                                 label: 'Fully Public',
                                                 value: 'Fully Public',
                                                 selectedValue: selectedOptionTeam,
                                                 onTap: () {
                                                   setState(() {
                                                     selectedOptionTeam = 'Fully Public';
                                                   });
                                                 },
                                               ),
                                               SizedBox(height: screenHeight * 0.02),
                                               CustomRadioOption(
                                                 label: 'Mixed',
                                                 value: 'Mixed',
                                                 selectedValue: selectedOptionTeam,
                                                 onTap: () {
                                                   setState(() {
                                                     selectedOptionTeam = 'Mixed';
                                                   });
                                                 },
                                               ),
                                               SizedBox(height: screenHeight * 0.05),

                                               Text(
                                                 'Additional Project Details:',
                                                 textAlign: TextAlign.start,
                                                 style: TextStyle(
                                                   fontFamily: 'Poppins',
                                                   fontWeight: FontWeight.w500,
                                                   fontSize: baseSize * 0.045,
                                                   height: 1.2,
                                                   color: Colors.white,
                                                 ),
                                               ),
                                               SizedBox(height: screenHeight * 0.02),


                                               ListingField(
                                                 controller: backersAndAdvisorsController ,
                                                 labelText: 'Backers/Investors/Advisors Provide a list',
                                                 height: screenHeight * 0.05,
                                                 expandable: false,
                                                 keyboard: TextInputType.name,
                                               ),

                                               SizedBox(height: screenHeight * 0.02),

                                               ListingField(
                                                 controller: smartContractAuditController ,
                                                 labelText: 'Smart Contract Audit (with link if any)',
                                                 height: screenHeight * 0.05,
                                                 expandable: false,
                                                 keyboard: TextInputType.name,
                                               ),

                                               SizedBox(height: screenHeight * 0.02),

                                               ListingField(
                                                 controller: litepaperLinkController ,
                                                 labelText: 'Litepaper/Whitepaper Link',
                                                 height: screenHeight * 0.05,
                                                 expandable: false,
                                                 keyboard: TextInputType.url,
                                               ),
                                               SizedBox(height: screenHeight * 0.02),

                                               ListingField(
                                                 controller: websiteLinkController,
                                                 labelText: 'Website Link (if any)',
                                                 height: screenHeight * 0.05,
                                                 expandable: false,
                                                 keyboard: TextInputType.url,
                                               ),

                                               SizedBox(height: screenHeight * 0.05),

                                               ///Social Links:
                                               Text(
                                                 'Social Links:',
                                                 textAlign: TextAlign.start,
                                                 style: TextStyle(
                                                   fontFamily: 'Poppins',
                                                   fontWeight: FontWeight.w500,
                                                   fontSize: baseSize * 0.045,
                                                   height: 1.2,
                                                   color: Colors.white,
                                                 ),
                                               ),

                                               SizedBox(height: screenHeight * 0.02),

                                               ListingField(
                                                 controller: mediumLinkController ,
                                                 labelText: 'Medium Link',
                                                 height: screenHeight * 0.05,
                                                 expandable: false,
                                                 keyboard: TextInputType.url,
                                               ),
                                               SizedBox(height: screenHeight * 0.02),
                                               ListingField(
                                                 controller: githubLinkController ,
                                                 labelText: 'Github Link',
                                                 height: screenHeight * 0.05,
                                                 expandable: false,
                                                 keyboard: TextInputType.url,
                                               ),
                                               SizedBox(height: screenHeight * 0.02),
                                               ListingField(
                                                 controller: twitterLinkController ,
                                                 labelText: 'Twitter Link',
                                                 height: screenHeight * 0.05,
                                                 expandable: false,
                                                 keyboard: TextInputType.url,
                                               ),
                                               SizedBox(height: screenHeight * 0.02),
                                               ListingField(
                                                 controller: telegramLinkController ,
                                                 labelText: 'Telegram Link:',
                                                 height: screenHeight * 0.05,
                                                 expandable: false,
                                                 keyboard: TextInputType.url,
                                               ),
                                               SizedBox(height: screenHeight * 0.05),

                                               ///Additional Comments:
                                               Text(
                                                 'Additional Comments:',
                                                 textAlign: TextAlign.start,
                                                 style: TextStyle(
                                                   fontFamily: 'Poppins',
                                                   fontWeight: FontWeight.w500,
                                                   fontSize: baseSize * 0.045,
                                                   height: 1.2,
                                                   color: Colors.white,
                                                 ),
                                               ),
                                               SizedBox(height: screenHeight * 0.02),
                                               ListingField(
                                                 controller: additionalDetailsController,
                                                 labelText: 'Write in details',
                                                 height: screenHeight * 0.05,

                                                 expandable: false,
                                                 keyboard: TextInputType.name,
                                               ),


                                             ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.02),


                                      /// Submit & Clear Button Section
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          TextButton(

                                            onPressed: _isLoading ? null : _clearFormFields,

                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            child:  Text(
                                              'Clear form',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600, // SemiBold
                                                fontSize: MediaQuery.of(context).size.height * 0.015,
                                                height: 0.6,
                                                decoration: TextDecoration.underline,
                                                color: const Color(0XFF1CD494),
                                                decorationColor: const Color(0XFF1CD494),
                                                decorationThickness: 1.5,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.03,),

                                          BlockButton(
                                            height: screenHeight * 0.046,
                                            width: screenWidth * 0.38,
                                            label: 'Submit For Apply',
                                            textStyle: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth * 0.028,
                                              height: 0.8,
                                              color: Colors.white,
                                            ),
                                            gradientColors: const [
                                              Color(0xFF2680EF),
                                              Color(0xFF1CD494),
                                            ],
                                            onTap: _isLoading ? null : _submitApplication,
                                          ),

                                        ],
                                      ),

                                      SizedBox(height: screenHeight * 0.04),


                                    ],

                                  ),
                                ),
                              ),


                            ],
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

  Widget _headerSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bgContainerImg.png'),
          fit: BoxFit.fill,
          filterQuality: FilterQuality.medium,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.035,
          vertical: 18,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'MyCoinPoll IDO Launch Application',
                        style: TextStyle(
                          color: const Color(0xFFFFF5ED),
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Apply to launch your project—our team ensures thorough review and investor protection',
                        style: TextStyle(
                          color: const Color(0xFFFFF5ED),
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(width: 12),
                Flexible(
                  flex: 2,
                  child: Image.asset(
                    'assets/images/applyForLisitngImg1.png',
                    height: screenWidth * 0.22,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }


}



