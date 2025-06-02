import 'package:flutter/material.dart';

import '../../../../../../framework/components/referralStatDetailComponenet.dart';
import '../../../../../../framework/components/transactionDetailsComponent.dart';



class ReferralDetails extends StatelessWidget {
  const ReferralDetails({super.key});


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
                                  'Transactions Details',
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
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'Jane Cooper',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.08,
                              color: const Color(0xffFFF5ED),
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),

                          const ReferralDetailsComponent(
                            label: 'Time/Date',
                            value: '07/10/2024; 09:30 PM',
                          ),
                          const ReferralDetailsComponent(
                            label: 'User ID',
                            value: '5320127',
                          ),
                          const ReferralDetailsComponent(
                            label: 'Status',
                            value: '',
                            status: 'Active',
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          const ReferralDetailsComponent(
                            label: 'Phone',
                            value: '(704) 555-0127',
                            svgIconPath: 'assets/icons/copyImg.svg',
                          ),
                          const ReferralDetailsComponent(
                            label: 'Email',
                            value: 'deanna.curtis@example.com',
                            svgIconPath: 'assets/icons/copyImg.svg',
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
