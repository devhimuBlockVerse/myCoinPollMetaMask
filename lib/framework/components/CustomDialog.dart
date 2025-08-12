import 'package:flutter/material.dart';

import 'dart:ui';


import '../../application/domain/model/DialogModel.dart';
import '../utils/dynamicFontSize.dart';

class CustomDialog extends StatelessWidget {
  final List<DialogItem> items;
  final String title;
  final String subtitle;
  final String? image;
  const CustomDialog({
    super.key,
    required this.items,
    required this.title,
    required this.subtitle,  this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              // Background blur
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(color: Colors.transparent),
              ),

              // Center Dialog
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                         image: AssetImage(image ?? 'assets/images/dialogBgv.png'),
                        fit: BoxFit.fill,
                        // fit: BoxFit.contain,
                      ),
                    ),

                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                              Flexible(
                                flex: 2,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: const Color(0xFFFFF5ED),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: getResponsiveFontSize(context, 18),
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Flexible(
                                child: Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: const Color(0xFFFFF5ED),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: getResponsiveFontSize(context, 18),
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Dynamic Items
                          ...items.map((item) => _buildItem(context, item.icon, item.text)),
                        ],
                      ),
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

  Widget _buildItem(BuildContext context, Widget  icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: getResponsiveFontSize(context, 18),
            child: icon,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xFFFFF5ED),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: getResponsiveFontSize(context, 16),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
