import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ListingField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? labelText;
  final double? height;
  final double? width;
  final bool expandable;
  final TextInputType? keyboard;
  final bool isPassword;
  final IconData? prefixIcon;
  final String? prefixSvgPath;
  final String? prefixPngPath;
  final Widget? customPrefixWidget;
  final bool readOnly;
  final VoidCallback? onTap;

  final bool isDropdown;
  final List<String>? dropdownItems;
  final String? selectedDropdownItem;
  final ValueChanged<String?>? onDropdownChanged;

  const ListingField({
    super.key,
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
    this.customPrefixWidget,
    this.readOnly = false,
    this.onTap,
    this.isDropdown = false,
    this.dropdownItems,
    this.selectedDropdownItem,
    this.onDropdownChanged,
    this.onChanged,
  });

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
    if (widget.isDropdown &&
        widget.selectedDropdownItem != oldWidget.selectedDropdownItem) {
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

    double responsiveFontSize = screenHeight * 0.015;

    double prefixIconRightPadding = screenWidth * 0.025;

    double responsiveBorderRadius = screenHeight * 0.004;
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
         fit: BoxFit.contain,
      );
    }

    return GestureDetector(
      onTap: widget.readOnly ? widget.onTap : null,
      child: Container(
        width: widget.width ?? screenWidth * 0.85,
        height: widget.expandable && !widget.isDropdown
            ? null
            : widget.height ?? screenHeight * 0.06,


        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.045,
          // vertical: screenHeight * 0.012,
        ),
        decoration: ShapeDecoration(
          color: const Color(0XFF101A29),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.2, color: Color(0xFF141317)),
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
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
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (prefixWidget != null)
                Padding (
                  padding: EdgeInsets.only(right: prefixIconRightPadding), // Made responsive
                  child: Align(
                      alignment: Alignment.center,
                      child: prefixWidget),
                ),
              Expanded(
                child: widget.isDropdown
                    ? DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _currentSelectedItem,
                   items: widget.dropdownItems?.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: responsiveFontSize,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    'Select Duration',
                    style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: responsiveFontSize,
                    fontFamily: 'Poppins',),
                  ),
                  onChanged: widget.onDropdownChanged,
                  dropdownColor: const Color(0XFF101A29),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: responsiveFontSize,
                    fontFamily: 'Poppins',
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  iconEnabledColor: Colors.white.withOpacity(0.7),
                )
                    : Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // helps avoid overflow

                        children: [
                          Expanded(
                            child: TextField(
                            
                            keyboardType: widget.keyboard,
                            controller: widget.controller,
                            // maxLines: widget.isPassword ? 1 : null,
                              maxLines: widget.isPassword ? 1 : (widget.expandable ? null : 1),

                            minLines: 1,
                             obscureText: widget.isPassword ? _obscureText : false,
                            readOnly: widget.readOnly,
                            showCursor: !widget.readOnly,
                            onChanged: widget.onChanged,
                            textAlignVertical: TextAlignVertical.top,
                            scrollPhysics: const BouncingScrollPhysics(),
                            scrollController: ScrollController(),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: responsiveFontSize,
                              height: 1.6,
                              color: Colors.white.withOpacity(0.9),
                            ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 11), // key to vertical centering
                                isDense: true,
                                isCollapsed: false,
                                border: InputBorder.none,
                                hintText: widget.labelText,
                                hintStyle: TextStyle(
                                  color: const Color(0XFF7D8FA9),
                                  fontSize: responsiveFontSize,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ),
                        ],
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
      ),
    );
  }
}










