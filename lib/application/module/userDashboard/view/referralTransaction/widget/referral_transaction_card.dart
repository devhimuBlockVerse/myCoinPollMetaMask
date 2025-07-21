import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../../framework/res/colors.dart';
import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../data/dummyData/referral_transaction_dummy_data.dart';
import '../../../../../domain/model/PurchaseLogModel.dart';



class ReferralTransactionCard extends StatelessWidget {
  const ReferralTransactionCard({super.key, required this.transaction});
  final ReferralTransactionModel transaction;


    @override
    Widget build(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      final DateFormat formatter = DateFormat('d MMMM yyyy');
      String formattedDate = formatter.format(transaction.date);

      return Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.009),
        child: Container(
          decoration: BoxDecoration(

            image: DecorationImage(
              image: AssetImage('assets/images/logBg.png'),
              fit: BoxFit.fill,
            ),
            color: const Color(0xFF1E283A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Row (Coin Name and Date)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logEcm.png',
                      width: screenWidth * 0.11,
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.coinName,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: getResponsiveFontSize(context, 14),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.002),  // Reduced spacing
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/calender.svg',
                              width: screenWidth * 0.04,
                            ),
                            SizedBox(width: screenWidth * 0.015),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: AppColors.lightTextColor,
                                fontSize: getResponsiveFontSize(context, 12),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),

                /// User Info and Purchase Amount Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getResponsiveFontSize(context, 16),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            'UU ID : ${transaction.uuId}',
                            style: TextStyle(
                              color: const Color(0XFF7D8FA9),
                              fontSize: getResponsiveFontSize(context, 12),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Purchase Amount',
                            style: TextStyle(
                              color: const Color(0XFF7D8FA9),
                              fontSize: getResponsiveFontSize(context, 12),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            '${transaction.purchaseAmountECM.toStringAsFixed(2)} ECM',
                            style: TextStyle(
                              color: AppColors.accentGreen,
                              fontSize: getResponsiveFontSize(context, 16),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.025),

                /// Referral Bonus Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Referral Bonus :',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: getResponsiveFontSize(context, 12),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Text(
                      '${transaction.referralBonusMCM} MCM',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: getResponsiveFontSize(context, 12),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Container(
                      width: 1,
                      height: screenHeight * 0.02,
                      color: AppColors.lightTextColor,
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Text(
                      '${transaction.referralBonusETH} ETH',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: getResponsiveFontSize(context, 12),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),

                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
}
