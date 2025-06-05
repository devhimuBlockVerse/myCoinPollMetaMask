import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../framework/utils/dynamicFontSize.dart';

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

  Future<void> _pickAttachment() async {
    final List<XTypeGroup> allowedTypes = [
      const XTypeGroup(
        label: 'Media & Documents',
        extensions: [
          'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp',
          'pdf', 'doc', 'docx', 'ppt', 'pptx',
          'xls', 'xlsx', 'txt', 'zip', 'rar'
        ],
        mimeTypes: [
          'image/*',
          'application/*',
          'text/plain',
        ],
      ),
    ];

    final List<XFile> file = await openFiles(acceptedTypeGroups: allowedTypes);

    if (file.isNotEmpty) {
      setState(() {
        attachments.addAll(file.map((file) => file.path));
      });
    }
  }

  void _send() {
    final String message = _controller.text.trim();

    if (message.isEmpty || attachments.isEmpty) return;

    widget.onSend(message, List<String>.from(attachments));

    setState(() {
      _controller.clear();
      attachments.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.01),
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.01, vertical: screenHeight * 0.01),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
                border: Border.all(
                  color: const Color(0xFF1CD691).withOpacity(0.80),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/icons/attatchment.svg',fit: BoxFit.contain,),
                    onPressed: _pickAttachment,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Write here...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: getResponsiveFontSize(context, 12),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.01),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF1CD691),
                width: 0.8,
              ),
              borderRadius: BorderRadius.circular(screenWidth * 0.02),
              color: const Color(0xFF101A29),
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white, size: screenWidth * 0.07),
              onPressed: _send,
            ),
          ),
        ],
      ),
    );
  }
}
