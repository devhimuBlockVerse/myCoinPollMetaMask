import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../../../../framework/utils/status_styling_utils.dart';


Widget walletRecentTransaction(
    List<Map<String, dynamic>> walletTransactionData,
    double screenWidth,
    BuildContext context,
    ) {
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
        alignment: Alignment.center,
        child: Text(text, style: style, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: screenHeight * 0.4,
            width: constraints.maxWidth,
            child: DataTable2(
              columnSpacing: screenWidth * (10.0 / designScreenWidth),
              horizontalMargin: 0.0,
              dataRowHeight: screenHeight * 0.05,
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
                DataColumn2(
                  label: buildCenteredText('Date', headingStyle),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: buildCenteredText('Method', headingStyle),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: buildCenteredText('Currency', headingStyle),
                  size: ColumnSize.M,
                ),

                DataColumn2(
                  label: buildCenteredText('Status', headingStyle),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: buildCenteredText('Amount', headingStyle),
                  size: ColumnSize.M,
                ),
              ],
              rows: walletTransactionData.map((data) {
                final statusText = data['Status'] ?? '';
                final statusStyle = getStatusStyling(statusText); // Ensure this function exists

                return DataRow2(
                  cells: [
                    DataCell(buildCenteredText(data['SL']?.toString() ?? '', cellTextStyle)),
                    DataCell(buildCenteredText(data['Date']?.toString() ?? '', cellTextStyle)),
                    DataCell(buildCenteredText(data['Method']?.toString() ?? '', cellTextStyle)),
                    DataCell(buildCenteredText(data['Currency']?.toString() ?? '', cellTextStyle)),
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
                    DataCell(buildCenteredText(data['Amount']?.toString() ?? '', cellTextStyle)),

                  ],
                );
              }).toList(),
              empty: Center(
                child: Container(
                  padding: EdgeInsets.all(screenWidth * (20.0 / designScreenWidth)),
                  child: Text(
                    'No matching transactions found.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: getResponsiveFontSize(context, 14),
                    ),
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
