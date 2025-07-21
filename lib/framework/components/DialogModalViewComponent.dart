import 'package:flutter/material.dart';

import '../utils/dynamicFontSize.dart';
import 'BlockButton.dart';
import 'buy_Ecm.dart';


class DialogModalView extends StatelessWidget {
  final VoidCallback onYes;
   final String title;
  final String message;
  final String yesLabel;

  const DialogModalView({
    super.key,
    required this.onYes,
      required this.title, required this.message, required this.yesLabel,
  });

  @override
  Widget build(BuildContext context) {


    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: const Color(0XFF040C16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white24, width: 1),
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
                  style: const TextStyle(
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
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            // Buttons
            Row(
              children: [
                Expanded(

                  child: BlockButtonV2(
                    text: 'No',
                    onPressed: () => Navigator.of(context).pop(),
                    height: screenHeight * 0.045,
                    width: screenWidth * 0.7,
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
