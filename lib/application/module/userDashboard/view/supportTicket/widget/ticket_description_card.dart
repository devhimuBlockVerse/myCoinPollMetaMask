import 'package:flutter/material.dart';

import '../../../../../../framework/components/BlockButton.dart';
import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../../framework/utils/status_styling_utils.dart';
class TicketDescriptionCard extends StatelessWidget {
  final bool isOpen;
  final double width;
  final double height;
  final VoidCallback onActionButton;

  const TicketDescriptionCard({
    super.key,
    required this.isOpen,
    required this.width,
    required this.height,
    required this.onActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final String actionLabel = isOpen ? "Close Ticket" : "Reopen Ticket";
    final StatusStyling statusStyle = getTicketStatusStyle(actionLabel);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/infoCardBg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting.",
            style: TextStyle(
              color: Colors.white,
              fontSize: getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              height: 1.6,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.4,
              child: TextButton.icon(
                onPressed: onActionButton,
                style: TextButton.styleFrom(
                  backgroundColor: statusStyle.backgroundColor,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.008,
                    horizontal: screenWidth * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    side: BorderSide(
                      color: statusStyle.borderColor,
                    ),
                  ),

                ),
                icon: Icon(
                  isOpen ? Icons.cancel_outlined : Icons.check_circle_outline_sharp,
                  color: statusStyle.textColor,
                  size: screenWidth * 0.05,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    actionLabel,
                    style: TextStyle(
                        color: statusStyle.textColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: getResponsiveFontSize(context, 12),
                        height: 1.3
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class CloseTicketDialog extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;
  final String title;
  final String message;
  final String yesLabel;

  const CloseTicketDialog({
    super.key,
    required this.onYes,
    required this.onNo, required this.title, required this.message, required this.yesLabel,
  });

  @override
  Widget build(BuildContext context) {


    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: const Color(0XFF040C16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white24, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title and Close Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Message
             Text(
              message,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF3EDBF0)),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: onNo,
                    child: const Text('No', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child:BlockButton(
                    height: screenHeight * 0.045,
                    width: screenWidth * 0.7,
                    label: yesLabel,
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
                    onTap: onYes
                  ),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



