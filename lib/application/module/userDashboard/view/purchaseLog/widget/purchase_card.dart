import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../../framework/res/colors.dart';
import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../domain/model/PurchaseLogModel.dart';

class PurchaseCard extends StatelessWidget {
  final PurchaseLogModel transaction;
  final bool visible;
  final int index;

  const PurchaseCard({Key? key, required this.transaction, required this.visible,required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final DateFormat formatter = DateFormat('d MMMM yyyy');
     String formattedDate = formatter.format(DateTime.parse(transaction.createdAt));


    final slideDuration = Duration(milliseconds: 400);
    final fadeDuration = Duration(milliseconds: 300);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.009),
      child: AnimatedPadding(
        duration: slideDuration,
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(left: visible ? 0 : screenWidth),

        child: AnimatedOpacity(
          duration: fadeDuration,
          opacity: visible ? 1.0 : 0.0,
          curve: Curves.easeIn,
          child: Container(
           
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logBg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/logEcm.png',
                        width: screenWidth * 0.11,
                       ),
                      SizedBox(width: screenWidth * 0.01),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // transaction.coinName,
                              "ECM",
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: getResponsiveFontSize(context, 14),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/calender.svg',
                                  width: screenWidth * 0.04,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Expanded(
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                      color: AppColors.lightTextColor,
                                      fontSize: getResponsiveFontSize(context, 12),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 1.6,
                                    ),


                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/reff.svg',
                            width: screenWidth * 0.03,
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Text(
                            // 'Ref: ${transaction.referralUserId}',
                            transaction.referralUserId != null
                                ? 'Ref: ${transaction.referralUserId}'
                                : 'Ref: N/A',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: getResponsiveFontSize(context, 12),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  /// Contract Details
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        // flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              transaction.icoStage,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: getResponsiveFontSize(context, 16),
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
                              'ECM Amount',
                              style: TextStyle(
                                color: const Color(0XFF7D8FA9),
                                fontSize: getResponsiveFontSize(context, 12),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              '${transaction.amount.toStringAsFixed(2)} ECM',
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

                  /// Hash Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Hash: ${transaction.hash}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getResponsiveFontSize(context, 12),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      InkWell(
                        onTap: () {

                        },
                        child: SvgPicture.asset(
                          'assets/icons/arrowIcon.svg',
                          width: screenWidth * 0.03,
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
    );
  }
}
