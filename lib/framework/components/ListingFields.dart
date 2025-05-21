import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


// Import the SVG package


// class ListingField extends StatefulWidget {
//   final TextEditingController? controller;
//   final String? labelText;
//   final double? height;
//   final double? width;
//   final bool expandable;
//   final TextInputType? keyboard;
//   final bool isPassword;
//   final IconData? prefixIcon;
//
//   const ListingField({
//     Key? key,
//     this.controller,
//     this.labelText,
//     this.height,
//     this.width,
//     this.expandable = false,
//     this.keyboard,
//     this.isPassword = false,
//     this.prefixIcon,
//   }) : super(key: key);
//
//   @override
//   State<ListingField> createState() => _ListingFieldState();
// }
//
// class _ListingFieldState extends State<ListingField> {
//   bool _obscureText = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _obscureText = widget.isPassword; // Set based on input type
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Container(
//       width: widget.width ?? screenWidth * 0.85,
//       height: widget.expandable ? null : widget.height ?? screenHeight * 0.06,
//       padding: EdgeInsets.symmetric(
//         horizontal: screenWidth * 0.045,
//         vertical: screenHeight * 0.012,
//       ),
//       decoration: ShapeDecoration(
//         color: const Color(0XFF101A29),
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(width: 1.2, color: Color(0xFF141317)),
//           borderRadius: BorderRadius.circular(3),
//         ),
//         shadows: const [
//           BoxShadow(
//             color: Color(0xFFC7E0FF),
//             blurRadius: 0,
//             offset: Offset(0.10, 0.50),
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           if (widget.prefixIcon != null)
//             Padding(
//               padding: const EdgeInsets.only(right: 10),
//               child: Icon(
//                 widget.prefixIcon,
//                 size: screenHeight * 0.022,
//                 color: Colors.white.withOpacity(0.5),
//               ),
//             ),
//           Expanded(
//             child: TextField(
//               keyboardType: widget.keyboard,
//               controller: widget.controller,
//               maxLines: widget.expandable ? null : 1,
//               obscureText: widget.isPassword ? _obscureText : false,
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w400,
//                 fontSize: screenHeight * 0.015,
//                 height: 1.6,
//                 color: Colors.white.withOpacity(0.9),
//               ),
//               decoration: InputDecoration(
//                 isCollapsed: true,
//                 border: InputBorder.none,
//                 hintText: widget.labelText,
//                 hintStyle: TextStyle(
//                   color: const Color(0XFF7D8FA9),
//                   fontSize: screenHeight * 0.015,
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w400,
//                   height: 1.6,
//                 ),
//               ),
//             ),
//           ),
//           if (widget.isPassword)
//             GestureDetector(
//               onTap: () => setState(() => _obscureText = !_obscureText),
//               child: Icon(
//                 _obscureText ? Icons.visibility_off : Icons.visibility,
//                 color: Colors.white.withOpacity(0.5),
//                 size: screenHeight * 0.022,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

/**
class ListingField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final double? height;
  final double? width;
  final bool expandable;
  final TextInputType? keyboard;
  final bool isPassword;
  final IconData? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const ListingField({
    Key? key,
    this.controller,
    this.labelText,
    this.height,
    this.width,
    this.expandable = false,
    this.keyboard,
    this.isPassword = false,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<ListingField> createState() => _ListingFieldState();
}

class _ListingFieldState extends State<ListingField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: widget.readOnly ? widget.onTap : null,
      child: Container(
        width: widget.width ?? screenWidth * 0.85,
        height: widget.expandable ? null : widget.height ?? screenHeight * 0.06,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.045,
          vertical: screenHeight * 0.012,
        ),
        decoration: ShapeDecoration(
          color: const Color(0XFF101A29),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.2, color: Color(0xFF141317)),
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
        child: Row(
          children: [
            if (widget.prefixIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  widget.prefixIcon,
                  size: screenHeight * 0.022,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            Expanded(
              child: TextField(
                keyboardType: widget.keyboard,
                controller: widget.controller,
                maxLines: widget.expandable ? null : 1,
                obscureText: widget.isPassword ? _obscureText : false,
                readOnly: widget.readOnly,
                // Show cursor only if not read-only
                showCursor: !widget.readOnly,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: screenHeight * 0.015,
                  height: 1.6,
                  color: Colors.white.withOpacity(0.9),
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: widget.labelText,
                  hintStyle: TextStyle(
                    color: const Color(0XFF7D8FA9),
                    fontSize: screenHeight * 0.015,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            if (widget.isPassword)
              GestureDetector(
                onTap: () => setState(() => _obscureText = !_obscureText),
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withOpacity(0.5),
                  size: screenHeight * 0.022,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

 **/



class ListingField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final double? height;
  final double? width;
  final bool expandable;
  final TextInputType? keyboard;
  final bool isPassword;
  final IconData? prefixIcon; // Keep this for convenience if desired
  final String? prefixSvgPath; // For SVG images
  final String? prefixPngPath; // For PNG/other raster images
  final Widget? customPrefixWidget; // New: for ultimate flexibility

  final bool readOnly;
  final VoidCallback? onTap;

  // Properties for dropdown functionality
  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? selectedDropdownItem;
  final ValueChanged<String?>? onDropdownChanged;

  const ListingField({
    Key? key,
    this.controller,
    this.labelText,
    this.height,
    this.width,
    this.expandable = false,
    this.keyboard,
    this.isPassword = false,
    this.prefixIcon,
    this.prefixSvgPath,
    this.prefixPngPath,
    this.customPrefixWidget, // Initialize the new property
    this.readOnly = false,
    this.onTap,
    this.isDropdown = false,
    this.dropdownItems,
    this.selectedDropdownItem,
    this.onDropdownChanged,
  }) : super(key: key);

  @override
  State<ListingField> createState() => _ListingFieldState();
}

