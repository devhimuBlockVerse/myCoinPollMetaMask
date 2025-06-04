import 'dart:io';
 import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/components/BlockButton.dart';
import '../../../../../framework/components/ListingFields.dart';
import '../../../../../framework/components/customDropDownComponent.dart';
import '../../../../../framework/utils/dynamicFontSize.dart';
 import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';
import 'suppor_ticket_screen.dart';

class CreateNewTicketScreen extends StatefulWidget {
  const CreateNewTicketScreen({super.key});

  @override
  State<CreateNewTicketScreen> createState() => _CreateNewTicketScreenState();
}

class _CreateNewTicketScreenState extends State<CreateNewTicketScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  TextEditingController subjectController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();



  String? _selectedDepartment;



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final itemSpacing = screenWidth * 0.02;


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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// App bar row
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
                      onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context) =>  SupportTicketScreen()))
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Create New Ticket",
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

              /// Main content area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  child: ListView(
                    children: [

                      /// Create New Ticket Fields

                      Container(
                        width: double.infinity,
                        height: screenHeight ,

                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/icons/createTicketBg.png'),
                            fit: BoxFit.fill,
                          ),

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

                              /// Select Department
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Department",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: getResponsiveFontSize(context, 14),
                                      height: 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  CustomDropdown(
                                    height: screenHeight * 0.05,
                                    width: screenWidth,
                                    label: 'Select Department',
                                    items: const [

                                      "Billing & Payments",
                                      "Technical Support",
                                      "Account & Login Issues",
                                      "General Inquiries",
                                      "Security & Fraud",
                                      "Subscription & Plans",
                                    ],
                                    selectedValue: _selectedDepartment,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDepartment = value;
                                      });
                                    },
                                  ),
                                ],
                              ),


                              SizedBox(height: screenHeight * 0.02),

                              ///Enter the news title / Subject
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Subject",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: getResponsiveFontSize(context, 14),
                                      height: 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  ListingField(
                                    controller: subjectController,
                                    labelText: 'Enter the news title',
                                    height: screenHeight * 0.05,
                                    // width: screenWidth* 0.88,
                                    expandable: false,
                                    keyboard: TextInputType.name,
                                  ),
                                ],
                              ),



                              SizedBox(height: screenHeight * 0.02),

                              /// Address
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: getResponsiveFontSize(context, 14),
                                      height: 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  ListingField(
                                    controller: descriptionController,
                                    labelText: 'Write here...',
                                    height:  screenHeight * 0.3,
                                    expandable: false,
                                    keyboard: TextInputType.multiline,
                                  ),
                                ],
                              ),



                              SizedBox(height: screenHeight * 0.03),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Upload an Image",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: getResponsiveFontSize(context, 14),
                                      height: 1.6,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),

                                  /// If False then User Can Upload Any File format :: true -> Only Image
                                  UploadFileWidget(
                                    title: "Choose a File",
                                    allowImageOnly: false,
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.05),







                              BlockButton(
                                height: screenHeight * 0.045,
                                width: screenWidth * 0.7,
                                label: 'Submit',
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
                                   // Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
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
            ],
          ),
        ),
      ),
    );
  }
}

class UploadFileWidget extends StatefulWidget {
  final String title;
  final bool allowImageOnly;

  const UploadFileWidget({
    Key? key,
    this.title = "Choose a File",
    this.allowImageOnly = false,
  }) : super(key: key);

  @override
  State<UploadFileWidget> createState() => _UploadFileWidgetState();
}

class _UploadFileWidgetState extends State<UploadFileWidget> {
  XFile? selectedFile;

