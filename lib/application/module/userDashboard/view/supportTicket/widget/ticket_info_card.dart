import 'package:flutter/material.dart';

import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../../framework/utils/status_styling_utils.dart';
import '../../../../../domain/model/TicketListModel.dart';

class TicketInfoCard extends StatelessWidget {
  final TicketListModel ticket;
  final double width;
  final double height;
  final VoidCallback onStatusButton;

  const TicketInfoCard({
    super.key,
    required this.width,
    required this.height,
    required this.onStatusButton, required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final statusStyle = getTicketListStatusStyle(ticket.status);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.15,
      decoration:const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/infoCardBg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Priority: High",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: getResponsiveFontSize(context, 14),
                      height: 1.6
                  ),
                ),

                Row(
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          fontSize: getResponsiveFontSize(context, 14),
                          height: 1.6
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: getResponsiveFontSize(context, 8),
                        vertical: getResponsiveFontSize(context, 4),
                      ),
                      decoration: BoxDecoration(
                        color: statusStyle.backgroundColor,
                        border: Border.all(color: statusStyle.borderColor, width: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        ticket.status,
                        style: TextStyle(
                            color: statusStyle.textColor,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            fontSize: getResponsiveFontSize(context, 12),
                            letterSpacing: -.5,
                            height: 1.1
                        ),
                      ),
                    ),

                  ],
                )
              ],
            ),


            SizedBox(height: screenHeight * 0.018),
            Text(
              "Ticket Created: 12/01/2025",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: getResponsiveFontSize(context, 14),
                  height: 1.6
              ),
            ),
            SizedBox(height: screenHeight * 0.008),

            Text(
              "Last Updated: 14/02/2025",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: getResponsiveFontSize(context, 14),
                  height: 1.6
              ),


            ),
          ],
        ),
      ),
    );
  }
}
