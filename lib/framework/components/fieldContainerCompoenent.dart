import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/framework/utils/dynamicFontSize.dart';

import '../utils/enums/field_type.dart';
class FieldContainer extends StatelessWidget {
  final List<String>? items;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;
  final CustomInputType type;
  final TextEditingController? controller;
  final String? hintText;
  final String? imgUrl;

  const FieldContainer({
    Key? key,
    this.items,
    this.selectedItem,
    this.onChanged,
    this.controller,
    this.hintText,
    this.type = CustomInputType.dropdown, this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double containerWidth = screenWidth * 0.8;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 10),
      decoration: ShapeDecoration(
        color: const Color(0xFF101A29),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF141317)),
          borderRadius: BorderRadius.circular(8),
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
      child: type == CustomInputType.dropdown
          ? DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          isExpanded: true,
          value: selectedItem,
          dropdownColor: const Color(0xFF101A29),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
          onChanged: onChanged,
          items: items?.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(3.14),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration:  BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imgUrl!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(value),
                ],
              )
            );
          }).toList(),
        ),
      )
          : TextFormField(
        controller: controller,
        style:  TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: getResponsiveFontSize(context, 16),
          fontWeight: FontWeight.w300,
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: hintText ?? "0.00 ETH",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontFamily: 'Poppins',
            fontSize: getResponsiveFontSize(context, 16),
            fontWeight: FontWeight.w300,),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
