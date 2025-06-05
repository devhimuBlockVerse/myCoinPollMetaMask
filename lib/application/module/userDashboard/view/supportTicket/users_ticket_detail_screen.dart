import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';
import 'package:provider/provider.dart';
import '../../../../../framework/utils/status_styling_utils.dart';
import '../../../../domain/model/TicketListModel.dart';
import '../../../../domain/model/ticket_list_dummy_data.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';
import 'suppor_ticket_screen.dart';
import 'package:intl/intl.dart';

import 'widget/ticket_description_card.dart';
import 'widget/ticket_info_card.dart';

// --- Models ---

class ChatMessage {
  final String date;
  final String sender;
  final String avatarUrl;
  final String message;
  final String time;
  final List<String> attachments;

  ChatMessage({
    required this.date,
    required this.sender,
    required this.avatarUrl,
    required this.message,
    required this.time,
    required this.attachments,
  });
}


class UsersTicketDetailScreen extends StatefulWidget {
  final TicketListModel ticketData;
   const UsersTicketDetailScreen({super.key, required this.ticketData});

  @override
  State<UsersTicketDetailScreen> createState() => _UsersTicketDetailScreenState();
}

class _UsersTicketDetailScreenState extends State<UsersTicketDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // final ticketListModel = (ticketListData as List)
  //     .map((json) => TicketListModel.fromJson(json))
  //     .toList();

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
                          setState(() {
                            isTicketOpen = !isTicketOpen;
                          });
                        },
                      ),

                      SizedBox(height: screenHeight * 0.02),
                      // Chat Section
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
                                        fontSize: screenWidth * 0.035,
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


                      // Input Section
                      isTicketOpen
                          ? ChatInputField(width: screenWidth, height: screenHeight, onSend: _handleSend ,)
                          : ClosedTicketBar(width: screenWidth, height: screenHeight),

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

// --- Widgets ---


///
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final double width;
  final double height;

  const ChatBubble({
    super.key,
    required this.message,
    required this.width,
    required this.height,
  });

  bool get isUser => message.sender == "user";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser)
          Padding(
            padding: EdgeInsets.only(right: width * 0.025, top: height * 0.01),
            child: CircleAvatar(
              backgroundImage: NetworkImage(message.avatarUrl),
              radius: width * 0.06,
            ),
          ),
        Flexible(
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: isUser ? width * 0.15 : 0,
                  right: isUser ? 0 : width * 0.15,
                  bottom: height * 0.005,
                ),
                padding: EdgeInsets.all(width * 0.035),
                decoration: BoxDecoration(
                  color: isUser ? Color(0xFF1A2B4A) : Color(0xFF22304A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(width * 0.03),
                    topRight: Radius.circular(width * 0.03),
                    bottomLeft: Radius.circular(isUser ? width * 0.03 : 0),
                    bottomRight: Radius.circular(isUser ? 0 : width * 0.03),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.038,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      message.time,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: width * 0.032,
                      ),
                    ),
                  ],
                ),
              ),
              // Attachments
              ...message.attachments.map((file) => Padding(
                padding: EdgeInsets.only(top: height * 0.008),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.008),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22304A),
                    borderRadius: BorderRadius.circular(width * 0.02),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.insert_drive_file,
                          color: Colors.white70, size: width * 0.045),
                      SizedBox(width: width * 0.02),
                      Text(
                        file,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: width * 0.035,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        "105.01 KB",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: width * 0.032,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
        if (isUser)
          Padding(
            padding: EdgeInsets.only(left: width * 0.025, top: height * 0.01),
            child: CircleAvatar(
              backgroundImage: NetworkImage(message.avatarUrl),
              radius: width * 0.06,
            ),
          ),
      ],
    );
  }
}

class ChatInputField extends StatefulWidget {
  final double width;
  final double height;
  final Function(String, List<String>) onSend;

  const ChatInputField({
    super.key,
    required this.width,
    required this.height,
    required this.onSend,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  List<String> attachments = [];

  void _pickAttachment() async {

    setState(() {
      attachments.add("DemoFile.png");
    });
  }

  void _send() {
    if (_controller.text.trim().isNotEmpty || attachments.isNotEmpty) {
      widget.onSend(_controller.text.trim(), attachments);
      _controller.clear();
      setState(() {
        attachments = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.height * 0.01),
      padding: EdgeInsets.symmetric(
          horizontal: widget.width * 0.01, vertical: widget.height * 0.01),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF17223B),
                borderRadius: BorderRadius.circular(widget.width * 0.02),
                border: Border.all(
                  color: const Color(0xFF00FFC2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.white54),
                    onPressed: _pickAttachment,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Write here...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: widget.width * 0.01),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF00FFC2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(widget.width * 0.02),
              color: const Color(0xFF17223B),
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white, size: widget.width * 0.07),
              onPressed: _send,
            ),
          ),
        ],
      ),
    );
  }
}

class ClosedTicketBar extends StatelessWidget {
  final double width;
  final double height;

  const ClosedTicketBar({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.01),
      width: width,
      padding: EdgeInsets.symmetric(vertical: height * 0.018),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(width * 0.03),
        border: Border.all(color: Colors.red),
      ),
      child: Center(
        child: Text(
          "The ticket is closed",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: width * 0.04,
          ),
        ),
      ),
    );
  }
}