class _ListingFieldState extends State<ListingField> {
  bool _obscureText = true;
  String? _currentSelectedItem;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    if (widget.isDropdown && widget.selectedDropdownItem != null) {
      _currentSelectedItem = widget.selectedDropdownItem;
    }
  }

  @override
  void didUpdateWidget(covariant ListingField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDropdown && widget.selectedDropdownItem != oldWidget.selectedDropdownItem) {
      setState(() {
        _currentSelectedItem = widget.selectedDropdownItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double iconSize = screenHeight * 0.022;

    Widget? prefixWidget;
    if (widget.customPrefixWidget != null) {
      prefixWidget = widget.customPrefixWidget;
    } else if (widget.prefixIcon != null) {
      prefixWidget = Icon(
        widget.prefixIcon,
        size: iconSize,
        color: Colors.white.withOpacity(0.5),
      );
    } else if (widget.prefixSvgPath != null) {
      prefixWidget = SvgPicture.asset(
        widget.prefixSvgPath!,
        height: iconSize,
        width: iconSize,
        // colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.srcIn),
      );
    } else if (widget.prefixPngPath != null) {
      prefixWidget = Image.asset(
        widget.prefixPngPath!,
        height: iconSize,
        width: iconSize,
        // color: Colors.white.withOpacity(0.5), // Apply color filter if needed for PNG
        fit: BoxFit.contain, // Adjust fit as needed
      );
    }

    return GestureDetector(
      onTap: widget.readOnly ? widget.onTap : null,
      child: Container(
        width: widget.width ?? screenWidth * 0.85,
        height: widget.expandable && !widget.isDropdown ? null : widget.height ?? screenHeight * 0.06,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.045,
          vertical: screenHeight * 0.012,
        ),
        decoration: ShapeDecoration(
          color: const Color(0XFF101A29),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.2, color: Color(0xFF141317)),
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
        // child: Row(
        //   children: [
        //     if (prefixWidget != null)
        //       Padding(
        //         padding: const EdgeInsets.only(right: 10),
        //         child: prefixWidget,
        //       ),
        //     Expanded(
        //       child: widget.isDropdown
        //           ? DropdownButtonFormField<String>(
        //         value: _currentSelectedItem,
        //         hint: Text(
        //           widget.labelText ?? 'Select an option',
        //           style: TextStyle(
        //             color: const Color(0XFF7D8FA9),
        //             fontSize: screenHeight * 0.015,
        //             fontFamily: 'Poppins',
        //             fontWeight: FontWeight.w400,
        //             height: 1.6,
        //           ),
        //         ),
        //         icon: Icon(
        //           Icons.arrow_drop_down,
        //           color: Colors.white.withOpacity(0.7),
        //           size: screenHeight * 0.025,
        //         ),
        //         dropdownColor: const Color(0XFF101A29),
        //         decoration: const InputDecoration(
        //           isCollapsed: true,
        //           border: InputBorder.none,
        //         ),
        //         style: TextStyle(
        //           fontFamily: 'Poppins',
        //           fontWeight: FontWeight.w400,
        //           fontSize: screenHeight * 0.015,
        //           height: 1.6,
        //           color: Colors.white.withOpacity(0.9),
        //         ),
        //         items: widget.dropdownItems?.map((String item) {
        //           return DropdownMenuItem<String>(
        //             value: item,
        //             child: Text(item),
        //           );
        //         }).toList(),
        //         onChanged: (String? newValue) {
        //           setState(() {
        //             _currentSelectedItem = newValue;
        //           });
        //           widget.onDropdownChanged?.call(newValue);
        //         },
        //       )
        //           : TextField(
        //         keyboardType: widget.keyboard,
        //         controller: widget.controller,
        //         maxLines: widget.expandable ? null : 1,
        //         obscureText: widget.isPassword ? _obscureText : false,
        //         readOnly: widget.readOnly,
        //         showCursor: !widget.readOnly,
        //         style: TextStyle(
        //           fontFamily: 'Poppins',
        //           fontWeight: FontWeight.w400,
        //           fontSize: screenHeight * 0.015,
        //           height: 1.6,
        //           color: Colors.white.withOpacity(0.9),
        //         ),
        //         decoration: InputDecoration(
        //           isCollapsed: true,
        //           border: InputBorder.none,
        //           hintText: widget.labelText,
        //           hintStyle: TextStyle(
        //             color: const Color(0XFF7D8FA9),
        //             fontSize: screenHeight * 0.015,
        //             fontFamily: 'Poppins',
        //             fontWeight: FontWeight.w400,
        //             height: 1.6,
        //           ),
        //         ),
        //       ),
        //     ),
        //     if (widget.isPassword)
        //       GestureDetector(
        //         onTap: () => setState(() => _obscureText = !_obscureText),
        //         child: Icon(
        //           _obscureText ? Icons.visibility_off : Icons.visibility,
        //           color: Colors.white.withOpacity(0.5),
        //           size: screenHeight * 0.022,
        //         ),
        //       ),
        //   ],
        // ),
        child: Row(
          children: [
            if (prefixWidget != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: prefixWidget,
              ),

            Expanded(
              child: widget.isDropdown
                  ? DropdownButtonFormField<String>(
                value: _currentSelectedItem,
                items: widget.dropdownItems?.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: screenHeight * 0.015,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  );
                }).toList(),
                onChanged: widget.onDropdownChanged,
                dropdownColor: const Color(0XFF101A29),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: screenHeight * 0.015,
                  fontFamily: 'Poppins',
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                iconEnabledColor: Colors.white.withOpacity(0.7),
              )
                  : TextField(
                keyboardType: widget.keyboard,
                controller: widget.controller,
                maxLines: widget.expandable ? null : 1,
                obscureText: widget.isPassword ? _obscureText : false,
                readOnly: widget.readOnly,
                showCursor: !widget.readOnly,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: screenHeight * 0.015,
                  height: 1.6,
                  color: Colors.white.withOpacity(0.9),
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: widget.labelText,
                  hintStyle: TextStyle(
                    color: const Color(0XFF7D8FA9),
                    fontSize: screenHeight * 0.015,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                ),
              ),
            ),

            if (widget.isPassword)
              GestureDetector(
                onTap: () => setState(() => _obscureText = !_obscureText),
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withOpacity(0.5),
                  size: iconSize,
                ),
              ),
          ],
        ),

      ),
    );
  }
}