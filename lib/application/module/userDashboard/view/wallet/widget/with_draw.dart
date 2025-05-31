import 'package:flutter/material.dart';
import '../../../../../../framework/components/BlockButton.dart';
import '../../../../../../framework/components/customOptionComponent.dart';
import '../../../../../../framework/components/fieldContainerCompoenent.dart';
import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../../framework/utils/enums/field_type.dart';

class WithDraw extends StatefulWidget {
  const WithDraw({super.key});

  @override
  State<WithDraw> createState() => _WithDrawState();
}

class _WithDrawState extends State<WithDraw> {

  String selected = 'ETH';
  List<String> currencies = ['ETH', 'ECM'];
  String selectedOption = 'Crypto Wallet';
  bool isCheckSelected = false;

  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
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
                padding: EdgeInsets.all(screenWidth * 0.08),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.85,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Withdraw',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                    height: 1.10,
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
                          SizedBox(height: screenHeight * 0.01),

                          SizedBox(
                            width: screenWidth * 0.9,
                            child: Divider(
                              color: Colors.white.withOpacity(0.10),
                              thickness: screenHeight * 0.0015,
                              height: screenHeight * 0.015,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),


                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Select Currency',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getResponsiveFontSize(context, 14),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  // letterSpacing: -0.5,
                                  height: 0.11,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              FieldContainer(
                                imgUrl: selected == "ETH" ? "assets/icons/eth.png" : "assets/icons/ecmSmall.png",
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

                              SizedBox(height: screenHeight * 0.03),

                              Text(
                                'Enter Amount',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getResponsiveFontSize(context, 14),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  // letterSpacing: -0.5,
                                  height: 0.11,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),

                              // Input mode
                              FieldContainer(
                                type: CustomInputType.input,
                                controller: amountController,
                                hintText: "0.00 ETH",
                              ),

                            ],
                          ),


                          SizedBox(height: screenHeight * 0.03),


                          Text(
                            'Withdrawal Method :',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getResponsiveFontSize(context, 14),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              // letterSpacing: -0.5,
                              height: 0.11,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              CustomOptionComponent(
                                label: 'Credit Card',
                                isSelected: selectedOption == 'Credit Card',
                                onTap: () {
                                  setState(() => selectedOption = 'Credit Card');
                                },
                              ),
                              SizedBox(width: screenWidth * 0.01),

                              CustomOptionComponent(
                                label: 'Bank Transfer',
                                isSelected: selectedOption == 'Bank Transfer',
                                onTap: () {
                                  setState(() => selectedOption = 'Bank Transfer');
                                },
                              ),
                              SizedBox(width: screenWidth * 0.01),

                              CustomOptionComponent(
                                label: 'Crypto Wallet',
                                isSelected: selectedOption == 'Crypto Wallet',
                                onTap: () {
                                  setState(() => selectedOption = 'Crypto Wallet');
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.01),

                          SizedBox(
                            width: screenWidth * 0.9,
                            child: Divider(
                              color: Colors.white.withOpacity(0.10),
                              thickness: screenHeight * 0.0015,
                              height: screenHeight * 0.015,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Withdrawal Fee :',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getResponsiveFontSize(context, 12),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  // letterSpacing: -0.5,
                                  height: 0.11,
                                ),
                              ),
                              // SizedBox(width: screenWidth * 0.02),

                              Text(
                                '0.01 ETH',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getResponsiveFontSize(context, 12),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  // letterSpacing: -0.5,
                                  height: 0.11,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.02),


                          SizedBox(
                            width: screenWidth * 0.9,
                            child: Divider(
                              color: Colors.white.withOpacity(0.10),
                              thickness: screenHeight * 0.0015,
                              height: screenHeight * 0.015,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),


                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'Recipient Wallet Address ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: getResponsiveFontSize(context, 12),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    height: 0.11,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '(for crypto only)',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.50),
                                        fontSize: getResponsiveFontSize(context, 12),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 0.11,

                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.start,
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              // Input mode
                              FieldContainer(
                                type: CustomInputType.input,
                                controller: amountController,
                                hintText: "0x123...56789",
                              ),

                            ],
                          ),



                          SizedBox(height: screenHeight * 0.04),


                          Align(
                            alignment: Alignment.center,
                            child: BlockButton(
                              height: screenHeight * 0.045,
                              width: screenWidth * 0.7,
                              label: 'Confirm & Withdraw',
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                // fontSize: baseSize * 0.030,
                                fontSize: getResponsiveFontSize(context, 16),
                              ),
                              gradientColors: const [
                                Color(0xFF2680EF),
                                Color(0xFF1CD494),
                              ],
                              onTap: () {
                                //  Confirm Add Funds Transaction Process

                              },
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          Text(
                            'Note: Processing may take 1-3 business days.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getResponsiveFontSize(context, 12),
                              fontFamily: 'Poppins',
                               fontStyle: FontStyle.italic,
                               // height: 0.11,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),


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
