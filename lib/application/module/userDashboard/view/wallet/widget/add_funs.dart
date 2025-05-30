import 'package:flutter/material.dart';

import '../../../../../../framework/components/ListingFields.dart';
import '../../../../../../framework/components/transactionDetailsComponent.dart';


class AddFunds extends StatefulWidget {
  const AddFunds({super.key});

  @override
  State<AddFunds> createState() => _AddFundsState();
}

class _AddFundsState extends State<AddFunds> {

  String selected = 'ETH';
  List<String> currencies = ['ETH', 'BTC'];
  String selectedOption = 'Crypto Wallet';
  bool isCheckSelected = false;


  TextEditingController amountController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;



    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/icons/dialogFrame.png',
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.09),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.85,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Add Funds',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: screenWidth * 0.06,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: screenWidth * 0.9,
                            child: Divider(
                              color: Colors.white.withOpacity(0.10),
                              thickness: screenHeight * 0.0015,
                              height: screenHeight * 0.015,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                           CustomDropdownSelect(
                            items: currencies,
                             type: CustomInputType.dropdown,
                            selectedItem: selected,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selected = value;
                                });
                              }
                            },
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Input mode
                          CustomDropdownSelect(
                            type: CustomInputType.input,
                            controller: amountController,
                            hintText: "Enter amount",
                          ),


                          SizedBox(height: screenHeight * 0.02),



                          CustomRadioOption(
                            label: 'Crypto Wallet',
                            isSelected: selectedOption == 'Crypto Wallet',
                            onTap: () {
                              setState(() => selectedOption = 'Crypto Wallet');
                            },
                          ),
                          const SizedBox(height: 8),
                          CustomRadioOption(
                            label: 'Bank Wallet',
                            isSelected: selectedOption == 'Bank Wallet',
                            onTap: () {
                              setState(() => selectedOption = 'Bank Wallet');
                            },
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          CustomRadioOption(
                            label: 'Bank Account',
                            isSquare: true,
                            isSelected: isCheckSelected,
                            onTap: () => setState(() => isCheckSelected = !isCheckSelected),
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}





class CustomRadioOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSquare;

  const CustomRadioOption({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isSquare = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Screen dimensions for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // Responsive sizes
    double boxSize = isPortrait ? screenWidth * 0.05 : screenHeight * 0.05;
    double innerBoxSize = boxSize * 0.6;
    double fontSize = isPortrait ? screenWidth * 0.035 : screenHeight * 0.035;
    double spacing = isPortrait ? screenWidth * 0.02 : screenHeight * 0.02;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Outer box
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              border: Border.all(
                width: 1,
                color: const Color(0xFF277BF5).withOpacity(0.50),
              ),
              borderRadius: isSquare ? BorderRadius.circular(4) : null,
            ),
            child: isSelected
                ? Center(
              child: isSquare
                  ? Icon(
                Icons.check,
                size: innerBoxSize,
                color: Colors.white,
              )
                  : Container(
                width: innerBoxSize,
                height: innerBoxSize,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color(0xFF277BF5),
                      Color(0xFF1CD691),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            )
                : null,
          ),
          SizedBox(width: spacing),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontFamily: 'Poppins',
              letterSpacing: -0.6,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}



enum CustomInputType { dropdown, input }

class CustomDropdownSelect extends StatelessWidget {
  final List<String>? items;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;
  final CustomInputType type;
  final TextEditingController? controller;
  final String? hintText;

  const CustomDropdownSelect({
    Key? key,
    this.items,
    this.selectedItem,
    this.onChanged,
    this.controller,
    this.hintText,
    this.type = CustomInputType.dropdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double containerWidth = screenWidth * 0.8;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
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
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://picsum.photos/24/24"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      )
          : TextFormField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: hintText ?? "Enter amount",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

