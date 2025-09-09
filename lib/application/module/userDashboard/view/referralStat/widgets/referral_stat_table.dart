import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../../framework/utils/status_styling_utils.dart';
 import '../../../../../presentation/models/get_referral_user.dart';


Widget buildReferralUserListTable(List<ReferralUserListModel> userLogData, double screenWidth, BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  const double designScreenWidth = 375.0;

  TextStyle headingStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
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
        child: Text(text, style: style, textAlign: TextAlign.center, overflow: TextOverflow.visible),
      ),
    );
  }

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: screenHeight * 0.45,
            width: constraints.maxWidth * 1.5,
            child: DataTable2(
              dataRowHeight: screenHeight * 0.04,
              columnSpacing: screenWidth * 0.001,
              horizontalMargin: screenWidth * 0.002,
              headingRowHeight: screenHeight * 0.04,
              dividerThickness: 0,
              headingRowDecoration: const BoxDecoration(
                color: Color(0xff051121),
              ),
              columns: [
                DataColumn2(
                  label: buildCenteredText('SL', headingStyle),
                  fixedWidth: screenWidth * (40.0 / designScreenWidth),
                ),
                DataColumn2(label: buildCenteredText('Date', headingStyle), size: ColumnSize.L),
                DataColumn2(label: buildCenteredText('Name', headingStyle), size: ColumnSize.L),
                DataColumn2(label: buildCenteredText('User ID', headingStyle), size: ColumnSize.M),
                DataColumn2(label: buildCenteredText('Status', headingStyle), size: ColumnSize.M),
                // DataColumn2(
                //   label: buildCenteredText('Details', headingStyle),
                //   fixedWidth: screenWidth * (40.0 / designScreenWidth),
                // ),
              ],
              rows: userLogData.asMap().entries.map((entry) {
                ReferralUserListModel data = entry.value;
                final statusText = data.status;
                final statusStyle = getReferralUserStatusStyle(statusText);

                return DataRow2(
                  cells: [
                    // DataCell(buildCenteredText(data.sl, cellTextStyle)),
                    DataCell(buildCenteredText(data.date, cellTextStyle)),
                    DataCell(buildCenteredText(data.name, cellTextStyle)),
                    DataCell(buildCenteredText(data.userId, cellTextStyle)),
                    DataCell(
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: getResponsiveFontSize(context, 8),
                            vertical: getResponsiveFontSize(context, 4),
                          ),
                          decoration: BoxDecoration(
                            color: statusStyle.backgroundColor,
                            border: Border.all(color: statusStyle.borderColor, width: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            statusText,
                            style: cellTextStyle.copyWith(
                              color: statusStyle.textColor,
                              fontSize: getResponsiveFontSize(context, 11),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // DataCell(
                    //   Center(
                    //     child: IconButton(
                    //
                    //       icon: Icon(Icons.visibility_outlined, color: const Color(0xFF7EE4C2), size: getResponsiveFontSize(context, 18)),
                    //
                    //       onPressed: () {
                    //         showDialog(
                    //           context: context,
                    //           builder: (_) =>  ReferralDetails(data: data,),
                    //
                    //         );
                    //         print('View details for User ID: ${data.userId}');
                    //       },
                    //       tooltip: 'View Details',
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              }).toList(),
              empty: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'No matching user logs found.',
                    style: TextStyle(color: Colors.white70, fontSize: getResponsiveFontSize(context, 14)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