  Future<void> pickFile() async {
    List<XTypeGroup> acceptedTypeGroups = [];

    if (widget.allowImageOnly) {
      acceptedTypeGroups.add(const XTypeGroup(
        label: 'Images',
        extensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
        mimeTypes: ['image/jpeg', 'image/png', 'image/gif', 'image/bmp', 'image/webp'],
      ));
    } else {
      acceptedTypeGroups.add(const XTypeGroup(
        label: 'All Files',
        extensions: ['*'],
      ));
    }

    final XFile? file = await openFile(acceptedTypeGroups: acceptedTypeGroups);
    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  void removeFile() {
    setState(() {
      selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isSmallScreen = constraints.maxWidth < 400;
      // final containerWidth = constraints.maxWidth * 0.95;
      final containerWidth = constraints.maxWidth;
      final screenHeight = MediaQuery.of(context).size.height;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: containerWidth,
            height: screenHeight * 0.05,

            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFF101A29),
              border: Border.all(color: const Color(0xFF141317)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFC7E0FF),
                  blurRadius: 0,
                  offset: Offset(0.1, 0.5),
                ),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: pickFile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white.withOpacity(0.04),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: getResponsiveFontSize(context, 10),
                          fontFamily: 'Poppins',
                          height: 1.3,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedFile != null
                        ? selectedFile!.path.split('/').last
                        : "No File Chosen",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0XFF7D8FA9),
                      fontSize: getResponsiveFontSize(context, 12),
                      fontFamily: 'Poppins',
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (selectedFile != null)
            GestureDetector(
              onTap: removeFile,
              child: Container(
                height: screenHeight * 0.035,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0XFFE04043).withOpacity(0.20)),
                  borderRadius: BorderRadius.circular(3),
                  color: const Color(0xFFE04043).withOpacity(0.04),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Remove",
                    style: TextStyle(
                      color: const Color(0XFFE04043),
                      fontSize: getResponsiveFontSize(context, 10),
                      height: 1.3,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}

// class UploadFileWidget extends StatefulWidget {
//   final String title;
//   final bool allowImageOnly;
//
//   const UploadFileWidget({
//     Key? key,
//     this.title = "Choose a File",
//     this.allowImageOnly = false,
//   }) : super(key: key);
//
//   @override
//   State<UploadFileWidget> createState() => _UploadFileWidgetState();
// }
//
// class _UploadFileWidgetState extends State<UploadFileWidget> {
//   XFile? selectedFile;
//
//   Future<void> pickFile() async {
//     List<XTypeGroup> acceptedTypeGroups = [];
//
//     if (widget.allowImageOnly) {
//       acceptedTypeGroups.add(const XTypeGroup(
//         label: 'Images',
//         extensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
//         mimeTypes: ['image/jpeg', 'image/png', 'image/gif', 'image/bmp', 'image/webp'],
//       ));
//     } else {
//        // This will allow the native dialog to determine accepted types, or allow all
//       acceptedTypeGroups.add(const XTypeGroup(
//         label: 'All Files',
//         extensions: ['*'], // This means all extensions
//       ));
//     }
//
//     final XFile? file = await openFile(acceptedTypeGroups: acceptedTypeGroups);
//
//     if (file != null) {
//       setState(() {
//         selectedFile = file;
//       });
//     }
//   }
//
//
//   void removeFile() {
//     setState(() {
//       selectedFile = null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Container(
//           width: screenWidth * 0.85,
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4),
//             color: const Color(0xFF101A29),
//             border: Border.all(color: const Color(0xFF141317)),
//             boxShadow: const [
//               BoxShadow(
//                 color: Color(0xFFC7E0FF),
//                 blurRadius: 0,
//                 offset: Offset(0.1, 0.5),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               InkWell(
//                 onTap: pickFile,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white.withOpacity(0.2)),
//                     borderRadius: BorderRadius.circular(3),
//                     color: Colors.white.withOpacity(0.04),
//                   ),
//                   child: Text(
//                     widget.title,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.8),
//                       fontSize:getResponsiveFontSize(context, 10),
//                       fontFamily: 'Poppins',
//                       height: 1.3,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   selectedFile != null
//                       ? selectedFile!.path.split('/').last
//                       : "No File Chosen",
//                   overflow: TextOverflow.ellipsis,
//                   style:  TextStyle(
//                     color: Color(0XFF7D8FA9),
//                     fontSize: getResponsiveFontSize(context, 12),
//                     fontFamily: 'Poppins',
//                     height: 1.6,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),
//         if (selectedFile != null)
//           GestureDetector(
//             onTap: removeFile,
//             child: Container(
//               height: screenHeight * 0.03,
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 border: Border.all(color: const Color(0XFFE04043).withOpacity(0.20)),
//                 borderRadius: BorderRadius.circular(3),
//                 color: const Color(0xFFE04043).withOpacity(0.04),
//               ),
//               child:  Text(
//                 "Remove",
//                 style: TextStyle(
//                   color: Color(0XFFE04043),
//                   fontSize: getResponsiveFontSize(context, 10),
//                   height: 1.3,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }