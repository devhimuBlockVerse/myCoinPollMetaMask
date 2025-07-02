import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:mycoinpoll_metamask/application/presentation/models/get_staking_history.dart';

import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../../framework/utils/status_styling_utils.dart';

// Widget buildStakingTable(List<Map<String, dynamic>> stakingData, double screenWidth, BuildContext context) {
//   double baseSize = screenWidth * 0.9;
//   double screenHeight = MediaQuery.of(context).size.height;
//   const double designScreenWidth = 375.0;
//
//
//   TextStyle headingStyle = TextStyle(
//     color: Colors.white,
//     fontFamily: 'Poppins',
//     fontWeight: FontWeight.w500,
//     // fontSize: baseSize * 0.035,
//     fontSize: getResponsiveFontSize(context, 12),
//     height: 1.6,
//   );
//
//   TextStyle cellTextStyle = TextStyle(
//     color: Colors.white,
//     fontFamily: 'Poppins',
//     fontWeight: FontWeight.w400,
//     fontSize: getResponsiveFontSize(context, 12),
//     height: 1.6,
//   );
//
//   Widget buildCenteredText(String text, TextStyle style) {
//     return Center(
//       child: FittedBox(
//         fit: BoxFit.scaleDown,
//         child: Text(text, style: style, textAlign: TextAlign.center,overflow: TextOverflow.visible,),
//       ),
//     );
//   }
//
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
//     child: LayoutBuilder(
//       builder: (context, constraints) {
//         return SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: SizedBox(
//             height: screenHeight * 0.4,
//             width: constraints.maxWidth,
//
//
//             child: DataTable2(
//               // dataRowHeight: baseSize * 0.12,
//               dataRowHeight: screenHeight * 0.04,
//
//               columnSpacing: screenWidth * 0.001,
//               horizontalMargin: screenWidth * 0.002,
//               headingRowHeight: screenHeight * 0.06,
//               dividerThickness: 0,
//               columns: [
//                 DataColumn2(label: buildCenteredText('SL', headingStyle),
//                   fixedWidth: screenWidth * (40.0 / designScreenWidth),
//
//                 ),
//                 DataColumn2(label: buildCenteredText('Date', headingStyle), size: ColumnSize.L),
//                 DataColumn2(label: buildCenteredText('Duration', headingStyle), size: ColumnSize.L),
//                 DataColumn2(label: buildCenteredText('Reward', headingStyle), size: ColumnSize.M),
//                 DataColumn2(label: buildCenteredText('Amount', headingStyle), size: ColumnSize.S),
//                 DataColumn2(label: buildCenteredText('Status', headingStyle), size: ColumnSize.L),
//               ],
//               rows: stakingData.map((data) {
//                 final statusText = data['Status'] ?? '';
//                 final statusStyle = getStatusStyling(statusText);
//
//                 return DataRow2(
//
//                   cells: [
//                     DataCell(buildCenteredText(data['SL'] ?? '', cellTextStyle)),
//                     DataCell(buildCenteredText(data['Date'] ?? '', cellTextStyle)),
//                     DataCell(buildCenteredText(data['Duration'] ?? '', cellTextStyle)),
//                     DataCell(buildCenteredText(data['Reward'] ?? '', cellTextStyle)),
//                     DataCell(buildCenteredText(data['Amount'] ?? '', cellTextStyle)),
//                     DataCell(
//                       Center(
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: screenWidth * 0.02,
//                             vertical: screenWidth * 0.006,
//                           ),
//                           // padding:  EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
//                           decoration: BoxDecoration(
//                             color: statusStyle.backgroundColor,
//                             border: Border.all(
//                               color: statusStyle.borderColor,
//                               width: 0.5,
//                             ),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: FittedBox(
//                             fit: BoxFit.scaleDown,
//                             child: Text(
//                               data['Status'] ?? '',
//                               style: cellTextStyle.copyWith(color: statusStyle.textColor),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     ),
//   );
//  }
Widget buildStakingTable(List<StakingHistoryModel> stakingData, double screenWidth, BuildContext context) {
  double baseSize = screenWidth * 0.9;
  double screenHeight = MediaQuery.of(context).size.height;
  const double designScreenWidth = 375.0;


  TextStyle headingStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    // fontSize: baseSize * 0.035,
    fontSize: getResponsiveFontSize(context, 12),
    height: 1.6,
  );

  TextStyle cellTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: getResponsiveFontSize(context, 12),
    height: 1.6,
  );

  Widget buildCenteredText(String text, TextStyle style) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text, style: style, textAlign: TextAlign.center,overflow: TextOverflow.visible,),
      ),
    );
  }

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: screenHeight * 0.4,
            width: constraints.maxWidth,


            child: DataTable2(
              // dataRowHeight: baseSize * 0.12,
              dataRowHeight: screenHeight * 0.04,

              columnSpacing: screenWidth * 0.001,
              horizontalMargin: screenWidth * 0.002,
              headingRowHeight: screenHeight * 0.06,
              dividerThickness: 0,
              columns: [
                DataColumn2(label: buildCenteredText('SL', headingStyle),
                  fixedWidth: screenWidth * (40.0 / designScreenWidth),

                ),
                DataColumn2(label: buildCenteredText('Date', headingStyle), size: ColumnSize.L),
                DataColumn2(label: buildCenteredText('Duration', headingStyle), size: ColumnSize.L),
                DataColumn2(label: buildCenteredText('Reward', headingStyle), size: ColumnSize.M),
                DataColumn2(label: buildCenteredText('Amount', headingStyle), size: ColumnSize.S),
                DataColumn2(label: buildCenteredText('Status', headingStyle), size: ColumnSize.L),
              ],
              rows: List<DataRow2>.generate(stakingData.length, (index) {

                final data = stakingData[index];
                final statusText = data.status;
                final statusStyle = getStatusStyling(statusText);

                return DataRow2(

                  cells: [
                    DataCell(buildCenteredText((index +1).toString(), cellTextStyle)),
                    DataCell(buildCenteredText(data.createdAtFormatted, cellTextStyle)),
                    DataCell(buildCenteredText('${data.duration} Days', cellTextStyle)),
                    DataCell(buildCenteredText(data.reward, cellTextStyle)),
                    DataCell(buildCenteredText(data.amount, cellTextStyle)),
                    DataCell(
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenWidth * 0.006,
                          ),
                           decoration: BoxDecoration(
                            color: statusStyle.backgroundColor,
                            border: Border.all(
                              color: statusStyle.borderColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              statusText,
                              style: cellTextStyle.copyWith(color: statusStyle.textColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    ),
  );
 }




