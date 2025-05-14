import 'package:flutter/material.dart';


class SwitcherComponent extends StatefulWidget {
  final String title;
  final bool initialSwitchValue;
  final ValueChanged<bool>? onToggle;

  const SwitcherComponent({
    super.key,
    required this.initialSwitchValue,
    this.onToggle, required this.title,
  });

  @override
  State<SwitcherComponent> createState() => _SwitcherComponentState();
}

class _SwitcherComponentState extends State<SwitcherComponent> {
  late bool isSwitchOn;

  @override
  void initState() {
    super.initState();
    isSwitchOn = widget.initialSwitchValue;
  }

  void _handleToggle(bool value) {
    setState(() {
      isSwitchOn = value;
    });

    if (widget.onToggle != null) {
      widget.onToggle!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final containerWidth = screenWidth * 0.9;
    final labelWidth = screenWidth * 0.7;

    return Container(
      width: containerWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              widget.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Color(0xFFFEFEFE),
                  fontSize: screenWidth * 0.040,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.25,
                  height: 1.6,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          Spacer(),
          Switch(
            value: isSwitchOn,
            activeColor: Colors.blueAccent,
            onChanged: _handleToggle,
          ),
        ],
      ),
    );
  }
}

