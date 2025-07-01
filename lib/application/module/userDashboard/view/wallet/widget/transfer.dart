import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/viewmodel/wallet_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../../../framework/components/BlockButton.dart';
 import '../../../../../../framework/components/fieldContainerCompoenent.dart';
import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../../framework/utils/enums/field_type.dart';
import '../../../../../../framework/utils/general_utls.dart';

class Transfer extends StatefulWidget {
  final String? qrCode;

  const Transfer({super.key, this.qrCode});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {


  String selected = 'ETH';
  List<String> currencies = ['ETH', 'ECM'];
  String selectedOption = 'Crypto Wallet';
  bool isCheckSelected = false;
  late  TextEditingController _recipientController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();
  bool _isloading = false;



  @override
  void initState() {
    super.initState();
    _recipientController = TextEditingController(text: widget.qrCode ?? '');
  }
  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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
                                  'Transfer',
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

                              SizedBox(height: screenHeight * 0.02),


                              exChangeRate(exchangeRate: selected == "ETH" ? "1 ETH = \$10,000 USD" : "1 ECM = \$5,000 USD"),


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
                                controller: _amountController,
                                hintText: "0.00 ETH",
                              ),

                            ],
                          ),


                          SizedBox(height: screenHeight * 0.05),



                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Transfer Fee :',
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
                                '\$ 5.00 USD',
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

                          SizedBox(height: screenHeight * 0.04),


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
                                controller: _recipientController,
                                hintText: "0x123...56789",//For testing 0x30C8E35377208ebe1b04f78B3008AAc408F00D1d
                              ),

                            ],
                          ),



                          SizedBox(height: screenHeight * 0.04),


                          Align(
                            alignment: Alignment.center,
                            child: Consumer<WalletViewModel>(
                              builder: (context, model, _) {
                                return BlockButton(
                                  height: screenHeight * 0.045,
                                  width: screenWidth * 0.7,
                                  label: 'Confirm & Transfer',
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
                                  onTap: _isloading ? null : () async {
                                    //  Confirm Add Funds Transaction Process
                                    final recipient = _recipientController.text;
                                    final amountText = _amountController.text;
                                    final amount = double.tryParse(amountText);
                                    if(recipient.isEmpty || amountText.isEmpty) {
                                      Utils.showToast('Please fill out all fields', isError: true);
                                      return;
                                    }

                                    if (amount == null || recipient.isEmpty) {
                                      Utils.showToast('Please enter a valid amount or recipient address', isError: true);
                                      return;
                                    }

                                    setState(() => _isloading = true);

                                    try{

                                      await model.transferToken(recipient, amount);
                                      // Utils.showToast('Token transferred successfully!');
                                      _recipientController.clear();
                                      _amountController.clear();

                                    }catch(e){
                                      Utils.showToast('Error sending token: ${e.toString()}', isError: true);
                                      debugPrint("Error sending token: $e");
                                    }finally{
                                      if (mounted) setState(() => _isloading = false);
                                    }

                                  },
                                );
                              }

                              // child: BlockButton(
                              //   height: screenHeight * 0.045,
                              //   width: screenWidth * 0.7,
                              //   label: 'Confirm & Transfer',
                              //   textStyle: TextStyle(
                              //     fontWeight: FontWeight.w700,
                              //     color: Colors.white,
                              //     // fontSize: baseSize * 0.030,
                              //     fontSize: getResponsiveFontSize(context, 16),
                              //   ),
                              //   gradientColors: const [
                              //     Color(0xFF2680EF),
                              //     Color(0xFF1CD494),
                              //   ],
                              //   onTap: _isloading ? null : () async {
                              //     //  Confirm Add Funds Transaction Process
                              //     final recipient = _recipientController.text;
                              //     final amountText = _amountController.text;
                              //     final amount = double.tryParse(amountText);
                              //     if(recipient.isEmpty || amountText.isEmpty) {
                              //       Utils.showToast('Please fill out all fields', isError: true);
                              //       return;
                              //     }
                              //
                              //     if (amount == null || recipient.isEmpty) {
                              //       Utils.showToast('Please enter a valid amount or recipient address', isError: true);
                              //       return;
                              //     }
                              //
                              //     setState(() => _isloading = true);
                              //
                              //     try{
                              //
                              //       await model.transferToken(recipient, amount);
                              //       Utils.showToast('Token transferred successfully!');
                              //       _recipientController.clear();
                              //       _amountController.clear();
                              //
                              //     }catch(e){
                              //       Utils.showToast('Error sending token: ${e.toString()}', isError: true);
                              //       debugPrint("Error sending token: $e");
                              //     }finally{
                              //       if (mounted) setState(() => _isloading = false);
                              //     }
                              //
                              //
                              //
                              //
                              //   },
                              // ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          Expanded(
                            flex: 1,
                            child: Text(
                              'Note: Verify the recipient address carefully—errors can lead to loss of funds.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: getResponsiveFontSize(context, 12),
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.italic,
                               ),
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


  Widget exChangeRate({required String exchangeRate}) {
    return Row(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF277BF5), Color(0xFF1CD691)],
          ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: Text(
            'Exchange Rate:',
            style: TextStyle(
              color: Colors.white, // Required, but overridden by shader
              fontSize: getResponsiveFontSize(context, 12),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          exchangeRate,
          style: TextStyle(
            color: Colors.white,
            fontSize: getResponsiveFontSize(context, 12),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ],
    );
  }

}



