import 'package:flutter/material.dart';

import '../../../../../../framework/utils/dynamicFontSize.dart';
class PrioritySelector extends StatefulWidget {
  final Function(String priority) onChanged;
  final String? initialPriority;

  const PrioritySelector({
    Key? key,
    required this.onChanged,
    this.initialPriority,
  }) : super(key: key);

  @override
  State<PrioritySelector> createState() => _PrioritySelectorState();
}

class _PrioritySelectorState extends State<PrioritySelector> {
  String? selectedPriority;

  final List<String> priorities = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    selectedPriority = widget.initialPriority;
  }

  void _onSelect(String priority) {
    setState(() {
      selectedPriority = priority;
    });
    widget.onChanged(priority);
  }

  double getResponsiveSize(BuildContext context, double size) {
    double baseWidth = 375;
    return size * MediaQuery.of(context).size.width / baseWidth;
  }


  Widget buildItem(String label) {
    bool isSelected = selectedPriority == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onSelect(label),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: getResponsiveSize(context, 24),
              height: getResponsiveSize(context, 24),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Color(0xFF277BF5), Color(0xFF1CD691)],
                )
                    : null,
                color: isSelected ? null : Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isSelected
                      ? Colors.white.withOpacity(0.02)
                      : const Color(0x4C277BF5),
                  width: 1,
                ),
              ),
              child: isSelected
                  ? Icon(
                Icons.check,
                size: getResponsiveSize(context, 16),
                color: Colors.white,
              )
                  : null,
            ),
            SizedBox(width: getResponsiveSize(context, 8)),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(context, 12),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: priorities.map((p) => buildItem(p)).toList(),
    );
  }
}








