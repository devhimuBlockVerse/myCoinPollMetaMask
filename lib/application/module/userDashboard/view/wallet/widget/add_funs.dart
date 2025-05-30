import 'package:flutter/material.dart';

import '../../../../../../framework/components/ListingFields.dart';
import '../../../../../../framework/components/customOptionComponent.dart';
import '../../../../../../framework/components/fieldContainerCompoenent.dart';
import '../../../../../../framework/components/transactionDetailsComponent.dart';
import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../../framework/utils/enums/field_type.dart';


class AddFunds extends StatefulWidget {
  const AddFunds({super.key});

  @override
  State<AddFunds> createState() => _AddFundsState();
}

class _AddFundsState extends State<AddFunds> {

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
                padding: EdgeInsets.all(screenWidth * 0.09),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.85,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
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


                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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

                              SizedBox(height: screenHeight * 0.02),

                              // Text()
                              // Input mode
                              FieldContainer(
                                type: CustomInputType.input,
                                controller: amountController,
                                hintText: "0.00 ETH",
                              ),

                            ],
                          ),



                          SizedBox(height: screenHeight * 0.02),




                          Text(
                            'Payment Method',
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomOptionComponent(
                                label: 'Crypto Wallet',
                                isSelected: selectedOption == 'Crypto Wallet',
                                onTap: () {
                                  setState(() => selectedOption = 'Crypto Wallet');
                                },
                              ),
                              CustomOptionComponent(
                                label: 'Bank Transfer',
                                isSelected: selectedOption == 'Bank Transfer',
                                onTap: () {
                                  setState(() => selectedOption = 'Bank Transfer');
                                },
                              ),
                              CustomOptionComponent(
                                label: 'Credit Card',
                                isSelected: selectedOption == 'Credit Card',
                                onTap: () {
                                  setState(() => selectedOption = 'Credit Card');
                                },
                              ),
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

                          CustomOptionComponent(
                            label: 'Show QR Code (For crypto transfers only)',
                            isSquare: true,
                            isSelected: isCheckSelected,
                            onTap: () => setState(() => isCheckSelected = !isCheckSelected),
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


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Expanded(
                                child: Text(
                                  'Payment Method',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: getResponsiveFontSize(context, 16),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    // letterSpacing: -0.5,
                                    height: 0.11,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '\$3,5241 USD',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: getResponsiveFontSize(context, 16),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    // letterSpacing: -0.5,
                                    height: 0.11,
                                  ),
                                ),
                              ),
                            ],
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










