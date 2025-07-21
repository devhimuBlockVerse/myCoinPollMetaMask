import 'package:flutter/material.dart';

import '../utils/dynamicFontSize.dart';

class PercentageSelectorComponent extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String> onSelected;
  final String initialSelection;

  const PercentageSelectorComponent({
    super.key,
    required this.options,
    required this.onSelected,
    required this.initialSelection,
  });

  @override
  State<PercentageSelectorComponent> createState() => _PercentageSelectorComponentState();
}

class _PercentageSelectorComponentState extends State<PercentageSelectorComponent> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final orientation = mediaQuery.orientation;

    double baseFontSize = (orientation == Orientation.portrait)
        ? screenWidth * 0.045
        : screenHeight * 0.045;

    double baseIconSize = (orientation == Orientation.portrait)
        ? screenWidth * 0.01
        : screenHeight * 0.01;

    double horizontalPadding = screenWidth * 0.02;
    double spacing = screenWidth * 0.006;

    baseFontSize = baseFontSize.clamp(14.0, 24.0);
    baseIconSize = baseIconSize.clamp(20.0, 35.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.options.length, (index) {
          final option = widget.options[index];
          final isSelected = (_selectedOption == option);

          final gestureWidget = GestureDetector(
            onTap: () {
              setState(() {
                _selectedOption = option;
              });
              widget.onSelected(option);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [Color(0xFF2AFFED), Color(0xFF3893FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Container(
                    width: baseIconSize,
                    height: baseIconSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0 * (baseIconSize / 20),
                      ),
                    ),
                    child: Center(
                      child: isSelected
                          ? Container(
                        width: baseIconSize * 0.5,
                        height: baseIconSize * 0.5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF2AFFED), Color(0xFF3893FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      )
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                    fontSize: getResponsiveFontSize(context, 12),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              gestureWidget,
              if (index < widget.options.length - 1) SizedBox(width: screenWidth * 0.015), // spacing between GestureDetectors
            ],
          );
        }),
      ),
    );
  }

}
