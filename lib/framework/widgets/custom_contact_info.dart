import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/dynamicFontSize.dart';
class CustomContactInfo extends StatefulWidget {
  final String? phoneNumber;
  final String emailAddress;

  const CustomContactInfo({
    super.key,
     this.phoneNumber,
    required this.emailAddress,
  });

  @override
  State<CustomContactInfo> createState() => _CustomContactInfoState();
}

class _CustomContactInfoState extends State<CustomContactInfo> {
  Future<void> _callPhone(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('Could not launch $launchUri');
    }
  }

  Future<void> _sendEmail(String emailAddress) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: emailAddress);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth / 375.0;
    bool  hasPhone = widget.phoneNumber != null && widget.phoneNumber!.trim().isNotEmpty;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white24.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0 * scaleFactor),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Phone Info
              if(hasPhone)
                Flexible(
                child: InkWell(
                  onTap: () => _callPhone(widget.phoneNumber!),
                  child: Row(
                    children: [
                       SvgPicture.asset(
                        'assets/icons/phone.svg',
                         height: 24 * scaleFactor,
                        width: 24 * scaleFactor,
                      ),
                      SizedBox(width: 8.0 * scaleFactor),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PHONE',
                              style: TextStyle(
                                color: const Color(0xffFFF5ED),
                                fontSize:getResponsiveFontSize(context, 12.3),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.02 * (12.0 * scaleFactor),
                                height: 1.6,
                              ),
                            ),
                            Text(
                              widget.phoneNumber!,
                              style: TextStyle(
                                color: const Color(0xffDBE2FB),
                                fontSize:getResponsiveFontSize(context, 12.3),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.02 * (12.0 * scaleFactor),
                                height: 1.6,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Email Info
              Flexible(
                child: InkWell(
                  onTap: () => _sendEmail(widget.emailAddress),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/email.svg',
                        height: 24 * scaleFactor,
                        width: 24 * scaleFactor,
                      ),
                      SizedBox(width: 8.0 * scaleFactor),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EMAIL',
                              style: TextStyle(
                                color: const Color(0xffFFF5ED),
                                fontSize:getResponsiveFontSize(context, 12.3),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.02 * (12.0 * scaleFactor),
                                height: 1.6,
                              ),
                            ),
                            Text(
                              widget.emailAddress,
                              style: TextStyle(
                                color: const Color(0xffDBE2FB),
                                fontSize:getResponsiveFontSize(context, 12.3),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.02 * (12.0 * scaleFactor),
                                height: 1.6,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}