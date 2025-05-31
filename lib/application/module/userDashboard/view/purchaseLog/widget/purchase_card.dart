import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../../framework/res/colors.dart';
import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../domain/model/PurchaseLogModel.dart';


class PurchaseCard extends StatelessWidget {
  final PurchaseLogModel transaction;

  const PurchaseCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final DateFormat formatter = DateFormat('d MMMM yyyy');
    String formattedDate = formatter.format(transaction.date);

    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/logBg.png'),
              fit: BoxFit.fill,
             ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: ECM Coins | Ref: Jane Cooper
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/icons/logEcm.png', width: 40,height: 40,),
                  const SizedBox(width: 12.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.coinName,
                        style:  TextStyle(
                          color: AppColors.textColor,
                          fontSize: getResponsiveFontSize(context, 14),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/calender.svg',fit: BoxFit.fill,width: 16,),
                          const SizedBox(width: 8.0),
                          Text(
                            formattedDate,
                            style:  TextStyle(
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
                  SvgPicture.asset('assets/icons/reff.svg',fit: BoxFit.fill,width: 12,),
                  const SizedBox(width: 4.0),
                  Text(
                    'Ref: ${transaction.refName}',
                    style:  TextStyle(
                      color: AppColors.textColor,
                      fontSize: getResponsiveFontSize(context, 12),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.1,

                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),


              // Contract Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3, // more space to the left column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// Card name
                        Text(
                          transaction.contractName,
                          style: TextStyle(
                            color: Color(0XFF7D8FA9),
                            fontSize: getResponsiveFontSize(context, 12),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 4.0),

                        ///Sender Name
                        Text(
                          transaction.senderName,
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
                    flex: 2, // less space to the right column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end, // Align right
                      children: [
                         Text(
                          'ECM Amount',
                          style: TextStyle(
                            color: Color(0XFF7D8FA9),
                            fontSize: getResponsiveFontSize(context, 12),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '${transaction.ecmAmount.toStringAsFixed(2)} ECM',
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
              const SizedBox(height: 20.0),

              // Hash Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        height: 1.10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset('assets/icons/arrowIcon.svg',fit: BoxFit.fill,width: 12,),
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
