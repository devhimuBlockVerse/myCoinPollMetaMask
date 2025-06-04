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
import 'widget/upload_file.dart';

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

                              SizedBox(height: screenHeight * 0.03),

                              PrioritySelector(
                                initialPriority: "Medium",
                                onChanged: (priority) {
                                  print("Selected priority: $priority");
                                  // Save it to your model or state as needed
                                },
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


class PrioritySelector extends StatefulWidget {
  final Function(String priority) onChanged;
  final String? initialPriority;

  const PrioritySelector({
    Key? key,
    required this.onChanged,
    this.initialPriority,
  }) : super(key: key);

  @override
  State<PrioritySelector> createState() => _PrioritySelectorState();
}

class _PrioritySelectorState extends State<PrioritySelector> {
  String? selectedPriority;

  final List<String> priorities = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    selectedPriority = widget.initialPriority;
  }

  void _onSelect(String priority) {
    setState(() {
      selectedPriority = priority;
    });
    widget.onChanged(priority);
  }

  Widget buildItem(String label) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    bool isSelected = selectedPriority == label;

    return GestureDetector(
      onTap: () => _onSelect(label),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF277BF5), Color(0xFF1CD691)],
              )
                  : null,
              color: isSelected ? null : Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isSelected
                    ? Colors.white.withOpacity(0.02)
                    : const Color(0x4C277BF5),
                width: 1,
              ),
            ),
            child: isSelected
                ? const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: priorities.map((p) => buildItem(p)).toList(),
    );
  }
}


//
// class PrioritySelector extends StatefulWidget {
//   final Function(String priority) onChanged;
//   final String? initialPriority;
//
//   const PrioritySelector({
//     Key? key,
//     required this.onChanged,
//     this.initialPriority,
//   }) : super(key: key);
//
//   @override
//   State<PrioritySelector> createState() => _PrioritySelectorState();
// }
//
// class _PrioritySelectorState extends State<PrioritySelector> {
//   String? selectedPriority;
//
//   final List<String> priorities = ['High', 'Medium', 'Low'];
//
//   @override
//   void initState() {
//     super.initState();
//     selectedPriority = widget.initialPriority;
//   }
//
//   void _onSelect(String priority) {
//     setState(() {
//       selectedPriority = priority;
//     });
//     widget.onChanged(priority);
//   }
//
//   Widget buildItem(String label) {
//     bool isSelected = selectedPriority == label;
//     return GestureDetector(
//       onTap: () => _onSelect(label),
//       child: Row(
//         children: [
//           Container(
//             width: 24,
//             height: 24,
//             decoration: BoxDecoration(
//               gradient: isSelected
//                   ? const LinearGradient(
//                 begin: Alignment.centerRight,
//                 end: Alignment.centerLeft,
//                 colors: [Color(0xFF277BF5), Color(0xFF1CD691)],
//               )
//                   : null,
//               // color: Colors.transparent,
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(
//                 color: isSelected
//                     ? Colors.white.withOpacity(0.02)
//                     : const Color(0x4C277BF5),
//                 width: 1,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 12,
//               fontFamily: 'Poppins',
//               height: 1.4,
//             ),
//           ),
//           const SizedBox(width: 12),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: priorities.map((p) => buildItem(p)).toList(),
//     );
//   }
// }
//




