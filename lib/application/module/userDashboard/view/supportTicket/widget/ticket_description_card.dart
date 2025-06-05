import 'package:flutter/material.dart';

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
