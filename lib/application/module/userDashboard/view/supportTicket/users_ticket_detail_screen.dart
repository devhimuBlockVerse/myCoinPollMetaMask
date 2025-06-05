import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:provider/provider.dart';
 import '../../../../domain/model/ChatMessage.dart';
import '../../../../domain/model/TicketListModel.dart';
import '../../../../domain/model/ticket_list_dummy_data.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';
import 'suppor_ticket_screen.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'widget/chat_bubble.dart';
import 'widget/chat_input_fiel.dart';
import 'widget/ticket_description_card.dart';
import 'widget/ticket_info_card.dart';

// --- Models ---



class UsersTicketDetailScreen extends StatefulWidget {
  final TicketListModel ticketData;
   const UsersTicketDetailScreen({super.key, required this.ticketData});

  @override
  State<UsersTicketDetailScreen> createState() => _UsersTicketDetailScreenState();
}

class _UsersTicketDetailScreenState extends State<UsersTicketDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<TicketListModel> ticketListModel = ticketListData;

  bool isTicketOpen = true;

  // Example chat data
  final List<ChatMessage> messages = [
    ChatMessage(
      date: "07-06-2025",
      sender: "user",
      avatarUrl: "https://randomuser.me/api/portraits/men/1.jpg",
      message:
      "Hi Team,\nWe're currently facing significant network connectivity issues affecting multiple users. Users are reporting intermittent access to network resources, including servAers and shared files. This is impacting productivity across the organization. We need to investigate and resolve .\n\nThank you for your attention to this matter.",
      time: "03:40pm",
      attachments: ["SS1256934.png", "SS1256934.png"],
    ),
    ChatMessage(
      date: "08-06-2025",
      sender: "support",
      avatarUrl: "https://randomuser.me/api/portraits/men/2.jpg",
      message:
      "Hi Abdus Salam,\nWe're currently facing significant network connectivity issues affecting multiple users. Users are reporting intermittent access to network resources, including servAers and shared files. This is impacting productivity across the organization. We need to investigate and resolve .",
      time: "05:40pm",
      attachments: [],
    ),
  ];

  void _handleSend(String text, List<String> attachments) {
    setState(() {
      messages.add(ChatMessage(
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        sender: "user",
        avatarUrl: "https://randomuser.me/api/portraits/men/1.jpg", // user's avatar
        message: text,
        time: DateFormat('hh:mma').format(DateTime.now()),
        attachments: attachments,
      ));
    });
  }


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
                         "Ticket ${widget.ticketData.ticketID}",
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                    
                        // Ticket Info Card
                        TicketInfoCard(
                          ticket: widget.ticketData,
                          width: screenWidth,
                          height: screenHeight,
                          onStatusButton: () {
                            setState(() {
                              isTicketOpen = !isTicketOpen;
                            });
                          },
                        ),
                    
                        SizedBox(height: screenHeight * 0.02),
                    
                        // Ticket Description Card
                        TicketDescriptionCard(
                          isOpen: isTicketOpen,
                          width: screenWidth,
                          height: screenHeight,
                          onActionButton: () {
                            // setState(() {
                            //   isTicketOpen = !isTicketOpen;
                            // });
                            final isClosing = isTicketOpen;

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => CloseTicketDialog(
                                title: isClosing ? 'Close Ticket' : 'Reopen Ticket',
                                message: isClosing
                                    ? 'Are you sure you want to Close this ticket?'
                                    : 'Are you sure you want to Reopen this ticket?',
                                yesLabel: isClosing ? 'Yes' : 'Yes',
                                onYes: () {
                                  setState(() {
                                    isTicketOpen = !isTicketOpen;
                                  });
                                  Navigator.of(context).pop();
                                },
                                onNo: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        ),
                    
                        SizedBox(height: screenHeight * 0.01),
                        // Chat Section
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.7,
                          decoration:BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/chatContainerBg.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          // padding: EdgeInsets.symmetric(
                          //   horizontal: screenWidth * 0.02,
                          //  ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: messages.length,
                                  itemBuilder: (context, idx) {
                                    final msg = messages[idx];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                                            child: Text(
                                              msg.date,
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                 fontSize: getResponsiveFontSize(context, 10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ChatBubble(
                                          message: msg,
                                          width: screenWidth,
                                          height: screenHeight,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              isTicketOpen
                                  ? ChatInputField(width: screenWidth, height: screenHeight, onSend: _handleSend ,)
                                  : _closedTicketBar(context)
                                  // : _closedTicketBar(width: screenWidth, height: screenHeight),

                            ],
                          ),
                        ),
                    
                    
                        // Input Section
                        // isTicketOpen
                        //     ? ChatInputField(width: screenWidth, height: screenHeight, onSend: _handleSend ,)
                        //     : ClosedTicketBar(width: screenWidth, height: screenHeight),
                    
                      ],
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


  Widget _closedTicketBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(top: height * 0.01),
      width: width,
      padding: EdgeInsets.symmetric(vertical: height * 0.018),
      decoration: BoxDecoration(
        color: Color(0XFFE04043).withOpacity(0.20),
        borderRadius: BorderRadius.circular(width * 0.03),
        border: Border.all(color: Color(0XFFE04043)),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "The ticket is closed",
            style: TextStyle(
              color: Color(0XFFE04043),
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: getResponsiveFontSize(context, 12),
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }


}







