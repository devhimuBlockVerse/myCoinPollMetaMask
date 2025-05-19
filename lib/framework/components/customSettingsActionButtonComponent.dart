import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSettingsActionButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String text;
  final String icon;
  final Color foregroundColor;
  final double borderRadius;

  const CustomSettingsActionButton({
    Key? key,
    required this.onPressed,
    required this.text ,
    required this.icon , // Default icon
    this.foregroundColor = Colors.white, // White text and icon
    this.borderRadius = 10.0, // Default border radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        image: DecorationImage(

          image: AssetImage('assets/icons/settingActionBg.png'),
          fit: BoxFit.fill,
          alignment: Alignment.topRight,
        ),

      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                icon,
                color: foregroundColor,
                height: 24,
                width: 24,
              ),
              SizedBox(width: 12,),
              Text(
                text,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 18, // Adjust font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
