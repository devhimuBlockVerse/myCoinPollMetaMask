import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSettingsActionButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String text;
  final String icon;
  final Color foregroundColor;
  final double borderRadius;

  const CustomSettingsActionButton({
    super.key,
    required this.onPressed,
    required this.text ,
    required this.icon ,
    this.foregroundColor = Colors.white,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/settingActionBg.png'),
          fit: BoxFit.fill,
          alignment: Alignment.topRight,
          filterQuality: FilterQuality.low
        ),

      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              const SizedBox(width: 12,),
              Text(
                text,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
