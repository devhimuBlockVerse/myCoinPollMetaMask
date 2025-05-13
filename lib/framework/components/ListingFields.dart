import 'package:flutter/material.dart';
class ListingField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final double? height;
  final double? width;
  final bool expandable;
  final TextInputType? keyboard;

  const ListingField({
    Key? key,
    this.controller,
    this.labelText,
    this.height,
    this.width,
    this.expandable = false, this.keyboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: width ?? screenWidth * 0.85,
      height: expandable ? null : height ?? screenHeight * 0.06,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.045,
        vertical: screenHeight * 0.012,
      ),
      decoration: ShapeDecoration(
        // color: const Color(0xFF12161D),
        color: const Color(0XFF101A29),
         shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF141317)),
           borderRadius: BorderRadius.circular(3),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xFFC7E0FF),
            blurRadius: 0,
            offset: Offset(0.10, 0.50),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        keyboardType:keyboard,
        controller: controller,
        maxLines: expandable ? null : 1,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: screenHeight * 0.015,
          // height: 0.8,
          height: 1.6,
          color: Colors.white.withOpacity(0.4),
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: labelText,
          hintStyle: TextStyle(
            color: Color(0XFF7D8FA9),
            fontSize: screenHeight * 0.015,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1.6,


          ),
        ),
      ),
    );
  }
}
