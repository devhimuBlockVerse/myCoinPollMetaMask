import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../domain/model/ChatMessage.dart';
import '../users_ticket_detail_screen.dart';
import 'dart:math' as Math;

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
  String getFileSize(String filePath) {
    try {
      final file = File(filePath);
      final bytes = file.lengthSync(); ///  file size in bytes
      if (bytes <= 0) return "0 B";
      const suffixes = ["B", "KB", "MB", "GB", "TB"];
      int i = (bytes == 0) ? 0 : (Math.log(bytes) / Math.log(1024)).floor();
      final size = (bytes / Math.pow(1024, i));
      return "${size.toStringAsFixed(2)} ${suffixes[i]}";
    } catch (e) {
      return "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight  = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser)
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.025, left: screenHeight * 0.01),
            child: CircleAvatar(
              backgroundImage: NetworkImage(message.avatarUrl),
              radius: screenWidth * 0.05,

            ),
          ),
        Flexible(
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: isUser ? screenWidth * 0.01 : 0,
                  right: isUser ? 0 : screenWidth * 0.01,
                  bottom: screenHeight * 0.005,
                ),
                padding: EdgeInsets.all(screenWidth * 0.035),
                decoration: BoxDecoration(

                  gradient: LinearGradient(
                    colors: isUser
                        ? [Color(0xFF152743), Color(0xFF101A29)] // Gradient for user
                        : [Color(0xFF101A29), Color(0xFF101A29)], // Gradient for supporter
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Color(0xFF4E4D50),
                    width: 0.6,
                  ),

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.03),
                    topRight: Radius.circular(screenWidth * 0.03),
                    bottomLeft: Radius.circular(isUser ? screenWidth * 0.03 : 0),
                    bottomRight: Radius.circular(isUser ? 0 : screenWidth * 0.03),
                  ),


                ),
                child: Column(
                  crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        fontSize: getResponsiveFontSize(context, 12),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      message.time,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        fontSize: getResponsiveFontSize(context, 10),
                      ),
                    ),
                  ],
                ),
              ),


              /// Attachments
              ...message.attachments.map((file) => Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.008),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03, vertical: screenHeight * 0.008),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22304A),
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.insert_drive_file,
                          color: Colors.white70, size: screenWidth * 0.045),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        file.split('/').last, /// File Name
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        getFileSize(file), /// File size
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: screenWidth * 0.032,
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
            padding: EdgeInsets.only(left: screenWidth * 0.025, right: screenHeight * 0.01),
            child: CircleAvatar(
              backgroundImage: NetworkImage(message.avatarUrl),
              radius: screenWidth * 0.05,
            ),
          ),
      ],
    );
  }
}
